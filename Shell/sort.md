Usage: sort [-bcCdfigMmnrsuz] [-kPOS1[,POS2] ... ] [+POS1 [-POS2]] [-S memsize] [-T tmpdir] [-t separator] [-o outfile] [--batch-size size] [--files0-from file] [--heapsort] [--mergesort] [--radixsort] [--qsort] [--mmap] [--parallel thread_no] [--human-numeric-sort] [--version-sort] [--random-sort [--random-source file]] [--compress-program program] [file ...]

order the lines in reverse lexicographical order (i.e. Z-A instead of A-Z).
sort -r

By passing sort the -n option the file is ordered numerically.
sort -n

Sort the lines in descending order - - such that the first line holds the (numerically) largest number and the last line holds the (numerically) smallest number.
sort -nr

ignore case
sort -f names.txt

sort tab-delimited file
https://stackoverflow.com/questions/1037365/sorting-a-tab-delimited-file

sort tab-delimited file using second column number descending
sort -t $'\t' -k2 -rn

sort this file in ascending order of the second column number
sort -t $'\t' -k 2 -n

sort pipe-delimited second column number descending
sort -t $'|' -k2 -nr
