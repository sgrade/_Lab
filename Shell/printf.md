```
printf [-v var] format [arguments]
```

The -v option tells printf not to print the output but to assign it to the variable.

The format is a string which may contain three different types of objects:
- Normal characters that are simply printed to the output as-is.
- Backslash-escaped characters which are interpreted and then printed.
- Conversion specifications that describe the format and are replaced by the values of respective arguments that follow the format string.

[Source](https://linuxize.com/post/bash-printf-command/)

```
printf "Open issues: %s\nClosed issues: %s\n" "34" "65"
```
