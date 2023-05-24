// Test encargado de probar el correcto funcionamiento de los while (+ if + return)

mifunc ( ) {
    int i = 0, m = 10;
    while ( i < m) {
        if (i == 5) {
            return;
        }
        puts ( "Hola\n" );
        i = i + 1;
    }
}

main ( ) {
    int i = 0;
    while (i < 10) {
        puts ( "Hola\n" );
        i = i + 1;
    }
    puts ( "hey\n" ) ;

//     system ("pause") ;
}

//@ (main)

