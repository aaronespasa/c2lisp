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
    "adicionales/ambito_anidado.c"
    "adicionales/asignacion_variables_vectores.c"
    "adicionales/asignaciones_multiples.c"
    "adicionales/condicional_funciones.c"
    "adicionales/complejo1.c"
    "adicionales/complejo2.c"
    "adicionales/funciones.c"
    "adicionales/local-variables.c"
    "adicionales/promocion.c"
    "adicionales/return_final_funciones.c"
    "adicionales/variables_locales.c"
    "adicionales/vectores.c"
    "adicionales/while_con_declaracion.c"
)

for file_path in "${file_paths[@]}"; do
    type=$(dirname "$file_path")
    filename=$(basename "$file_path")
    # remove the .c extension and add .lisp
    lisp_filename="${filename%.*}.lisp"
    mkdir -p "./resultado/$type"
    output=$(cat "./pruebas/$file_path" | ./trad 2>&1 > "./resultado/$type/$lisp_filename")
    if [[ $output =~ "syntax error" ]]; then
        echo "❌ The file $filename has failed"
    fi
done

# Loop through all subdirectories in the "resultado" folder
find ./resultado -type d | while read -r subdir; do
    # Loop through all .lisp files in the current subdirectory
    find "$subdir" -type f -name "*.lisp" | while read -r lisp_file; do
        # Compile the .lisp file with clisp
        output=$(clisp "$lisp_file" 2>&1)
        
        # Check if the output starts with "*** - SYSTEM"
        if [[ $output =~ ^\*\*\*\ -\ SYSTEM ]]; then
            # Get the filename without the path
            filename=$(basename "$lisp_file")
            # Print an error message
            echo "❌ The file $filename has an incorrect semantic"
        fi
    done
done