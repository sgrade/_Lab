Array
```
declare -a
```

Everything in (()) is considered as part of arithmetic expression


Given a list, each on a new line, read them into an array and then display the entire array space-delimited
```
a=$(cat)
echo ${a[@]}
```

Same but elements from 2 to 7 (5 elements)
```
a=($(cat))
echo ${a[@]:3:5}
```

Display the array 3 times (concatenate)
```
a=$(cat)
echo $a $a $a
```

Display 3rd element
```
a=($(cat))
echo ${a[3]}
```

Count number of elements in array
```
arr=($(cat))
echo ${#arr[@]}
```

Substitute first letter of each word (capital) with .
```
a=($(cat))
echo ${a[@]/[A-Z]/.}
```

Substitution
```
a=$(ls)

echo a
a

echo $a
awk.help
awk.md
...
```


Read into an array and then filter out (remove) all containing the letter 'a' or 'A'.
```
a=$(cat | grep -vi a)
echo $a
```

use for loops to display only odd natural numbers from 1 to 99.
```
#!/bin/bash
for i in {1..99}
do
if ((i % 2)); then
echo $i
fi
done
```

conditionals
```
#!/bin/bash
read X
read Y
read Z

if [ $X -eq $Y ] || [ $X -eq $Z ] || [ $Y -eq $Z ]; then

    if [ $((X + Y)) -eq $((Z * 2)) ]; then
        echo "EQUILATERAL"
    else
        echo "ISOSCELES"
    fi

else
    echo "SCALENE"
fi
```

read formula
```
echo $formula | bc -l | xargs printf "%.3f"
```

Cycle
```
sum=0
read n
while read -r line || [[ -n "$line" ]]; do
    sum=$(($sum + $line))
done
printf "%.3f" $(echo "scale=10; $sum/$n" | bc -l)
```

The script is from [the Discussions](https://www.hackerrank.com/challenges/fractal-trees-all/forum/comments/182305). I just analyzed it.
```
declare -A matrix
num_rows=63
num_columns=100

declare -a roots
roots[0]=50

for ((i=1;i<=num_rows;i++)) do
    for ((j=1;j<=num_columns;j++)) do
        matrix[$i,$j]='_'
    done
done

read n
j=63
len=16
for ((i=1; i<=n; i++)) do
    lim=$((${#roots[@]}-1))
    elems=${#roots[@]}
    old_j=$j
    for((k=0; k<=lim; k++)) do
        pos=${roots[$k]}
        #print the trunk
        for((m=0; m<=len-1; m++)) do
            matrix[$j,$pos]='1'
            ((j--))
        done
        #print the branches
        for((m=1; m<=len; m++)) do
            matrix[$j,$((pos-m))]='1'
            matrix[$j,$((pos+m))]='1'
            ((j--))
        done
        roots=("${roots[@]}" "$((pos-m+1))" "$((pos+m-1))" )
        if (( $k < $lim ))
        then
            j=$old_j
        fi
    done
    for((k=0; k<$elems; k++)) do
        unset roots[$k]
    done
    roots=( "${roots[@]}" )
    len=$((len/2))
done

# print the matrix
for ((i=1;i<=num_rows;i++)) do
    for ((j=1;j<=num_columns;j++)) do
        printf ${matrix[$i,$j]}
    done
    printf "\n"
done
```
