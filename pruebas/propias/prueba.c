int vector[5];

mifuncion ( parametro1, parametro2 ) {
    puts("holaaa") ;
    puts("holaaa") ;
    puts("holaaa") ;

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
}