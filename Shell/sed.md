`sed` - to substitute

```
usage: sed script [-Ealnru] [-i extension] [file ...]
	sed [-Ealnu] [-i extension] [-e script] ... [-f script_file] ... [file ...]
```

The -n option:
```
-n, --quiet, --silent
```
suppress automatic printing of pattern space

The p command:
Print the current pattern space.
---

Display the lines (from line number 12 to 22, both inclusive) of a given text file.
```
sed -n '12,22 p'
```
```
sed -n 'm,n p' bigfile > smaller_file
```

Substitute the first occurrence of 'editor' with 'tool'
```
sed -e s/editor/tool/
```

Substitute all the occurrences of 'editor' with 'tool'
```
sed -e s/editor/tool/g
```

Substitute the second occurrence of 'editor' with 'tool'
```
sed -e s/editor/tool/2
```

Highlight all the occurrences of 'editor' by wrapping them up in brace brackets
```
sed -e s/editor/{\&}/g
```

transform the first occurrence of the word 'the' with 'this'. The search and transformation should be strictly case sensitive
```
sed 's/\bthe\b/this/'
```
[About `\b`](https://unix.stackexchange.com/questions/230795/sed-how-to-use-b-word-boundary-correctly)

case-insensitive global (all occurrences)
```
sed 's/thy/your/ig'
```

highlight all the occurrences of 'thy' by wrapping them up in brace brackets. The search should be case-insensitive.
```
sed -e 's/thy/{&}/ig'
```
-e is optional, unless you want to specify more than one set of sed commands on the command-line. If you don't use -es when multiple sets of commands are provided, sed has no way of telling whether the second parameter is commands or the input filename.

Given n lines of credit card numbers, mask the first 12 digits of each credit card number with an asterisk. Each credit card number consists of four space-separated groups of four digits.
```
sed -r 's/[0-9]{4} /**** /g'
```

4 space separated segments with 4 digits each. reverse the ordering of segments
```
sed -r 's/(.... )(.... )(.... )(....)/\4 \3\2\1/'
```
