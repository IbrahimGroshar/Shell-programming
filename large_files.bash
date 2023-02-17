##!/bin/bash

## Checks that a directory was provided as an argument ##
if [ $# -ne 1 ]; then
  echo "Usage: $0 <path>"
  exit 1
fi

## Checks if the directory exists ##
if [ ! -d "$1" ]; then
  echo "Error: $1 is not a directory"
  exit 1
fi

## Recursively finds all files in the directory and their sizes ##
filesizes=$(find "$1" -type f -printf "%s %p\n")

## Counts the number of files and the total file size ##
num_files=$(echo "$filesizes" | wc -l)
total_size=$(echo "$filesizes" | awk '{sum += $1} END {print sum}')

## Sorting the files by size, from largest to smallest and get the top 5 ##
top_files=$(echo "$filesizes" | sort -nr | head -n 5)

## Ooutput the report ##
echo "Top 5 largest files in $1:"
echo "$top_files"
echo "Total size of top 5 files: $total_size bytes"
echo "Total number of files scanned: $num_files"
echo "Total size of all files: $(du -sh $1 | cut -f1)"