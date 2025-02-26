#!/bin/bash

# Check if an argument (URL) was provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <url>"
    exit 1
fi

url="$1"

# Get filename from URL
filename="downloaded_file_$(date +%F_%H-%M-%S)"

# Download the file using curl
echo "Downloading file from $url..."
curl -s -o "$filename" "$url"

# Check if download was successful
if [ ! -f "$filename" ]; then
    echo "Error: Failed to download the file."
    exit 1
fi

# Determine file type
mime_type=$(file -b --mime-type "$filename")

echo "File downloaded: $filename"
echo "MIME Type: $mime_type"

# If it's a text file, analyze it as text
if [[ "$mime_type" == text/* ]]; then
    echo "Analyzing as a text file..."
    line_count=$(wc -l < "$filename")
    word_count=$(wc -w < "$filename")
    space_count=$(grep -o " " "$filename" | wc -l)
    first_line=$(head -n 1 "$filename")
    last_line=$(tail -n 1 "$filename")

    echo "Lines: $line_count"
    echo "Words: $word_count"
    echo "Spaces: $space_count"
    echo "First Line: $first_line"
    echo "Last Line: $last_line"

# If it's a binary file, analyze it differently
else
    echo "Analyzing as a binary file..."
    byte_count=$(wc -c < "$filename")
    first_10_bytes=$(head -c 10 "$filename" | xxd -p)
    last_10_bytes=$(tail -c 10 "$filename" | xxd -p)

    echo "Size: $byte_count bytes"
    echo "First 10 bytes: $first_10_bytes"
    echo "Last 10 bytes: $last_10_bytes"
fi

# Open the downloaded file in a web browser
xdg-open "$filename" &>/dev/null

echo "File analysis complete!"
