"""
@file   assembler.py
@brief  Implementation of a simple assember for a CPU that follows the PowerPC RISC architecture
@author Francis O'Hara
@date   05/06/2025

Template by Bruce A. Maxwell, 2015

implements a simple assembler for the following assembly language

- One instruction or label per line.

- Blank lines are ignored.

- Comments start with a # as the first character and all subsequent
- characters on the line are ignored.

- Spaces delimit instruction elements.

- A label ends with a colon and must be a single symbol on its own line.

- A label can be any single continuous sequence of printable
- characters; a colon or space terminates the symbol.

- All immediate and address values are given in decimal.

- Address values must be positive

- Negative immediate values must have a preceeding '-' with no space
- between it and the number.


Language definition:

LOAD D A   - load from address A to destination D
LOADA D A  - load using the address register from address A + RE to destination D
STORE S A  - store value in S to address A
STOREA S A - store using the address register the value in S to address A + RE
BRA L      - branch to label A
BRAZ L     - branch to label A if the CR zero flag is set
BRAN L     - branch to label L if the CR negative flag is set
BRAO L     - branch to label L if the CR overflow flag is set
BRAC L     - branch to label L if the CR carry flag is set
CALL L     - call the routine at label L
RETURN     - return from a routine
HALT       - execute the halt/exit instruction
PUSH S     - push source value S to the stack
POP D      - pop form the stack and put in destination D
OPORT S    - output to the global port from source S
IPORT D    - input from the global port to destination D
ADD A B C  - execute C <= A + B
SUB A B C  - execute C <= A - B
AND A B C  - execute C <= A and B  bitwise
OR  A B C  - execute C <= A or B   bitwise
XOR A B C  - execute C <= A xor B  bitwise
SHIFTL A C - execute C <= A shift left by 1
SHIFTR A C - execute C <= A shift right by 1
ROTL A C   - execute C <= A rotate left by 1
ROTR A C   - execute C <= A rotate right by 1
MOVE A C   - execute C <= A where A is a source register
MOVEI V C  - execute C <= value V


2-pass assembler
pass 1: read through the instructions and put numbers on each instruction location
        calculate the label values

pass 2: read through the instructions and build the machine instructions
"""

import sys


def dec2comp8(d, linenum):
    """converts d to an 8-bit 2-s complement binary value"""
    try:
        if d > 0:
            l = d.bit_length()
            v = "00000000"
            v = v[0:8 - l] + format(d, 'b')
        elif d < 0:
            dt = 128 + d
            l = dt.bit_length()
            v = "10000000"
            v = v[0:8 - l] + format(dt, 'b')[:]
        else:
            v = "00000000"
    except:
        print('Invalid decimal number on line %d' % linenum)
        exit()

    return v


def dec2bin8(d, linenum):
    """converts d to an 8-bit unsigned binary value"""
    if d > 0:
        l = d.bit_length()
        v = "00000000"
        v = v[0:8 - l] + format(d, 'b')
    elif d == 0:
        v = "00000000"
    else:
        print('Invalid address on line %d: value is negative' % linenum)
        exit()

    return v


def tokenize(fp):
    """ Tokenizes the input data, discarding white space and comments returns the tokens as a list of lists, one list for
        each line.
        The tokenizer also converts each character to lower case.
   """
    tokens = []

    # start of the file
    fp.seek(0)

    lines = fp.readlines()

    # strip white space and comments from each line
    for line in lines:
        line = line.strip()
        uls = ''
        for char in line:
            if char != '#':
                uls = uls + char
            else:
                break

        # skip blank lines
        if len(uls) == 0:
            continue

        # split on white space
        words = uls.split()

        newwords = []
        for word in words:
            newwords.append(word.lower())

        tokens.append(newwords)

    return tokens


def pass1(tokens):
    """
    reads through the list of tokens extracted from the assembly code and returns a dictionary of all location
    labels with their line numbers as well as an updated list of tokens with no labels.

    Parameters
    ----------
    tokens A list of tokens extracted from the assembly code using the `tokenize()` method.

    Returns
    -------
    labels_dict A dictionary mapping all labels in the assembly instructions to their appropriate line numbers.
    updated_tokens An updated list of all tokens in the program with no labels.
    """
    labels_dict = {}
    updated_tokens = []
    line_number = 0
    instruction_symbols = ["load", "loada", "store", "storea", "bra", "braz", "bran", "brao", "brac", "call", "return",
                           "halt", "push", "pop", "oport", "iport", "add", "sub", "and", "or", "xor", "shiftl", "shiftr",
                           "rotl", "rotr", "move", "movei"
                           ]
    for token_line in tokens:
        first_token = token_line[0]
        if first_token[-1] == ":":
            first_token = first_token.strip(":")
            if first_token in labels_dict:
                raise ValueError("Assembly code contains duplicate labels!")
            labels_dict[first_token] = line_number
        if first_token in instruction_symbols:
            updated_tokens.append(token_line)
            line_number += 1
    return labels_dict, updated_tokens


