int a ;

int bar ( ) {
    puts ( "hi" ) ;
}

func ( ) {
    int b = 10 ;
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

//     system("pause") ;
}

//@ (main)

