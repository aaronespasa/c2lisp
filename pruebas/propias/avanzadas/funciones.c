#include <stdio.h>

// En esta prueba se prueba la definición de múltiples funciones y su uso.

mimax (int a, int b) 
{
	if (a >= b) {
	    printf ("%d", a) ;
	} else {
	    printf ("%d", b) ;
	}  
}

mimin (int a, int b) 
{
	if (a < b) {
	    printf ("%d", a) ;
	} else {
	    printf ("%d", b) ;
	}  
}

miprint (int a) 
{
    printf ("%d", a) ;
}

main ()
{
    mimax (10, 1) ;
    mimin (1, 10) ;
    mimax (10,10) ;
    mimin (10,10) ;
    miprint (10) ;
          
//     system ("pause") ;
}

//@ (main)
