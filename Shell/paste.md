`paste` - to join files horizontally (parallel merging) by outputting lines consisting of the sequentially corresponding lines of each file specified, separated by tabs

restructure the file in such a way, that three consecutive rows are folded into one, and separated by tab
```
paste - - -
```

replace the newlines in the file with semicolons
```
paste -s -d ';'
```

restructure the file so that three consecutive rows are folded into one line and are separated by semicolons
```
paste - - - -d ';'
```
