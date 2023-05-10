%{                          // SECCION 1 Declaraciones de C-Yacc
/* Aaron Espasandin Geselmann Carlos Iborra Llopis 01
   100451339@alumnos.uc3m.es 100451170@alumnos.uc3m.es */
#include <stdio.h>
#include <ctype.h>            // declaraciones para tolower
#include <string.h>           // declaraciones para cadenas
#include <stdlib.h>           // declaraciones para exit ()

#define FF fflush(stdout);    // para forzar la impresion inmediata

int yylex () ;
int yyerror () ;
char *mi_malloc (int) ;
char *gen_code (char *) ;
char *int_to_string (int) ;
char *char_to_string (char) ;

char temp [2048] ;

// Definitions for explicit attributes

typedef struct s_attr {
        int value ;
        char *code ;
} t_attr ;



#define YYSTYPE t_attr

%}

// Definitions for explicit attributes

%token RETURN           // identifica el retorno de una funcion
%token NUMBER           // identifica los numeros
%token IDENTIF          // Identificador=variable
%token INTEGER          // identifica el tipo entero
%token STRING           // identifica las cadenas literales
%token PUTS             // identifica la impresión de cadenas literales
%token PRINT            // identifica la impresión de cadenas literales y expresiones
%token MAIN             // identifica el comienzo del proc. main
%token WHILE            // identifica el bucle main
%token FOR              // identifica el bucle for
%token IF               // identifica el condicional if
%token ELSE             // identifica el condicional else
%token AND              // identifica el operador AND
%token OR               // identifica el operador OR
%token NEQ              // identifica el operador !=
%token EQ               // identifica el operador ==
%token LEQ              // identifica el operador <=
%token GEQ              // identifica el operador >=

%right '=' // es la ultima operacion que se debe realizar
%left OR // lower precedence
%left AND // higher precedence than OR
%left EQ NEQ // equal precedence, higher than AND and OR
%left '<' '>' LEQ GEQ // equal precedence, higher than EQ and NEQ
%left '+' '-' // higher precedence than relational operators
%left '*' '/' '%' // higher precedence than addition and subtraction
%nonassoc UNARY_SIGN // highest precedence, nonassociative

%%                            // Seccion 3 Gramatica - Semantico

axioma: declar_var_funcs              { ; }

declar_var_funcs: INTEGER variables ';'        { printf ("%s\n", $2.code) ; }
                  axioma                       { ; }
                  | declar_func                { ; }
                  ;

declar_func: funcion                   { printf("%s\n", $1.code) ; }
            r_declar_func              { ; }
            ;

r_declar_func:                          { ; }
                |      declar_func      { ; }
                ;

variables:  variable                    { sprintf (temp, "%s", $1.code) ;
                                           $$.code = gen_code (temp) ; }
            | variable ',' variables    { sprintf (temp, "%s %s", $1.code, $3.code) ;
                                           $$.code = gen_code (temp) ; }
            ;

variable:    IDENTIF                    { sprintf (temp, "(setq %s 0)", $1.code) ;
                                            $$.code = gen_code (temp) ; }
            | IDENTIF '[' NUMBER ']'    { sprintf (temp, "(setq %s (make-array %d))", $1.code, $3.value) ;
                                            $$.code = gen_code (temp) ; }
            | IDENTIF '=' NUMBER        { sprintf (temp, "(setq %s %d)", $1.code, $3.value) ;
                                           $$.code = gen_code (temp) ; }
            ;

// TODO: Buscar donde está el shift/reduce añadido
funcion:    MAIN '(' ')' '{' sentencias '}'            { sprintf (temp, "(defun main () \n%s\n)", $5.code) ;
                                                                    $$.code = gen_code (temp) ; }
            | nombre_funcion '(' parametros ')' '{' sentencias '}'      { sprintf (temp, "(defun %s (%s) \n%s\n)", $1.code, $3.code, $6.code) ;
                                                                            $$.code = gen_code (temp) ; }
            ;

nombre_funcion: IDENTIF                             { sprintf (temp, "%s", $1.code) ;
                                                        $$.code = gen_code (temp) ; }
                | INTEGER IDENTIF                   { sprintf (temp, "%s", $2.code) ;
                                                        $$.code = gen_code (temp) ; }
                ;

