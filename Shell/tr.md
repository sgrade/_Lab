```
usage: tr [-Ccsu] string1 string2
       tr [-Ccu] -d string1
       tr [-Ccu] -s string1
       tr [-Ccu] -ds string1 string2
```

sed vs tr

Use sed to change any string of printable characters into what ever other printable characters.

Using tr you can change any one character into any other character, except null (code 0).

[source](https://seismo.berkeley.edu/~rallen/resources/UNIXcmds/sed_tr_cut_od.html)

replace all parentheses () with box brackets [].
```
tr "()" "[]"
```

convert lower case to upper case
```
$cat greekfile | tr “[a-z]” “[A-Z]”
```

delete all the lowercase characters a-z.
```
tr -d a-z
```

replace all sequences of multiple spaces with just one space.
```
tr -s ' '
```

replace the newlines in the file with tabs
```
tr "\n" "\t"
```
