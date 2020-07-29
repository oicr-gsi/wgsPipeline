import WDL
import argparse

parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument("-i", "--input-wdl-path", required = True, help = "source wdl path")
args = parser.parse_args()
doc = WDL.load(args.input_wdl_path)     # loads the file as a WDL.Tree.Document object

print("required inputs:")
for item in doc.workflow.required_inputs:
    input = item.value
    print(str(input.type), str(input.name))