parametros:                                         { $$.code = gen_code("") ; }       
            | INTEGER IDENTIF ',' parametros        { sprintf (temp, "%s %s", $2.code, $4.code) ;
                                                        $$.code = gen_code (temp) ; }
            | INTEGER IDENTIF                       { sprintf (temp, "%s", $2.code) ;
                                                        $$.code = gen_code (temp) ; }
            ;

argumentos:                                         { $$.code = gen_code("") ; }       
            | expresion ',' argumentos        { sprintf (temp, "%s %s", $1.code, $3.code) ;
                                                        $$.code = gen_code (temp) ; }
            | expresion                       { sprintf (temp, "%s", $1.code) ;
                                                        $$.code = gen_code (temp) ; }
            ;

sentencias: sentencia                                                       { sprintf (temp, "\t%s", $1.code) ;
                                                                                $$.code = gen_code (temp) ; }
            | sentencias sentencia                                          { sprintf (temp, "%s\n\t%s", $1.code, $2.code) ;
                                                                                $$.code = gen_code (temp) ; }
            | sentencias '{' INTEGER local_variables_declar ';' sentencias_opt '}'    { sprintf(temp, "%s\n\t(%s\t%s\n\t)", $1.code, $4.code, $6.code) ;
                                                                                    $$.code = gen_code (temp) ;}
            | '{' INTEGER local_variables_declar sentencias_opt '}'    { sprintf(temp, "(%s\t\t%s\n\t)", $3.code, $4.code) ;
                                                                                    $$.code = gen_code (temp) ;}
            | sentencias RETURN retorno ';'                               { sprintf (temp, "%s\n\t(return-from %s%s)", $1.code, $0.code, $3.code) ;
                                                                                $$.code = gen_code (temp) ; }
            | RETURN retorno ';'                                          { sprintf (temp, "(return-from %s%s)", $0.code, $2.code) ;
                                                                                $$.code = gen_code (temp) ; }
            ;

sentencias_opt:                                { $$.code = gen_code("") ; }
                | sentencias                   { sprintf (temp, "%s", $1.code) ;
                                                 $$.code = gen_code (temp) ; }
                ;

retorno:                                        { sprintf (temp, "") ;
                                                    $$.code = gen_code (temp) ; }
            | expresion                         { sprintf (temp, " %s", $1.code) ;
                                                    $$.code = gen_code (temp) ; }
            | expresion ',' expresiones             { sprintf (temp, " (values %s %s)", $1.code, $3.code) ;
                                                    $$.code = gen_code (temp) ; }
            ;

expresiones: expresion                              { sprintf (temp, "%s", $1.code) ;
                                                        $$.code = gen_code (temp) ; }
            | expresion ',' expresiones             { sprintf (temp, "%s %s", $1.code, $3.code) ;
                                                        $$.code = gen_code (temp) ; }
            ;

sentencia:  var_assign ';'                                                                      { sprintf (temp, "%s", $1.code) ;
                                                                                                    $$.code = gen_code (temp) ; }
            | IDENTIF '(' argumentos ')' ';'                                                     { sprintf (temp, "(%s %s)", $1.code, $3.code) ; 
                                                                                                    $$.code = gen_code (temp) ; }
            | PUTS '(' STRING ')' ';'                                                           { sprintf (temp, "(print \"%s\")", $3.code) ; 
                                                                                                    $$.code = gen_code (temp) ; }
            | PRINT '(' STRING ',' impresion ')' ';'                                            { sprintf (temp, "%s", $5.code) ; 
                                                                                                    $$.code = gen_code (temp) ; }
            | WHILE '(' expresion ')' '{' sentencias '}'                                           { sprintf (temp, "\t(loop while %s do \n\t%s\n\t)", $3.code, $6.code) ;
                                                                                                    $$.code = gen_code (temp) ; }
            | IF '(' expresion_condicional ')' '{' sentencias_if '}' restif                       { sprintf (temp, "\n\t(if %s \n\t%s%s\t)", $3.code, $6.code, $8.code) ;
                                                                                                    $$.code = gen_code (temp) ; }
            | FOR '(' INTEGER local_variables_declar ';' expresion_condicional ';' var_assign ')' '{' sentencias '}'   { sprintf (temp, "\n\t(%s\t(loop while %s do \n\t%s\n\t%s\n\t))", $4.code, $6.code, $11.code, $8.code ) ;
                                                                                                    $$.code = gen_code (temp) ; }
            | FOR '(' var_assign ';' expresion_condicional ';' var_assign ')' '{' sentencias '}'   { sprintf (temp, "\n\t%s\n\t(loop while %s do \n\t%s\n\t%s\n\t)", $3.code, $5.code, $10.code, $7.code) ;
                                                                                                    $$.code = gen_code (temp) ; }
            | INTEGER local_variables_declar ';' sentencias                                         { sprintf (temp, "(%s %s\t)", $2.code, $4.code) ; 
                                                                                                         $$.code = gen_code (temp) ; }
            ;

