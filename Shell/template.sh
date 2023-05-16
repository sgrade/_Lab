#!/usr/bin/env bash

# All files (not directories) in a directory
files=$(find . -maxdepth 1 -type f)
# echo $files

# file names
for f in $files; do
	echo $f | cut -c3-
done

# grep "source" in files
for f in $files; do
  grep source $f
done

# multiline comment below
<<comment
if [ -e "$FILE" ]; then
	if [ -f "$FILE" ]; then
		echo "$FILE is a regular file."
	fi
	if [ -d "$FILE" ]; then
		echo "$FILE is a directory."
	fi
	if [ -r "$FILE" ]; then
		echo "$FILE is readable."
	fi
	if [ -w "$FILE" ]; then
		echo "$FILE is writable."
	fi
	if [ -x "$FILE" ]; then
		echo "$FILE is executable/searchable."
	fi
else
	echo "$FILE does not exist"
	exit 1
fi
comment

while read -r line; do echo "$line"; done < words.txt

# OR

input="words.txt"
while read -r line
do 
	echo "$line"
done < "$input"

varname="varvalue"
# Curly braces show where the variable name starts/stops
echo "${varname}s"
