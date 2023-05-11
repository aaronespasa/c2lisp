#!/bin/bash
bison -d trad.y && gcc -o trad trad.tab.c

# declare an array of strings

file_paths=(
    "avanzadas/collatz1.c"
    "avanzadas/factorial2.c"
    "avanzadas/fibonacci1.c"
    "avanzadas/fibonacci2.c"
    "avanzadas/fibonacci3.c"
    "avanzadas/funciones5.c"
    "avanzadas/funciones6.c"
    "avanzadas/potencias1.c"
    "avanzadas/primos2.c"
    "avanzadas/primos3.c"
    "avanzadas/primos4.c"
    "avanzadas/primos5.c"
    "iniciales/factorial1.c"
    "iniciales/funciones1.c"
    "iniciales/funciones2.c"
    "iniciales/funciones3.c"
    "iniciales/funciones4.c"
    "iniciales/primos1.c"
    "iniciales/printf1.c"
    "iniciales/printf2.c"
    "iniciales/puts1.c"
    "iniciales/while1.c"
)

for file_path in "${file_paths[@]}"; do
    type=$(dirname "$file_path")
    filename=$(basename "$file_path")
    mkdir -p "./resultado/$type"
    output=$(cat "./pruebas/$file_path" | ./trad 2>&1 > "./resultado/$type/$filename")
    if [[ $output =~ "syntax error" ]]; then
        echo "❌ The file $filename has failed"
    fi
done