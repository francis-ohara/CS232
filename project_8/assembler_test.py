"""
@file   assembler_test  
@brief  Test program for assembler.py
@author Francis O'Hara
@date   5/6/25
"""
import assembler

# test tokenize()
file = open("test.a", "r")
tokens = assembler.tokenize(file)
print("Tokens:\n", tokens)

# test pass1()
labels_dict, updated_tokens = assembler.pass1(tokens)

print("\nLabels:\n", labels_dict)
print("Updated Token Lines:\n", updated_tokens)

# test pass2()
machine_codes = assembler.pass2(updated_tokens, labels_dict)
print("\nResulting Machine Code:")
for machine_code in machine_codes:
    print(machine_code)

expected = """-- program memory file for sumten.a
DEPTH = 256;
WIDTH = 16;
ADDRESS_RADIX = HEX;
DATA_RADIX = BIN;
CONTENT
BEGIN
00 : 1111100000001000;
01 : 1111100000000001;
02 : 1111100000010010;
03 : 1111100001010011;
04 : 1000000001000001;
05 : 1000000010000000;
06 : 1000111011000011;
07 : 0011000000001001;
08 : 0010000000000100;
09 : 0110001000000000;
[0A..FF] : 1111111111111111;
END"""
got = """-- program memory file for sumten.a
DEPTH = 256;
WIDTH = 16;
ADDRESS_RADIX = HEX;
DATA_RADIX = BIN;
CONTENT
BEGIN
00 : 1111100000001000;
01 : 1111100000000001;
02 : 1111100000010010;
03 : 1111100001010011;
04 : 1000000001000001;
05 : 1000000010000000;
06 : 1000111011000011;
07 : 0011000000001001;
08 : 0010000000000100;
09 : 0110001000000000;
[0A..FF] : 1111111111111111;
END"""
line_number = 0
for i in range(len(expected)):
    if expected[i] != got[i]:
        print(f"line: {line_number}, char: {i}")
        print(f"Expected: {expected[i]}")
        print(f"Got: {got[i]}")
        break
    if expected[i] == "\n":
        line_number += 1
