%{

#pragma warning(disable: 4996 6387 6011 6385)
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <ctype.h>
#include <wchar.h>
#include <locale.h>


//definiciones de directiva
#define MAX_PALABRAS 15000
#define MAX_LONGITUD 200
#define MAX_INCLUDE_DEPTH 10


// variable globaless
int include_stack_ptr = 0;
unsigned int nivel_de_includes = 0;
char directorio[MAX_LONGITUD]="";
char archivo_de_entrada[MAX_LONGITUD]="";
char archivo_a_abrir[MAX_LONGITUD]="";

//Definicion de variable de flex
YY_BUFFER_STATE include_stack[MAX_INCLUDE_DEPTH]; /* PILA para archivos */

%}


%option noyywrap
%option outfile="Fuerza_Bruta.c"

TERMINAL            [+*()a]+
NO_TERMINAL         [ETKFR]

%%


{TERMINAL} {
		//funcion al encontrar el token NOMBRE
        printf("Terminal: %s \n", yytext);
	  }

{NO_TERMINAL} {
		//funcion al encontrar el token NOMBRE
        printf("No terminal: %s \n", yytext);
	  }

<<EOF>> { /* Si se detecta el fin de archivo se retorna */
		if ( --include_stack_ptr < 0 )
		    yyterminate();
		else
		{
			yy_delete_buffer( YY_CURRENT_BUFFER );
			yy_switch_to_buffer( include_stack[include_stack_ptr] );
			printf("Cerrando el archivo %s\n",archivo_a_abrir );
		}
	}

","
.       printf("Caracter invalido %s\n",yytext);      
%%

int main( int argc, char* argv[] )
{
	//Habilitamos que se pueda ver carateres especiales del español
	if ( argc == 3 )
	{
		strcpy(directorio, argv[1]);
		strcat(directorio, "\\");
		strcpy(archivo_de_entrada, argv[2]);
		strcpy(archivo_a_abrir, directorio);
		strcat(archivo_a_abrir, archivo_de_entrada);
		//Abrimos indice de canciones
		yyin = fopen(archivo_a_abrir, "r" );
		if (yyin)
		{
			printf("Directorio de trabajo: %s\n", directorio);
			printf("Leyendo del archivo: %s\n", archivo_de_entrada);
		}
	}
	else
	{
		printf("Este programa solo lee de un archivo no puede leer de una entrada de teclado");
		return(1);
	}
	yylex();
	return(0);
}