def getOPCode():
    with open('instructions.txt', "r") as op:
        data = op.readlines()
    opCodes = {}
    for s in data:
        t = s.split()
        opCodes[t[1]] = t[0]
    return opCodes


class Parser:
    def __init__(self, filePath):
        self.filePath = filePath
        self.data = []
        self.parse()

    def parse(self):
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
