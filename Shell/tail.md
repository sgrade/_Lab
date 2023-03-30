```
usage: tail [-F | -f | -r] [-q] [-b # | -c # | -n #] [file ...]
```

Display the last  lines of an input file.
```
tail -n 20
```

Display the last  characters of an input file.
```
tail -c 20
```

tail -n +X starts at line X beginning at 1, i.e., it shows all but the first (X-1) lines.

Display whole file. 
```
tail -n +1 file.txt
```

Display content of all files separated by `==> filename <==\n`
```
tail -n +1 *
```
