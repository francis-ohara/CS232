import sys

def generate_mif(input_filename, num_instructions, max_num_instructions, instruction_width):
    """Generates an MIF file from an input text file and returns its contents as a string.
        The generated MIF code is written to a new MIF file with the same filename as `input_filename` and a `.mif` file extension
        The input file must follow the following format:
            machine code, comment describing machine code
            e.g.,
                1111100001000000, move 8 to RA
    Args:
        input_filename (str): The name of the input text file containing the machine instructions for which an MIF file is to be generated.
        num_instructions (int): The number of machine instructions to be included in the MIF file.
                                This must match the number of non-blank lines in the input text file.
        max_num_instructions: The maximum number of instructions the memory unit can store.
        instruction_width (int): The width of the instructions in the MIF file.

    Returns:
        str: A string containing the contents written to the generated MIF file.
    """
    result = f"""DEPTH = {max_num_instructions};
WIDTH = {instruction_width};
ADDRESS_RADIX = HEX;
DATA_RADIX = BIN;
CONTENT
BEGIN\n"""
    input_file = open(input_filename, "r")

    for i, line in enumerate(input_file):
        line = line.strip()
        if len(line) != 0:
            instruction, comment = line.split(",")
            result += f"{i:02X} : {instruction}; -- {comment.strip()}\n"

    if num_instructions < max_num_instructions:
        result += f"[{num_instructions:02X}..{max_num_instructions - 1:02X}] : {'1' * instruction_width};\n"

    result += "END\n"

    output_filename = input_filename.split(".")[0] + ".mif"
    output_file = open(output_filename, "w")
    output_file.write(result)

    input_file.close()
    output_file.close()

    return result

if __name__ == "__main__":
    if len(sys.argv) != 5:
        print("Required arguments not provided!")
        print("Usage: python3 mif_generator.py <input_filename> <number_of_instructions> <max_number_of_instructions> <instruction_width>")
    else:
        result = generate_mif(sys.argv[1], int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4]))
        print(result)
