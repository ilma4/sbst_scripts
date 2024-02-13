#!/bin/bash

# Check if argument was provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <directory_path>"
    exit 1
fi

# Get the provided directory path and the substring
directory_path=$1
substring_to_search='Mockito.mock'

# Use find to search for files and grep to search for the substring within those files
find "$directory_path" -type f -exec grep -l -- "$substring_to_search" {} +

