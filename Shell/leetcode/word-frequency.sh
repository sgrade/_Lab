#!/usr/bin/env bash

# 192. Word Frequency
# https://leetcode.com/problems/word-frequency/

declare -A counter

while read -r -a line; do
    for ch in ${line[@]}; do (( counter[$ch]++ )); done
done < words.txt

printf "%s\n" "${counter[@]}" | sort -r

output=""
for key in "${!counter[@]}"; do
    output+="$key ${counter[$key]}\n"
done



echo $output