// TODO: Añadir todo lo de sentencias en sentencias_if teniendo cuidado de poner progn
sentencias_if: sentencia                                     { sprintf (temp, "\t%s", $1.code) ;
                                                                   $$.code = gen_code (temp) ; }
               | sentencias sentencia                        { sprintf (temp, "(progn\n\t%s\n\t\t%s)", $1.code, $2.code) ;
                                                                   $$.code = gen_code (temp) ; }
               ;

restif:                                            { $$.code = gen_code("") ; }
                |    ELSE '{' sentencias_if '}'        { sprintf (temp, "\n\t%s\n", $3.code);
                                                        $$.code = gen_code (temp) ; }
                ;

// TODO: probar con clisp si la reasignación de variables/vectores usa un "entorno" local
var_assign:   IDENTIF '=' expresion                                          { sprintf (temp, "(setq %s %s)", $1.code, $3.code) ; 
                                                                                $$.code = gen_code (temp) ; }
            | IDENTIF '[' num_or_identif ']' '=' num_or_identif              { sprintf (temp, "(setf (aref %s %s) %s)", $1.code, $3.code, $6.code) ;
                                                                                $$.code = gen_code (temp) ; }
            | IDENTIF '=' IDENTIF '(' argumentos ')'                         { sprintf (temp, "(setf %s (%s %s))", $1.code, $3.code, $5.code);
                                                                                $$.code = gen_code (temp) ; }
            | IDENTIF ',' other_vars_left '=' IDENTIF '(' argumentos ')'     { sprintf (temp, "(setf (values %s %s) (%s %s))", $1.code, $3.code, $5.code, $7.code);
                                                                                $$.code = gen_code (temp) ; }
            | IDENTIF ',' other_vars_left '=' other_vars_right               { sprintf (temp, "(setf (values %s %s) (values %s))", $1.code, $3.code, $5.code);
                                                                                $$.code = gen_code (temp) ; }
            ;

other_vars_left:   IDENTIF                         { sprintf (temp, "%s", $1.code) ;
                                                $$.code = gen_code (temp) ; }
            | IDENTIF ',' other_vars_left          { sprintf (temp, "%s %s", $1.code, $3.code) ;
                                                $$.code = gen_code (temp) ; }
            ;

other_vars_right:   num_or_identif                         { sprintf (temp, "%s", $1.code) ;
                                                $$.code = gen_code (temp) ; }
            | num_or_identif ',' other_vars_right          { sprintf (temp, "%s %s", $1.code, $3.code) ;
                                                $$.code = gen_code (temp) ; }
            // | IDENTIF '(' argumentos ')'      { sprintf (temp, "(%s %s)", $1.code, $3.code) ; 
            //                                     $$.code = gen_code (temp) ; }
            ;

num_or_identif: NUMBER        { sprintf (temp, "%d", $1.value) ;   $$.code = gen_code (temp) ; }
              | IDENTIF       { sprintf (temp, "%s", $1.code) ; $$.code = gen_code (temp) ; }
            ;

local_variables_declar:  local_variable                    { sprintf (temp, "let (%s)\n", $1.code) ;
                                                        $$.code = gen_code (temp) ; }
            | local_variable ',' local_variables    { sprintf (temp, "let (%s\n\t\t  %s)\n", $1.code, $3.code) ;
                                                        $$.code = gen_code (temp) ; }
            ;

local_variables:  local_variable                    { sprintf (temp, "%s", $1.code) ;
                                                        $$.code = gen_code (temp) ; }
            | local_variable ',' local_variables    { sprintf (temp, "%s\n\t\t  %s", $1.code, $3.code) ;
                                                        $$.code = gen_code (temp) ; }
            ;

