main () { 
    puts ( "Hello Puts" );
    printf ( "Hello Printf" );
    printf ( "hi" , 3 + 4, 2 / 4, "done" );
    printf ( "AND" , 3 && 4 );
    printf ( "OR" , 3 || 4 );
    printf ( "EQUAL" , 3 == 4 );
    printf ( "NOT EQUAL" , 3 != 4 );
    printf ( "GREATER" , 3 > 4 );
    printf ( "LESS" , 3 < 4 );
    printf ( "GREATER OR EQUAL" , 3 >= 4 );
    printf ( "LESS OR EQUAL" , 3 <= 4 );
    printf ( "Precendence" , 3 + 4 * 5 );
    printf ( "Precendence (logic)" , 3 && 4 || 5 );
    
    while ( 3 || 4 ) { puts ( "A three or a four" ); }
}