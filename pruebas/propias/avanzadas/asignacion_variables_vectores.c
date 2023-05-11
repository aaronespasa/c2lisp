// Test encargado de comprobar la asignacion de variables (y vectores) con scope global y local

int vector[5];

main ( ) {
    printf("%s", vector);
    int i = 0;
    while (i < 5) {
        vector[i] = i;
        i = i + 1;
    }
    printf("%s", vector);
    vector[0] = 123;
    printf("%s", vector[0]);
    printf("%s", vector);
    printf("%s", vector[10]);

//     system ("pause") ;
}

//@ (main)