local_variable:    IDENTIF                    { sprintf (temp, "(%s 0)", $1.code) ;
                                                $$.code = gen_code (temp) ; }
            | IDENTIF '[' NUMBER ']'          { sprintf (temp, "(%s (make-array %d))", $1.code, $3.value) ;
                                                $$.code = gen_code (temp) ; }
            | IDENTIF '=' NUMBER              { sprintf (temp, "(%s %d)", $1.code, $3.value) ;
                                                $$.code = gen_code (temp) ; }
            ;

impresion :                                            { $$.code = gen_code("") ; }
            | STRING                                   { sprintf (temp, "(print \"%s\")", $1.code) ; 
                                                          $$.code = gen_code (temp) ; }
            | STRING ',' impresion                     { sprintf (temp, "(print \"%s\") %s", $1.code, $3.code) ; 
                                                          $$.code = gen_code (temp) ; }
            | IDENTIF '[' NUMBER ']'                   { sprintf (temp, "(print (aref %s %d))", $1.code, $3.value) ; 
                                                          $$.code = gen_code (temp) ; }
            | IDENTIF '[' NUMBER ']' ',' impresion     { sprintf (temp, "(print (aref %s %d)) %s", $1.code, $3.value, $6.code) ; 
                                                          $$.code = gen_code (temp) ; }
            | expresion                                { sprintf (temp, "(print %s)", $1.code) ; 
                                                          $$.code = gen_code (temp) ; }
            | expresion ',' impresion                  { sprintf (temp, "(print %s) %s", $1.code, $3.code) ; 
                                                          $$.code = gen_code (temp) ; }
            ;

expresion:      termino                  { $$ = $1 ; }
            |   expresion '+' expresion  { sprintf (temp, "(+ %s %s)", $1.code, $3.code) ;
                                                    $$.code = gen_code (temp) ; }
            |   expresion '-' expresion  { sprintf (temp, "(- %s %s)", $1.code, $3.code) ;
                                            $$.code = gen_code (temp) ; }
            |   expresion '*' expresion  { sprintf (temp, "(* %s %s)", $1.code, $3.code) ;
                                            $$.code = gen_code (temp) ; }
            |   expresion '/' expresion  { sprintf (temp, "(/ %s %s)", $1.code, $3.code) ;
                                            $$.code = gen_code (temp) ; }
            |   expresion '%' expresion  { sprintf (temp, "(mod %s %s)", $1.code, $3.code) ;
                                            $$.code = gen_code (temp) ; }
            |   expresion AND expresion  { sprintf (temp, "(and %s %s)", $1.code, $3.code) ;
                                            $$.code = gen_code (temp) ; }
            |   expresion OR expresion   { sprintf (temp, "(or %s %s)", $1.code, $3.code) ;
                                            $$.code = gen_code (temp) ; }
            |   expresion EQ expresion   { sprintf (temp, "(= %s %s)", $1.code, $3.code) ;
                                            $$.code = gen_code (temp) ; }
            |   expresion NEQ expresion  { sprintf (temp, "(/= %s %s)", $1.code, $3.code) ;
                                            $$.code = gen_code (temp) ; }
            |   expresion LEQ expresion  { sprintf (temp, "(<= %s %s)", $1.code, $3.code) ;
                                            $$.code = gen_code (temp) ; }
            |   expresion GEQ expresion  { sprintf (temp, "(>= %s %s)", $1.code, $3.code) ;
                                            $$.code = gen_code (temp) ; }
            |   expresion '<' expresion  { sprintf (temp, "(< %s %s)", $1.code, $3.code) ;
                                            $$.code = gen_code (temp) ; }
            |   expresion '>' expresion  { sprintf (temp, "(> %s %s)", $1.code, $3.code) ;
                                            $$.code = gen_code (temp) ; }
            ;

