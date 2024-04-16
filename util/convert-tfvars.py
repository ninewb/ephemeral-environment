import os
import json
import hcl2
import argparse
import logging

parser = argparse.ArgumentParser(description='Validate JSON contents')
parser.add_argument('-l', '--loglevel', help='Verbosity. Defaults to INFO.',
       choices=['DEBUG', 'INFO', 'WARN', 'ERROR', 'CRITICAL'], default='INFO')
parser.add_argument('-i', '--inputfile',
       help='The tfvars file to be converted.', required=True)
parser.add_argument('-p', '--outpath',
       help='The path to save the output file.', required=True)

# Initialize the argument parser
args = parser.parse_args()

# Set the logging level
logging.basicConfig(format='%(asctime)s | %(name)s | %(levelname)s :- %(message)s',
                        level=logging.getLevelName(args.loglevel))

# Set our input file to variable
inputFile = args.inputfile
outPath = args.outpath

with open(inputFile, "r") as file_in:
      data = hcl2.load(file_in)

       # modify data as needed

      with open(file=os.path.join(outPath, "terraform.tfvars.json"), mode="w") as file_out:
            file_out.write(json.dumps(data, indent=4))
