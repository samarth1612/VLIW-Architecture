from Helpers import *
from Constants import moduleDelay


class Compiler:
    def __init__(self, filePath):
        self.filePath = filePath
        self.data = []
        self.packets = [dict(packetDict())]
        self.parse()
        self.delay = [0]

    def parse(self):
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
                j.append(y[i])
            self.data.append(j)

    def createPackets(self):
        """
        Create packets of instructions for the VLIW processor

        Output:
        - A list of packets represented as dictionary returned by packetDict
        """
        flag = False
        check = False
        for data in self.data:
            packetKey, optionalKey = getPacketKey(data[0])
            for packet in self.packets:
                currentIdx = self.packets.index(packet)
                for successor in self.packets[currentIdx:]:
                    for module, inst in successor.items():
                        if not inst:
                            continue
                        op_1, op_2 = getOperands(inst)
                        out_1, out_2 = getOutput(data)
                        if data[0] == "00100":
                            if out_1 in [op_1, op_2] or out_2 in [op_1, op_2]:
                                check = True
                                break
                        else:
                            if out_1 in [op_1, op_2]:
                                check = True
                                break
                    if check:
                        break
                if check:
                    flag = addInst(
                        self.packets[-1], packetKey, optionalKey, data)
                    break
                else:
                    flag = addInst(packet, packetKey, optionalKey, data)
                if flag:
                    break
            if not flag:
                self.packets.append(dict(packetDict()))
                self.packets[-1][packetKey] = data
                self.delay.append(0)
            flag = False
        self.getDelay()

    def getDelay(self):
        """
        Generates the delays between two packets based on its contents

        Output:
        List of all delays to be used with corresponding packet in Verilog
        """
        for packet in self.packets:
            currentIdx = self.packets.index(packet)
            for module, inst in packet.items():
                if inst:
                    for predecessorIdx in range(currentIdx-1, -1, -1):
                        rawDelay = checkRAW2(
                            self.packets[predecessorIdx], packet)
                        wawDelay = checkWAW2(
                            self.packets[predecessorIdx], packet)
                        if self.packets[predecessorIdx][module]:
                            self.delay[currentIdx] = max(
                                moduleDelay[module] -
                                sum(self.delay[predecessorIdx+1:currentIdx]),
                                self.delay[currentIdx])
                        if rawDelay:
                            self.delay[currentIdx] = max(
                                rawDelay - sum(self.delay[predecessorIdx+1:currentIdx]), self.delay[currentIdx])
                        if wawDelay:
                            self.delay[currentIdx] = max(
                                wawDelay - sum(self.delay[predecessorIdx+1:currentIdx]), self.delay[currentIdx])