expresion_condicional:  expresion '+' expresion  { sprintf (temp, "(/= 0 (+ %s %s))", $1.code, $3.code) ;
                                                    $$.code = gen_code (temp) ; }
                    |   expresion '-' expresion  { sprintf (temp, "(/= 0 (- %s %s))", $1.code, $3.code) ;
                                                    $$.code = gen_code (temp) ; }
                    |   expresion '*' expresion  { sprintf (temp, "(/= 0 (* %s %s))", $1.code, $3.code) ;
                                                    $$.code = gen_code (temp) ; }
                    |   expresion '/' expresion  { sprintf (temp, "(/= 0 (/ %s %s))", $1.code, $3.code) ;
                                                    $$.code = gen_code (temp) ; }
                    |   expresion AND expresion  { sprintf (temp, "(and %s %s)", $1.code, $3.code) ;
                                                    $$.code = gen_code (temp) ; }
                    |   expresion OR expresion   { sprintf (temp, "(or %s %s)", $1.code, $3.code) ;
                                                    $$.code = gen_code (temp) ; }
                    |   expresion EQ expresion   { sprintf (temp, "(= %s %s)", $1.code, $3.code) ;
                                                    $$.code = gen_code (temp) ; }
                    |   expresion NEQ expresion  { sprintf (temp, "(/= %s %s)", $1.code, $3.code) ;
                                                    $$.code = gen_code (temp) ; }
                    |   expresion LEQ expresion  { sprintf (temp, "(<= %s %s)", $1.code, $3.code) ;
                                                    $$.code = gen_code (temp) ; }
                    |   expresion GEQ expresion  { sprintf (temp, "(>= %s %s)", $1.code, $3.code) ;
                                                    $$.code = gen_code (temp) ; }
                    |   expresion '<' expresion  { sprintf (temp, "(< %s %s)", $1.code, $3.code) ;
                                                    $$.code = gen_code (temp) ; }
                    |   expresion '>' expresion  { sprintf (temp, "(> %s %s)", $1.code, $3.code) ;
                                                    $$.code = gen_code (temp) ; }
                    ;

termino:        operando                            { $$ = $1 ; }                          
            |   '+' operando %prec UNARY_SIGN       { sprintf (temp, "(+ %s)", $2.code) ;
                                                        $$.code = gen_code (temp) ; }
            |   '-' operando %prec UNARY_SIGN       { sprintf (temp, "(- %s)", $2.code) ;
                                                        $$.code = gen_code (temp) ; }    
            ;

// TODO: Hacer función como operando
operando:       IDENTIF                 { sprintf (temp, "%s", $1.code) ;
                                           $$.code = gen_code (temp) ; }
            |   NUMBER                  { sprintf (temp, "%d", $1.value) ;
                                           $$.code = gen_code (temp) ; }
            // |   IDENTIF '(' argumentos ')' { sprintf (temp, "(%s %s)", $1.code, $3.code) ; 
            //                                 $$.code = gen_code (temp) ; }
            |   '(' expresion ')'       { $$ = $2 ; }
            ;


%%                            // SECCION 4    Codigo en C

int n_line = 1 ;

int yyerror (mensaje)
char *mensaje ;
{
    fprintf (stderr, "%s en la linea %d\n", mensaje, n_line) ;
    printf ( "\n") ;	// bye
    return -1;
}

char *int_to_string (int n)
{
    sprintf (temp, "%d", n) ;
    return gen_code (temp) ;
}

char *char_to_string (char c)
{
    sprintf (temp, "%c", c) ;
    return gen_code (temp) ;
}

char *my_malloc (int nbytes)       // reserva n bytes de memoria dinamica
{
    char *p ;
    static long int nb = 0;        // sirven para contabilizar la memoria
    static int nv = 0 ;            // solicitada en total

    p = malloc (nbytes) ;
    if (p == NULL) {
        fprintf (stderr, "No queda memoria para %d bytes mas\n", nbytes) ;
        fprintf (stderr, "Reservados %ld bytes en %d llamadas\n", nb, nv) ;
        exit (0) ;
    }
    nb += (long) nbytes ;
    nv++ ;

    return p ;
}


/***************************************************************************/
/********************** Seccion de Palabras Reservadas *********************/
/***************************************************************************/

typedef struct s_keyword { // para las palabras reservadas de C
    char *name ;
    int token ;
} t_keyword ;

t_keyword keywords [] = { // define las palabras reservadas y los
    "main",        MAIN,           // y los token asociados
    "return",      RETURN,
    "int",         INTEGER,
    "puts",        PUTS,
    "printf",      PRINT,
    "while",       WHILE,
    "for",         FOR,
    "if",          IF,
    "else",        ELSE,
    "&&",          AND,
    "||",          OR,
    "!=",          NEQ,
    "==",          EQ,
    "<=",          LEQ,
    ">=",          GEQ,
    NULL,          0               // para marcar el fin de la tabla
} ;

