// Prueba encargada de comprobar el correcto funcionamiento del ambito anidado (+ asignaciones multiples + return + printf)

int a = 3;

int bar ( ) {
    puts ( "hi" ) ;
}

func ( ) {
    a, b = b, a;
    a = b;
    return ;
    // a, b, c, d = b, a, d, c;
    printf("%s", "hii") ;
    return a , b , 8 * 4 ;
}

main () {
    int a = 1 ;
    a, b, c = func(2, a);
    printf("%d\n", a) ;
    {
        int a = 2 ;
        printf("%d\n", a) ;
    }
    printf("%d\n", a) ;

//     system ("pause") ;
}

//@ (main)
