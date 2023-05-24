// Test encargado de probar el correcto funcionamiento del return final en las funciones

int vector[5];

mifuncion ( int parametroa , int parametrob ) {
    puts("hola") ;
    puts("mundo") ;
    return (v * v);
}

mifuncion2 ( int parametroa , int parametrob ) {
    puts("hola") ;
    puts("mundo") ;
    return v;
}

mifuncion ( int parametroa , int parametrob ) {
    puts("holaaa") ;
    puts("mundo") ;
    return ;
}

mifuncion ( int parametroa , int parametrob ) {
    puts("holaaa") ;
    puts("mundo") ;
}

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

