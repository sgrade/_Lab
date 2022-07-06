# grep

Case-insensitive
```
grep -i test test.txt
```

display all the lines that contain the word "the" in them
```
grep "\bthe\b"
```
Note: `\b` - [word boundary](https://stackoverflow.com/questions/2879085/how-to-grep-for-the-whole-word)

same but case insensitive
```
grep -i "\bthe\b"
```

remove all those lines that contain the word 'that'
```
grep -ivw "that"
# -v   : Invert the sense of matching
# -i   : Ignore case distinctions
# -w   : Match only those lines containing the whole word
```
use grep to display all those lines which contain any of the following words in them:
the,
that,
then,
those.
The search should not be sensitive to case. Display only those lines of an input file, which contain the required words.
```
grep -iwE "the|that|then|those"
```
Note: -E is extended (allows using "|")

N credit card numbers, each in a new line. grep out and output only those which have two or more consecutive occurences of the same digit (which may be separated by a space, if they are in different segments). Assume that the credit card numbers will have 4 space separated segments with 4 digits each.
```
grep '\([0-9]\) *\1'
```
Takes a digit ([0-9]), remembers it (\\...\\), looks for zero or more spaces ( *) followed by a repeat of the stored digit (\1).
