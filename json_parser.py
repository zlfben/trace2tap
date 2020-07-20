import sys
import json
import getopt

def main(argv):
    filename = ''
    try:
        opts, args = getopt.getopt(argv, "f:h")
    except getopt.error:
        print("Usage: json_parser.py -f [filename] <field>")
    
    for opt, value in opts:
        if opt == "-h":
            print("Usage: json_parser.py -f [filename] <field>")
            sys.exit()
        elif opt == '-f':
            filename = value
    
    field_list = args
    if not field_list:
        print("Usage: json_parser.py -f [filename] <field>")
        sys.exit()

    with open(filename, "r") as fp:
        data = json.load(fp)
    
    print(data[field_list[0]], end="")
    for field in field_list[1:]:
        print(" " + data[field], end="")


if __name__ == "__main__":
    main(sys.argv[1:])
