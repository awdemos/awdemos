# the python dockerfile generator nobody asked for :-)

import re
import subprocess
import sys
import logging

logging.basicConfig(level=logging.INFO)

def execute_python_block(python_code):
    """Execute Python code and return its output."""
    try:
        output = subprocess.check_output(["python3", "-c", python_code], universal_newlines=True)
        return output
    except subprocess.CalledProcessError as e:
        logging.error(f"Error executing Python code block: {e}")
        return ""

def compile_dockerfile(input_filename, output_filename):
    """Compile an extended Dockerfile with Python blocks into a standard Dockerfile."""
    with open(input_filename, "r") as infile, open(output_filename, "w") as outfile:
        python_block = False
        python_code = ""
        
        for line in infile:
            if line.startswith("#PY"):
                python_block = True
                python_code = ""
            elif line.startswith("#END") and python_block:
                python_block = False
                python_output = execute_python_block(python_code)
                outfile.write(python_output)
            elif python_block:
                python_code += line
            else:
                outfile.write(line)

# Example usage
if len(sys.argv) != 3:
    logging.error("Usage: python3 py-docker.py <input_filename> <output_filename>")
else:
    input_filename = sys.argv[1]
    output_filename = sys.argv[2]
    compile_dockerfile(input_filename, output_filename)