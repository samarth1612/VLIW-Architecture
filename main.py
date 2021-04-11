from Parser import Parser

if __name__ == '__main__':
    filePath = input("Enter the file path: ")
    parser = Parser(filePath)
    print(parser.data)
