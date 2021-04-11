def getOPCode():
    """
    Get opcodes for each instructions as mentioned in instructions.txt file

    Output: 
    - A dictionary with the keys as instruction names and values as the opcodes 
    """
    with open('instructions.txt', "r") as op:
        data = op.readlines()
    opCodes = {}
    for s in data:
        if s is None:
            continue
        t = s.split()
        if t[0] == "//":
            continue
        opCodes[t[1]] = t[0]
    return opCodes


def packetDict():
    """
    Creates the structure for an instruction packet

    Output: 
    - A dictionary with keys as the module instances 
    """
    return {
        "add0": [],
        "add1": [],
        "mul": [],
        "fadd0": [],
        "fadd1": [],
        "fmul": [],
        "logic": []
    }


def getPacketKey(opCode):
    """
    Gets the packet key for a given instruction

    Input:
    - opCode: The opcode of instruction for which the packet key has to be generated

    Output: 
    - The packet keys initialized in packetDict function for the given opcode
    """
    if opCode in ["00000", "00001", "00010", "00011"]:
        return "add0", "add1"
    elif opCode == "00100":
        return "mul", None
    elif opCode in ["00101", "00110", "00111", "01000"]:
        return "fadd0", "fadd1"
    elif opCode == "01001":
        return "fmul", None
    elif opCode in ["01010", "01011", "01100", "01101", "01110", "01111", "10000", "10001"]:
        return "logic", None


def checkRAW(packet, inst):
    """
    Checks the RAW data dependencies in the given packet of instructions

    Input: 
    - packet: Instruction packet for dependency check 
    - inst: Next upcoming instruction

    Output:
    - True if there is a RAW data dependency 
    - False if there is no RAW data dependency

    """
    if inst[0] == "00100":

        op_1 = inst[3]
        op_2 = inst[4]
    else:
        op_1 = inst[2]
        op_2 = inst[3]

    for y in packet.values():
        if not y:
            continue
        if y[0] == "00100":
            if y[1] in [op_1, op_2] or y[2] in [op_1, op_2]:
                return True
        else:
            if y[1] in [op_1, op_2]:
                return True
    return False


def checkWAW(packet, inst):
    """
    Checks the WAW data dependencies in the given packet of instructions

    Input: 
    - packet: Instruction packet for dependency check 
    - inst: Next upcoming instruction

    Output:
    - True if there is a WAW data dependency 
    - False if there is no WAW data dependency

    """
    out_1 = inst[1]
    out_2 = inst[2]

    for y in packet.values():
        if not y:
            continue
        if y[0] == "00100":
            if inst[0] == '00100':
                if y[1] in [out_1, out_2] or y[2] in [out_1, out_2]:
                    return True
            else:
                if y[1] == out_1 or y[2] == out_1:
                    return True
        else:
            if inst[0] == '00100':
                if y[1] in [out_1, out_2]:
                    return True
            else:
                if y[1] == out_1:
                    return True
    return False


class Parser:
    def __init__(self, filePath):
        self.filePath = filePath
        self.data = []
        self.packets = [dict(packetDict())]
        self.parse()

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
        for data in self.data:
            packetKey, optionalKey = getPacketKey(data[0])
            for packet in self.packets:
                if not packet[packetKey]:
                    if not checkRAW(packet, data) and not checkWAW(packet, data):
                        packet[packetKey] = data
                        flag = True
                        break
                    else:
                        flag = False
                elif optionalKey:
                    if not packet[optionalKey]:
                        if not checkRAW(packet, data) and not checkWAW(packet, data):
                            packet[optionalKey] = data
                            flag = True
                            break
                        else:
                            flag = False
            if not flag:
                self.packets.append(dict(packetDict()))
                self.packets[-1][packetKey] = data
            flag = False
