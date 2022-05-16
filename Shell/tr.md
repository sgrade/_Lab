usage: tr [-Ccsu] string1 string2
       tr [-Ccu] -d string1
       tr [-Ccu] -s string1
       tr [-Ccu] -ds string1 string2

replace all parentheses () with box brackets [].
tr "()" "[]"

convert lower case to upper case
$cat greekfile | tr “[a-z]” “[A-Z]”

delete all the lowercase characters a-z.
tr -d a-z

replace all sequences of multiple spaces with just one space.
tr -s ' '

replace the newlines in the file with tabs
tr "\n" "\t"
