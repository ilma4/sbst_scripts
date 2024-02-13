#!/usr/bin/env python3
import re
from sys import argv

# Assuming the structured file is 'data.txt' and the key file is 'keys.txt'
data_file = argv[1]
keys_file = argv[2]


# Load keys to preserve from the keys file
with open(keys_file, 'r') as f:
    keys_to_preserve = set(f.read().splitlines())

# Read the structured data from the data file
with open(data_file, 'r') as f:
    data_contents = f.read()

# Regex pattern to match blocks in the structured data file
pattern = re.compile(r'([\w\d-]+)=\{(.*?)\}', re.DOTALL)

# Extract all key-value pairs
key_value_pairs = pattern.findall(data_contents)

# Filter key-value pairs based on the keys to preserve
filtered_pairs = [f"{key}={{{value}\n}}" for key, value in key_value_pairs if key in keys_to_preserve]

# Join filtered key-value pairs into the final string
filtered_data = '{\n' + '\n'.join(filtered_pairs) + '\n}'

# Optional: Write the filtered data to a new file if you don't want to overwrite the original one
output_file = 'filtered_data.txt'
with open(output_file, 'w') as f:
    f.write(filtered_data)

print(f"Filtered data has been saved to {output_file}")
