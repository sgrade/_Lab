## Most important
Tab is default delimiter. To specify different, use -d.

-c - chars

-d - fields (words)

## Chars
Display the 2nd and 7th character from each line of text.
```
cut -c2,7
```

Display a range of characters starting at the 2nd position of a string and ending at the 7th position (both positions included).
```
cut -c2-7
```

Print the characters from thirteenth position to the end.
```
cut -c13-
```

## Fields
Given a tab delimited file with several columns (tsv format) print the first three fields.
```
cut -f1-3
```

Given a sentence, identify and display its fourth word. Assume that the space (' ') is the only delimiter between words.
```
cut -d ' ' -f4
```

Given a sentence, identify and display its first three words. Assume that the space (' ') is the only delimiter between words.
```
cut -d ' ' -f1-3
```

Given a tab delimited file with several columns (tsv format) print the fields from second fields to last field.
```
cut -f2-
```
