##!/bin/bash

## Checks if a valid url is provided  ##
if [ -z "$1" ]; then
  echo "Please provide an url as argument."
  exit 1
fi

## Downloads the file ##
wget "$1" -O "downloaded_file"

## Checks if the download was successful ##
if [ "$?" -ne 0 ]; then
  echo "Download failed."
  exit 1
fi

## Determines the type of the file ##
file_type=$(file "downloaded_file" | cut -d ":" -f 2 | sed 's/^ //')

## Analyzes the file based on its type ##
if [[ "$file_type" == *"text"* ]]; then
  ## Get the number of lines, words, and spaces in the file ##
  lines=$(wc -l "downloaded_file" | awk '{print $1}')
  words=$(wc -w "downloaded_file" | awk '{print $1}')
  spaces=$(grep -o " " "downloaded_file" | wc -l)

  ## Output of the results ##
  echo "Lines: $lines"
  echo "Words: $words"
  echo "Spaces: $spaces"

  ## Print the first and last lines of the file ##
  echo "First line: $(head -n 1 "downloaded_file")"
  echo "Last line: $(tail -n 1 "downloaded_file")"

elif [[ "$file_type" == *"binary"* ]]; then
  ## This gets the size of the file in bytes ##
  size=$(wc -c "downloaded_file" | awk '{print $1}')

  ## Outputs the size of the file ##
  echo "File size: $size bytes"

  ## Shows around 10 first and 10 last bytes of the file in printable representation ##
  echo "First 10 bytes: $(xxd -p -l 10 "downloaded_file")"
  echo "Last 10 bytes: $(xxd -p -s $(($size-10)) -l 10 "downloaded_file")"

else
  echo "Unknown file type: $file_type"
fi