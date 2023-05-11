es_par (int v) {
    int ep ;
    printf ("%d", v) ;
    if (v % 2 == 0) {
        puts (" es par") ;
        ep = 1 ;
    } else {
        puts (" es impar") ;
        ep = 0 ;
    }
    return ep ;
}

main ( ) {
    puts ("hi") ;
    // es_par(10) ;
}