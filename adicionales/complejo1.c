// Test complejo 1 para poner a prueba el traductor

int vector[10] ;

int multiply_by_2 ( int a ) {
    return a * 2 ;
}

int calcular_suma ( int a, int b ) {
    int i, suma, j, k, vectorm[5], z;
    vectorm[3] = 1 ;
    for ( i = 0 ; i < a ; i = i + 1 ) {
        for ( j = 0 ; j < b ; j = j + 1 ) {
            suma = suma + 1 ;
            {
                int k, z ;
                for ( k = 0 ; k < 10 ; k = k + 1 ) {
                    if ( k % 2 == 0 ) {
                        if ( i == a - 1 && j == b - 1 ) {
                            int new_var;
                            new_var = 10;
                            puts ( "new_var debería ser 10: ") ;
                            printf ( "%d\n", new_var ) ;
                        }
                        vector[k] = k ;
                    } else {
                        vector[k] = multiply_by_2 ( k ) ;
                    }
                }
                z = 40 ;
            }
        }

        {
            int vectorm[10], i = 4;
            vectorm[3] = 1 ;

            while ( i < 5 ) {
                vectorm[3] = vectorm[3] + 1 ;
                i = i + 1 ;
            }
            
            puts ( "m debería ser 2: ") ;
            printf ( "%d\n", vectorm[3] ) ;
        }
    }

    puts ( "z debería ser 0 al no ser asignado: ") ;
    printf ( "%d\n", z ) ;

    puts ( "Vector: ") ;
    for ( i = 0 ; i < 10 ; i = i + 1 ) {
        printf ( "%d\n", vector[i] ) ;
    }

    puts ( "Vector pares: ") ;
    for ( i = 0 ; i < 5 ; i = i + 1 ) {
        printf ( "%d\n", vector[i * 2] ) ;
    }

    puts ( "valor de m que debería ser 1: ") ;
    printf ( "%d\n", vectorm[3] ) ;

    return suma ;
}

main ( ) {
    int suma ;
    suma = calcular_suma ( 10, 20 ) ;

    puts ( "La suma es: " ) ;
    printf ( "%d\n", suma ) ;

//     system ("pause") ;
}

//@ (main)

