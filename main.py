from Compiler import Compiler

if __name__ == '__main__':
    filePath = input("Enter the file path: ")
    compiler = Compiler(filePath)
    print(compiler.data)
    print()
    for idx in range(len(compiler.packets)):
        print(f"Instruction {idx}, Delay {compiler.delay[idx]}")
        if type(compiler.packets[idx]) == dict:
            for mod, inst in compiler.packets[idx].items():
                print('\x1b[6;31;49m'+mod+':\t' +
                      '\x1b[6;33;49m'+str(inst)+'\x1b[0m')
        else:
            print(compiler.packets[idx])
        print()

    print("Generating a testbench...\n")
    compiler.generateTestBench()
    print("Executing a testbench...\n")
    compiler.executeTestBench()

    for out in compiler.outputData:
        print(f"$time: {out['time']}\t PC: {out['31']}")
        for key, value in out.items():
            if key in ["time", "31"]:
                continue
            print('\x1b[6;32;49m'+"R"+key+':\t' +
                  '\x1b[6;34;49m'+str(value)+'\x1b[0m')
        print()
