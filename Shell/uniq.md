remove the consecutive repetitions
```
uniq
```

count the number of times each line repeats itself. remove leading spaces
```
uniq -c | cut -c7-
```

same, but case insensitive
```
uniq -ci | cut -c7-
```

display only those lines which are not followed or preceded by identical replications.
```
uniq -u
```
