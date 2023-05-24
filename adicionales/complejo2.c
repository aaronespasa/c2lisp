int v ;

mifuncion ( int parametroa , int parametrob ) {
    puts("v = 3 :") ;
    v = 3 ;
    return (v * v);
}

mifuncion2 ( int parametroa , int parametrob ) {
    puts("v = 2 :") ;
    v = 2 ;
    return v;
}

mifuncion3 ( int parametroa , int parametrob ) {
    puts ("sin retornar valor") ;
    return ;
}

mifuncion4 ( int parametroa , int parametrob ) {
    puts ( "sin retornar valor") ;
}


multiple_value_return (int a, int b) {
    int c, d ;
    c = 2 ;

    {
        int d ;
        d = 3 ;
        c = c * d ;
    }

    {
        int i ;
        for (i = 0 ; i < 10 ; i = i + 1) {
            if ( i % 2 == 0 && (i > 5) || i - 1 > 0) {
                b = b + 1 ;
            } else {
                if ( i + 1 + 3 ) {
                    b = b + 2 ;
                }
                b = b - 1 ;
            }
        }
    }

    for (int j = 0; j < 3; j = j + 1) {
        puts ( "Esto se ejecuta 3 veces") ;
    }

    puts ( "Devolviendo el resultado: ") ;
    {
        int z ;
        z = 40 ;
        return a , b , c , d , z ;
    }

    puts ( "Aquí no llega nunca") ;
    return b, c, d ;
}

int main () {
    int a , b, c, d, z ;
    a = 44 ;

    int vector[10] ;
    vector[6] = 2 ;

    a , b , c , d , z = multiple_value_return ( a, vector[- 6 + 3 * 4] ) ;

    puts ( "Valores devueltos: ") ;
    printf ( "%d\n", "a", a, "b", b, "c", c, "d", d, "z", z ) ;

    // llamar a mifuncion, mifuncion2, mifuncion3 y mifuncion4
    a = mifuncion ( a, b ) ;
    printf ( "%d\n", a ) ;
    b = mifuncion2 ( a, b ) ;
    printf ( "%d\n", b ) ;
    mifuncion3 ( a, b ) ;
    mifuncion4 ( a, b ) ;


    return 0 ;

//     system ("pause") ;
}

//@ (main)


