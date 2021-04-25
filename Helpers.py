from Constants import moduleDelay


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
        "logic": [],
        "ldr": [],
        "str": [],
        "mov": []
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
    elif opCode == "10010":
        return "ldr", None
    elif opCode == "10011":
        return "str", None
    elif opCode == "10100":
        return "mov", None


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
    op_1, op_2 = getOperands(inst)
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


def checkWAR(packet, inst):
    """
    Checks the WAR data dependencies in the given packet of instructions

    Input: 
    - packet: Instruction packet for dependency check 
    - inst: Next upcoming instruction

    Output:
    - True if there is a WAR data dependency 
    - False if there is no WAR data dependency
    """
    out_1, out_2 = getOutput(inst)
    for y in packet.values():
        if not y:
            continue
        if y[0] == "00100":
            if inst[0] == "00100":
                if y[3] in [out_1, out_2] or y[4] in [out_1, out_2]:
                    return True
            else:
                if y[3] == out_1 or y[4] == out_1:
                    return True
        else:
            if inst[0] == "00100":
                if y[2] in [out_1, out_2] or y[3] in [out_1, out_2]:
                    return True
            else:
                if y[2] == out_1 or y[3] == out_1:
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
    out_1, out_2 = getOutput(inst)
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


def getOperands(inst):
    """
    Get the inputs of the instruction

    Input:
    - inst: The instruction list

    Output:
    - Returns the inputs of the instruction
    """
    if inst[0] == "00100":
        return inst[3], inst[4]
    else:
        return inst[2], inst[3]


def getOutput(inst):
    """
    Get the outputs of the instruction

    Input:
    - inst: The instruction list

    Output:
    - Returns the outputs of the instruction
    """
    return inst[1], inst[2]


def checkRAW2(packet1, packet2):
    """
    Checks the RAW data dependencies in the given pair of packets of instructions

    Input: 
    - packet1: Instruction packet 1 for dependency check 
    - packet2: Instruction packet 2 for dependency check

    Output:
    - List of modules that have the dependencies
    """
    dependencies = []
    for module1, inst1 in packet1.items():
        if inst1:
            for inst2 in packet2.values():
                if inst2:
                    out_1, out_2 = getOutput(inst1)
                    op_1, op_2 = getOperands(inst2)
                    if inst1[0] == "00100":
                        if out_1 in [op_1, op_2] or out_2 in [op_1, op_2]:
                            dependencies.append(moduleDelay[module1])
                    else:
                        if out_1 in [op_1, op_2]:
                            dependencies.append(moduleDelay[module1])
    if not dependencies:
        return None
    else:
        return max(dependencies)


def checkWAW2(packet1, packet2):
    """
    Checks the WAW data dependencies in the given pair of packets of instructions

    Input: 
    - packet1: Instruction packet 1 for dependency check 
    - packet2: Instruction packet 2 for dependency check

    Output:
    - List of modules that have the dependencies
    """
    dependencies = []
    for module1, inst1 in packet1.items():
        if inst1:
            for inst2 in packet2.values():
                if inst2:
                    out_1, out_2 = getOutput(inst1)
                    out_3, out_4 = getOutput(inst2)
                    if inst1[0] == "00100":
                        if inst2[0] == "00100":
                            if out_1 in [out_3, out_4] or out_2 in [out_3, out_4]:
                                dependencies.append(moduleDelay[module1])
                        else:
                            if out_1 == out_3 or out_2 == out_3:
                                dependencies.append(moduleDelay[module1])
                    else:
                        if inst2[0] == "00100":
                            if out_1 in [out_3, out_4]:
                                dependencies.append(moduleDelay[module1])
                        else:
                            if out_1 == out_3:
                                dependencies.append(moduleDelay[module1])
    if not dependencies:
        return None
    else:
        return max(dependencies)


def addInst(packet, packetKey, optionalKey, data):
    """
    Adds the given instruction at the given key of a packet

    Input:
    - packet: The packet dictionary
    - packetKey: The key/module name where the instructions is to be added
    - optionalKey: The optional key/module name for duplicate hardware

    Output:
    - Returns if the data is inserted in the packet
    """
    if not packet[packetKey]:
        if not checkRAW(packet, data) and not checkWAW(packet, data):
            packet[packetKey] = data
            return True
    elif optionalKey:
        if not packet[optionalKey]:
            if not checkRAW(packet, data) and not checkWAW(packet, data):
                packet[optionalKey] = data
                return True
    return False


def check(pack, inst):
    """
    A function to check if an instruction is present in the packet
    
    Input:
    - pack: The packet to be checked
    - inst: The instruction

    Output:
    Returns True if the instruction is present in the packet else Fase
    """
    inst_key = getPacketKey(inst[0])
    for key in inst_key:
        if key:
            if pack[key] == inst:
                return True
    return False


def packetBinary(packet):
    """
    A function that converts from dictionary of instruction to binary form
    
    Input:
    - packet: The packet of instructions

    Output:
    - Returns a binary packet of instructions 
    """
    binPacket = ""
    for inst in list(packet.values()):
        if inst:
            temp = "32'b" + inst[0] + "_"
            for it in range(1, len(inst)):
                if inst[it][0] == "#":
                    temp += str(bin(int(inst[it][1:]))[2:].zfill(22)) + "_"
                elif inst[it][0] == "R" and inst[it] != "R0":
                    temp += str(bin(int(inst[it][1:]))[2:].zfill(5)) + "_"
            count10 = temp.count("1") + temp.count("0")
            if count10 != 32:
                temp += str(bin(0)[2:].zfill(32-count10))
            else:
                temp = temp[:len(temp)-1]
            binPacket += temp + ", "
        else:
            binPacket += "32'b0, "
    binPacket = "{" + binPacket[:len(binPacket)-2] + "}"
    return binPacket
