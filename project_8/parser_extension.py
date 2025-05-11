"""
@file   parser_extension  
@brief  A simple parser program for detecting syntax errors in assembly code for `assembler.py`
@author Francis O'Hara
@date   5/10/25
"""
from assembler import tokenize, pass1
import sys

def main(argv):
    if len(argv) < 2:
        print('Usage: python3 %s <filename>' % argv[0])
        exit()

    token_lines = tokenize(open(argv[1], "r"))

    line_number = 0

    valid_instruction_symbols = ["load", "loada", "store", "storea", "bra", "braz", "bran", "brao", "brac", "call", "return",
                           "halt", "push", "pop", "oport", "iport", "add", "sub", "and", "or", "xor", "shiftl", "shiftr",
                           "rotl", "rotr", "move", "movei"
                           ]
    valid_registers = ["ra", "rb", "rc", "rd", "re", "sp", "pc", "zeros", "ones", "ir", "cr"]
    valid_labels = pass1(token_lines)[0]

    for tokens in token_lines:
        # catch invalid characters in label
        first_token = tokens[0]
        if first_token[-1] == ":":
            if not first_token[:-1].isalnum():
                raise SyntaxError(f"Syntax Error near Line {line_number}: Program contains label with character that is not alphanumeric")
            if len(tokens) > 1:
                raise SyntaxError(f"Syntax Error near line {line_number}: Invalid characters after label on the same line.")

        # catch invalid instruction symbols
        elif first_token not in valid_instruction_symbols:
            raise SyntaxError(f"Syntax Error near line {line_number}: `{first_token}` is neither a label nor a valid instruction")

        # catch invalid operands for valid instructions
        elif first_token in ["load", "loada", "store", "storea"]:
            if len(tokens) != 3:
                raise SyntaxError(f"Syntax Error near line {line_number}: `{first_token}` instruction expected 2 arguments but got {len(tokens) - 1}")
            elif tokens[1] not in valid_registers:
                raise SyntaxError(f"Syntax Error near line {line_number}: invalid register `{tokens[1]}`")
            elif int(tokens[2]) > 255 or int(tokens[2]) < 0:
                raise SyntaxError(f"Syntax Error near line {line_number}: invalid address `{tokens[1]}` for `{tokens[0]}` instruction")
        elif first_token in ["bra", "braz", "bran", "brao", "brac", "call"]:
            if len(tokens) != 2:
                raise SyntaxError(f"Syntax Error near line {line_number}: `{first_token}` instruction expected 1 argument but got {len(tokens) - 1}")
            elif tokens[1] not in valid_labels:
                raise SyntaxError(f"Syntax Error near line {line_number}: unrecognized label `{tokens[1]}`for instruction `{tokens[0]}`")
        elif first_token in ["return", "halt"]:
            if len(tokens) != 1:
                raise SyntaxError(f"Syntax Error near line {line_number}: `{first_token}` instruction expected 0 arguments but got {len(tokens) - 1}")
        elif first_token in ["push", "pop", "oport", "iport"]:
            if len(tokens) != 2:
                raise SyntaxError(f"Syntax Error near line {line_number}: `{first_token}` instruction expected 1 argument but got {len(tokens) - 1}")
            elif tokens[1] not in valid_registers:
                raise SyntaxError(f"Syntax Error near line {line_number}: invalid register `{tokens[1]}`")
        elif first_token in ["add", "sub", "and", "or", "xor"]:
            if len(tokens) != 4:
                raise SyntaxError(f"Syntax Error near line {line_number}: `{first_token}` instruction expected 3 arguments but got {len(tokens) - 1}")
            elif tokens[1] not in valid_registers:
                raise SyntaxError(f"Syntax Error near line {line_number}: invalid register `{tokens[1]}`")
            elif tokens[2] not in valid_registers:
                raise SyntaxError(f"Syntax Error near line {line_number}: invalid register `{tokens[1]}`")
            elif tokens[3] not in valid_registers:
                raise SyntaxError(f"Syntax Error near line {line_number}: invalid register `{tokens[1]}`")
        elif first_token in ["shiftl", "shiftr", "rotl", "rotr", "move"]:
            if len(tokens) != 3:
                raise SyntaxError(f"Syntax Error near line {line_number}: `{first_token}` instruction expected 2 arguments but got {len(tokens) - 1}")
            elif tokens[1] not in valid_registers:
                raise SyntaxError(f"Syntax Error near line {line_number}: invalid register `{tokens[1]}`")
            elif tokens[2] not in valid_registers:
                raise SyntaxError(f"Syntax Error near line {line_number}: invalid register `{tokens[1]}`")
        elif first_token == "movei":
            if len(tokens) != 3:
                raise SyntaxError(f"Syntax Error near line {line_number}: `{first_token}` instruction expected 2 arguments but got {len(tokens) - 1}")
            elif tokens[2] not in valid_registers:
                raise SyntaxError(f"Syntax Error near line {line_number}: invalid register `{tokens[1]}`")
            elif not tokens[1].isdecimal():
                raise SyntaxError(f"Syntax Error near line {line_number}: `{tokens[1]}` is not a valid 8-bit two's complement number.")
            elif int(tokens[1]) < -128 or int(tokens[1]) > 127:
                raise SyntaxError(f"Syntax Error near line {line_number}: `{tokens[1]}` is not a valid 8-bit two's complement number. `{tokens[0]}` instruction expects a decimal number between -128 and 127.")
        line_number += 1

if __name__ == "__main__":
    main(sys.argv)