def pass2(token_lines, labels):
    """
    Generates and returns a list of machine instructions translated from the tokens of the assembly code.

    @param token_lines A list of tokens tokenized from the machine code.
    @param labels A dictionary that maps each label to the corresponding line number in the assembly code.
    @return machine_codes a list of strings which are the machine instructions assembled from the assembly code.
    """
    machine_codes = []

    # register mapping tables
    table_b = {
        "ra": "000",
        "rb": "001",
        "rc": "010",
        "rd": "011",
        "re": "100",
        "sp": "101"
    }

    table_c = {
        "ra": "000",
        "rb": "001",
        "rc": "010",
        "rd": "011",
        "re": "100",
        "sp": "101",
        "pc": "110",
        "cr": "111"
    }

    table_d = {
        "ra": "000",
        "rb": "001",
        "rc": "010",
        "rd": "011",
        "re": "100",
        "sp": "101",
        "pc": "110",
        "ir": "111"
    }

    table_e = {
        "ra": "000",
        "rb": "001",
        "rc": "010",
        "rd": "011",
        "re": "100",
        "sp": "101",
        "zeros": "110",
        "ones": "111"
    }

    line_number = 0
    for tokens in token_lines:
        machine_code = ""

        if tokens[0] == "load":
            machine_code = "00000" + table_b[tokens[1]] + dec2bin8(int(tokens[2]), line_number)
        elif tokens[0] == "loada":
            machine_code = "00001" + table_b[tokens[1]] + dec2bin8(int(tokens[2]), line_number)
        elif tokens[0] == "store":
            machine_code = "00010" + table_b[tokens[1]] + dec2bin8(int(tokens[2]), line_number)
        elif tokens[0] == "storea":
            machine_code = "00011" + table_b[tokens[1]] + dec2bin8(int(tokens[2]), line_number)
        elif tokens[0] == "bra":
            machine_code = "00100000" + dec2bin8(labels[tokens[1]], line_number)
        elif tokens[0] == "braz":
            machine_code = "00110000" + dec2bin8(labels[tokens[1]], line_number)
        elif tokens[0] == "bran":
            machine_code = "00110010" + dec2bin8(labels[tokens[1]], line_number)
        elif tokens[0] == "brao":
            machine_code = "00110001" + dec2bin8(labels[tokens[1]], line_number)
        elif tokens[0] == "brac":
            machine_code = "00110011" + dec2bin8(labels[tokens[1]], line_number)
        elif tokens[0] == "call":
            machine_code = "00110100" + dec2bin8(labels[tokens[1]], line_number)
        elif tokens[0] == "return":
            machine_code = "0011100000000000"
        elif tokens[0] == "halt":
            machine_code = "0011110000000000"
        elif tokens[0] == "push":
            machine_code = "0100" + table_c[tokens[1]] + "000000000"
        elif tokens[0] == "pop":
            machine_code = "0101" + table_c[tokens[1]] + "000000000"
        elif tokens[0] == "oport":
            machine_code = "0110" + table_d[tokens[1]] + "000000000"
        elif tokens[0] == "iport":
            machine_code = "0111" + table_b[tokens[1]] + "000000000"
        elif tokens[0] == "add":
            machine_code = "1000" + table_e[tokens[1]] + table_e[tokens[2]] + "000" + table_b[tokens[3]]
        elif tokens[0] == "sub":
            machine_code = "1001" + table_e[tokens[1]] + table_e[tokens[2]] + "000" + table_b[tokens[3]]
        elif tokens[0] == "and":
            machine_code = "1010" + table_e[tokens[1]] + table_e[tokens[2]] + "000" + table_b[tokens[3]]
        elif tokens[0] == "or":
            machine_code = "1011" + table_e[tokens[1]] + table_e[tokens[2]] + "000" + table_b[tokens[3]]
        elif tokens[0] == "xor":
            machine_code = "1100" + table_e[tokens[1]] + table_e[tokens[2]] + "000" + table_b[tokens[3]]
        elif tokens[0] == "shiftl":
            machine_code = "11010" + table_e[tokens[1]] + "00000" + table_b[tokens[2]]
        elif tokens[0] == "shiftl":
            machine_code = "11010" + table_e[tokens[1]] + "00000" + table_b[tokens[2]]
        elif tokens[0] == "shiftr":
            machine_code = "11011" + table_e[tokens[1]] + "00000" + table_b[tokens[2]]
        elif tokens[0] == "rotl":
            machine_code = "11100" + table_e[tokens[1]] + "00000" + table_b[tokens[2]]
        elif tokens[0] == "rotl":
            machine_code = "11101" + table_e[tokens[1]] + "00000" + table_b[tokens[2]]
        elif tokens[0] == "move":
            machine_code = "11110" + table_d[tokens[1]] + "00000" + table_b[tokens[2]]
        elif tokens[0] == "movei":
            machine_code = "11111" + dec2comp8(int(tokens[1]), line_number) + table_b[tokens[2]]

        machine_codes.append(machine_code)
        line_number += 1

    return machine_codes


def main(argv):
    if len(argv) < 2:
        print('Usage: python3 %s <filename>' % argv[0])
        exit()

    fp = open(argv[1], 'r')

    tokens = tokenize(fp)

    fp.close()

    # execute pass1 and pass2 then print it out as an MIF file
    labels, tokens = pass1(tokens)
    machine_codes = pass2(tokens, labels)

    mif_output = f"""-- program memory file for {argv[1]}
DEPTH = 256;
WIDTH = 16;
ADDRESS_RADIX = HEX;
DATA_RADIX = BIN;
CONTENT
BEGIN
"""
    line_number = 0
    for machine_code in machine_codes:
        mif_output += f"{line_number:02X} : {machine_code};\n"
        line_number += 1

    if line_number < 256:
        mif_output += f"[{line_number:02X}..FF] : 1111111111111111;\n"
    mif_output += "END"

    print(mif_output)

    return


if __name__ == "__main__":
    main(sys.argv)