t_keyword *search_keyword (char *symbol_name)
{                                  // Busca n_s en la tabla de pal. res.
                                   // y devuelve puntero a registro (simbolo)
    int i ;
    t_keyword *sim ;

    i = 0 ;
    sim = keywords ;
    while (sim [i].name != NULL) {
	    if (strcmp (sim [i].name, symbol_name) == 0) {
		                             // strcmp(a, b) devuelve == 0 si a==b
            return &(sim [i]) ;
        }
        i++ ;
    }

    return NULL ;
}

 
/***************************************************************************/
/******************* Seccion del Analizador Lexicografico ******************/
/***************************************************************************/

char *gen_code (char *name)     // copia el argumento a un
{                                      // string en memoria dinamica
    char *p ;
    int l ;
	
    l = strlen (name)+1 ;
    p = (char *) my_malloc (l) ;
    strcpy (p, name) ;
	
    return p ;
}


int yylex ()
{
    int i ;
    unsigned char c ;
    unsigned char cc ;
    char ops_expandibles [] = "!<=>|%/&+-*" ;
    char temp_str [256] ;
    t_keyword *symbol ;

    do {
        c = getchar () ;

        if (c == '#') {	// Ignora las lineas que empiezan por #  (#define, #include)
            do {		//	OJO que puede funcionar mal si una linea contiene #
                c = getchar () ;
            } while (c != '\n') ;
        }

        if (c == '/') {	// Si la linea contiene un / puede ser inicio de comentario
            cc = getchar () ;
            if (cc != '/') {   // Si el siguiente char es /  es un comentario, pero...
                ungetc (cc, stdin) ;
            } else {
                c = getchar () ;	// ...
                if (c == '@') {	// Si es la secuencia //@  ==> transcribimos la linea
                    do {		// Se trata de codigo inline (Codigo embebido en C)
                        c = getchar () ;
                        putchar (c) ;
                    } while (c != '\n') ;
                } else {		// ==> comentario, ignorar la linea
                    while (c != '\n') {
                        c = getchar () ;
                    }
                }
            }
        } else if (c == '\\') c = getchar () ;

        if (c == '\n')
            n_line++ ;

    } while (c == ' ' || c == '\n' || c == 10 || c == 13 || c == '\t') ;

    if (c == '\"') {
        i = 0 ;
        do {
            c = getchar () ;
            temp_str [i++] = c ;
        } while (c != '\"' && i < 255) ;
        if (i == 256) {
            printf ("AVISO: string con mas de 255 caracteres en linea %d\n", n_line) ;
        }		 	// habria que leer hasta el siguiente " , pero, y si falta?
        temp_str [--i] = '\0' ;
        yylval.code = gen_code (temp_str) ;
        return (STRING) ;
    }

    if (c == '.' || (c >= '0' && c <= '9')) {
        ungetc (c, stdin) ;
        scanf ("%d", &yylval.value) ;
//         printf ("\nDEV: NUMBER %d\n", yylval.value) ;        // PARA DEPURAR
        return NUMBER ;
    }

    if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')) {
        i = 0 ;
        while (((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') ||
            (c >= '0' && c <= '9') || c == '_') && i < 255) {
            temp_str [i++] = tolower (c) ;
            c = getchar () ;
        }
        temp_str [i] = '\0' ;
        ungetc (c, stdin) ;

        yylval.code = gen_code (temp_str) ;
        symbol = search_keyword (yylval.code) ;
        if (symbol == NULL) {    // no es palabra reservada -> identificador antes vrariabre
//               printf ("\nDEV: IDENTIF %s\n", yylval.code) ;    // PARA DEPURAR
            return (IDENTIF) ;
        } else {
//               printf ("\nDEV: OTRO %s\n", yylval.code) ;       // PARA DEPURAR
            return (symbol->token) ;
        }
    }

    if (strchr (ops_expandibles, c) != NULL) { // busca c en ops_expandibles
        cc = getchar () ;
        sprintf (temp_str, "%c%c", (char) c, (char) cc) ;
        symbol = search_keyword (temp_str) ;
        if (symbol == NULL) {
            ungetc (cc, stdin) ;
            yylval.code = NULL ;
            return (c) ;
        } else {
            yylval.code = gen_code (temp_str) ; // aunque no se use
            return (symbol->token) ;
        }
    }

//    printf ("\nDEV: LITERAL %d #%c#\n", (int) c, c) ;      // PARA DEPURAR
    if (c == EOF || c == 255 || c == 26) {
//         printf ("tEOF ") ;                                // PARA DEPURAR
        return (0) ;
    }

    return c ;
}


int main ()
{
    yyparse () ;
}