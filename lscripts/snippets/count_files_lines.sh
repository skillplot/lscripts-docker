#!/bin/bash

##__author__ = 'mangalbhaskar'
###----------------------------------------------------------

## This script counts the total number of files and total line counts for each file in the directory with a specific file extension.

## Usage: ./count_files_lines.sh /path/to/directory [extension]

## Input directory
DIR=${1:-.}

## File extension (default is .csv)
EXT=${2:-csv}

## Function to count files and lines in a directory
count_files_lines() {
  local dir=$1
  local ext=$2
  local files=$(find "$dir" -maxdepth 1 -type f -name "*.$ext")
  local file_count=0
  local line_count=0

  for file in $files; do
    lines=$(wc -l < "$file")
    line_count=$((line_count + lines))
    file_count=$((file_count + 1))
  done

  echo "Directory: $dir"
  echo "Total Files: $file_count"
  echo "Total Lines: $line_count"
  echo

  total_files=$((total_files + file_count))
  total_lines=$((total_lines + line_count))
}

## Initialize total counters
total_files=0
total_lines=0

## Loop through directories and count files and lines
for subdir in "$DIR"/*/; do
  [ -d "$subdir" ] && count_files_lines "$subdir" "$EXT"
done

## Count files and lines in the base directory itself
count_files_lines "$DIR" "$EXT"

## Print overall totals
echo "Overall Total Files: $total_files"
echo "Overall Total Lines: $total_lines"
