from Helpers import *
from Constants import moduleDelay


class Compiler:
    def __init__(self, filePath):
        self.filePath = filePath
        self.data = []
        self.packets = [dict(packetDict())]
        self.delay = [0]
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
        with open(self.filePath, "r") as fp:
            fileData = fp.readlines()
        opCode = getOPCode()
        for x in fileData:
            y = x.split()
            if y[0] == "//":
                continue
            j = [opCode[y[0]]]
            for i in range(1, len(y), 1):
                j.append(y[i].upper())
            if j[0] in ["10010", "10011", "10100"]:
                j.append("R0")
            self.data.append(j)

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
