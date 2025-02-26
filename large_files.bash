#!/bin/bash

# Check if a directory argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Check if the given path exists and is a directory
if [ ! -d "$1" ]; then
    echo "Error: Directory '$1' not found."
    exit 1
fi

dir_path="$1"

# Find all files, sort by size, and store results
file_list=$(find "$dir_path" -type f -exec du -b {} + | sort -nr | head -5)

# If no files are found, exit
if [ -z "$file_list" ]; then
    echo "No files found in the given directory."
    exit 0
fi

echo "Top 5 largest files in '$dir_path':"
echo "-----------------------------------"
total_size=0

while read -r size file; do
    file_type=$(file -b --mime-type "$file")  # Get MIME type of the file
    echo "Size: $size bytes | Type: $file_type | File: $file"
    total_size=$((total_size + size))
done <<< "$file_list"

echo "-----------------------------------"
echo "Total size of top 5 largest files: $total_size bytes"

# Count total number of files and their cumulative size
total_files=$(find "$dir_path" -type f | wc -l)
total_dir_size=$(du -sb "$dir_path" | cut -f1)

echo "Total files scanned: $total_files"
echo "Total size of all files: $total_dir_size bytes"
