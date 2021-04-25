import os
from sys import platform, exit
import ast

from Helpers import *
from Constants import *


class Compiler:
    def __init__(self, filePath):
        self.filePath = filePath
        self.fileName = os.path.splitext(os.path.basename(self.filePath))[0]
        self.data = []
        self.packets = [dict(packetDict())]
        self.delay = [0]
        self.outputData = []
        self.__parse()
        self.__createPackets()
        self.__getDelay()

    def __parse(self):
        """
        Parse the input .ss file

        Output:
        A list of instructions represented as a list of data
        [opcode, outputs, inputs]
        """
        flag = False
        with open(self.filePath, "r") as fp:
            fileData = fp.readlines()
        opCode = getOPCode()
        for x in fileData:
            y = x.split()
            if not y:
                continue
            if y[0] == "//":
                continue
            j = [opCode[y[0]]]
            for i in range(1, len(y), 1):
                if y[i] in ["R0", "r0", "R31", "r31"]:
                    print('\x1b[6;31;49m'+f"ERROR: In line {fileData.index(x)+1}, {y[i]} is a reserved register, Use a different register.\n"+'\x1b[0m')
                    flag = True
                j.append(y[i].upper())
            if j[0] in ["10010", "10011", "10100"]:
                if x.find("#") == -1:
                    print('\x1b[6;31;49m'+f"ERROR: In line {fileData.index(x)+1}, Immediate opperand is required for memory access instructions.\n"+'\x1b[0m')
                    flag = True
                if x.count("#") > 1:
                    print('\x1b[6;31;49m'+f"ERROR: In line {fileData.index(x)+1}, Multiple immediate opperand is not supported.\n"+'\x1b[0m')
                    flag = True
                if x.find("#") != -1:
                    if y[1][0] == "#":
                        z = y[1]
                    else:
                        z = y[2]
                    if len(bin(int(z[1:]))[2:]) > 22:
                        print('\x1b[6;35;49m'+f"WARNING: In line {fileData.index(x)+1}, Immediate operand is larger than 22 bits, it will be truncated.\n"+'\x1b[0m')
                j.append("R0")
            else:
                if x.find("#") != -1:
                    print('\x1b[6;31;49m'+f"ERROR: In line {fileData.index(x)+1}, Immediate opperand is not supported for arithmetic and logic instructions.\n"+'\x1b[0m')
                    flag = True
            self.data.append(j)
        if flag:
            exit()

    def __createPackets(self):
        """
        Create packets of instructions for the VLIW processor

        Output:
        - A list of packets represented as dictionary returned by packetDict
        """
        # Flag, if added to any packet
        flag = False
        # Flags for war, waw, raw dependencies
        check_war = False
        check_waw = False
        check_raw = False
        # Loop through all the data from the .ss file
        for data in self.data:
            # Get the keys for the data
            packetKey, optionalKey = getPacketKey(data[0])
            # Loop through the instruction packets
            for packet in self.packets:
                currentIdx = self.packets.index(packet)
                # Loop through all the successors of the current packet
                for successor in self.packets[currentIdx+1:]:
                    # Check data dependencies among the input instruction and the successor packets
                    check_war = checkWAR(successor, data)
                    check_waw = checkWAW(successor, data)
                    check_raw = checkRAW(successor, data)
                    # If there is a dependency, break
                    if check_war or check_waw or check_raw:
                        break
                # If there are no dependencies, add the instruction in the packet and break if added
                if not check_war and not check_waw and not check_raw:
                    flag = addInst(packet, packetKey, optionalKey, data)
                    if flag:
                        break
            # If the instruction is not added, create a new packet and add the data
            if not flag:
                self.packets.append(dict(packetDict()))
                self.packets[-1][packetKey] = data
                self.delay.append(0)
            # Reset the flags
            flag = False
            check_war = False
            check_waw = False
            check_raw = False

    def __getDelay(self):
        """
        Generates the delays between two packets based on its contents

        Output:
        List of all delays to be used with corresponding packet in Verilog
        """
        # Loop through all the packet of instructions
        for packet in self.packets:
            # Get the current index of the packet of instructions
            currentIdx = self.packets.index(packet)
            # Loop through all the packet items
            for module, inst in packet.items():
                # Check if the list is not empty
                if inst:
                    # Loop through all the instructions from the current index in reverse order
                    for predecessorIdx in range(currentIdx-1, -1, -1):
                        # Compute the delay needed for RAW dependency
                        rawDelay = checkRAW2(
                            self.packets[predecessorIdx], packet)
                        # Compute the delay needed for WAW dependency
                        wawDelay = checkWAW2(
                            self.packets[predecessorIdx], packet)
                        # If there is a predecessor with same module in consecutive instructions
                        if self.packets[predecessorIdx][module]:
                            # Compute the necessary delay
                            self.delay[currentIdx] = max(
                                moduleDelay[module] -
                                sum(self.delay[predecessorIdx+1:currentIdx]),
                                self.delay[currentIdx])
                        # If there is a RAW dependency among two packets
                        if rawDelay:
                            # Compute the necessary delay
                            self.delay[currentIdx] = max(
                                rawDelay - sum(self.delay[predecessorIdx+1:currentIdx]), self.delay[currentIdx])
                        # If there is a WAW dependency among two packets
                        if wawDelay:
                            # Compute the necessary delay
                            self.delay[currentIdx] = max(
                                wawDelay - sum(self.delay[predecessorIdx+1:currentIdx]), self.delay[currentIdx])

    def generateTestBench(self):
        """
        Generates a testbench for the processor verilog modules

        Output: Returns a testbench (.v) file
        """
        for it in range(1, len(self.delay)):
            self.delay[it] += self.delay[it-1]
        binPacket = []
        # Get the binary version of the packets to be written in the test bench
        for packet in self.packets:
            binPacket.append(packetBinary(packet))
        # Assigning the instructions to the wires in testbench
        assignInst = ""
        for it in range(len(binPacket)):
            assignInst += f"\tassign instructions[{it}] = {binPacket[it]};\n"
        # Assigning the delays to the wires in testbench
        assignDelay = ""
        for it in range(len(binPacket)):
            assignDelay += f"\tassign index[{it}] = {self.delay[it]};\n"
        # Formating the testbench variable with input instructions
        testBenchPath = f"Verilog_Modules\{self.fileName}.v"
        with open(testBenchPath, "w") as fp:
            fp.write(testBench.format(
                nInst=len(binPacket), inst=assignInst, delay=assignDelay, finish=len(binPacket)*30))

    def executeTestBench(self):
        """
        Execute the testbench for the processor verilog modules

        Output: Compiles the verilog file and stores the data of the register file after performing the operations specified by the user
        """
        os.chdir("Verilog_Modules")
        # Compiling the verilog testbench 
        os.system(f"iverilog -o {self.fileName} {self.fileName}.v")
        print("Generating random values for register file and memory block...\n")
        # For Linux / MacOS systems storing the data of the register file 
        if platform in ["linux", "darwin"]:
            os.system(f"./{self.fileName} > {self.fileName}.txt")
        # For Windows systems storing the data of the register file 
        elif platform == "win32":
            os.system(f"vvp {self.fileName} > {self.fileName}.txt")
        # Opening the stored output file in read mode s
        with open(f"{self.fileName}.txt", "r") as fp:
            data = fp.read()
        print("Compiling the register values...\n")
        output = []
        data = data.replace(" ", "")
        # Converting the file to the list of dictionary 
        while True:
            if data.find("}") == -1:
                break
            else:
                end = data.index("}")
                timeDict = ast.literal_eval(data[:end+1])
                output.append(timeDict)
                data = data[end+1:]
        self.outputData.append(output[0])
        # Removing intermediate register file output
        for out in range(1, len(output)):
            for key in output[out].keys():
                if output[out][key] != output[out-1][key] and key != "time" and key != "31":
                    self.outputData.append(output[out])
                    break
        os.remove(f"{self.fileName}")
        os.remove(f"{self.fileName}.txt")
