``awk '{print}' marks.txt``

``awk 'BEGIN{printf "Sr No\tName\tSub\tMarks\n"} {print}' marks.txt``

Printing Column or Field
```awk '{print $3 "\t" $4}' marks.txt```

print the 3rd character from each line as a new line of output.
``awk '{print substr($0,3,1)}'``
the syntax for substr() is
``substr(string,start index,length)``

first two columns separated by space
``awk '{ print $1,$2 }' marks.txt``
it is the same as
``awk '{ print $1, $2 }' marks.txt``

first two columns no separator
``awk '{ print $1.$2 }' marks.txt``

it is the same as
``awk '{ print $1. $2 }' marks.txt``

Every line that contains lowercase letter
``awk '/[a-z]/ {print}' marks.txt``

numbers
``awk '/[0-9]/ {print}' marks.txt``

line starts with a number
``awk '/^[0-9]/ {print}' marks.txt``

ends with a number
``awk '/[0-9]$/ {print}' marks.txt``

conditionals
``awk '{ if($4 ~ 90) print }' marks.txt``
``awk '{ if($4 ~ /90/) print }' marks.txt``
``awk '{ if($2 ~ /[a-z]/) print }' marks.txt``

Case-insensitive grep, then everything that contains h
``grep -i substr awk.md | awk '/[h]/ { print }'``
the syntax for substr() is
``substr(string,start index,length)``

":"-delimited
``awk -F: '{ print $2 }' test.txt``

identify those lines for which number of fields is not 4
``awk 'NF != 4 { print "Number of fields less than 4: ", $1}'``

if the fields 2-4 >= 50,
``awk '{ print $1, ":", ($2 >= 50 && $3 >= 50 && $4 >= 50) ? "Pass" : "Fail"}'``
Sample input: A 25 27 50
Sample output: A : Fail

If the average of the three scores is 80 or more, the grade is 'A'. If the average is 60 or above, but less than 80, the grade is 'B'. If the average is 50 or above, but less than 60, the grade is 'C'. Otherwise the grade is 'FAIL'.
``awk '{ average = ($2 + $3 + $4) / 3; print $0, ":", average < 50 ? "FAIL" : (average < 80 ? "B" : "A") }'``

Same as above ([from the comments](https://www.hackerrank.com/challenges/awk-3/forum/comments/125380))
```
awk '{
total = ($2 + $3 + $4)/3
if (total >= 50 && total< 60)
    print $1,$2,$3,$4, ": C"
else if (total >= 60 && total < 80)
    print $1,$2,$3,$4, ": B"
else if (total >= 80)
    print $1,$2,$3,$4, ": A"
else
    print $1,$2,$3,$4, ": FAIL" }'
```

Concatenate every 2 lines of input with a semi-colon.
``awk 'ORS = NR % 2 ? ";" : "\n"'``
[More about awk variables](https://www.thegeekstuff.com/2010/01/8-powerful-awk-built-in-variables-fs-ofs-rs-ors-nr-nf-filename-fnr/)
