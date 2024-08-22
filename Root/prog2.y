%{
#include<stdio.h>
#include<stdlib.h>
int yyerror();
int yylex();
int yywrap();
%}
%%
S:A B
;
A:'a'A'b'
|
;
B:'b'B'c'
|
;
%%
int main()
{
	printf("Enter the input:\n");
	yyparse();
	printf("Valid string\n");
}
int yyerror()
{
	printf("Invalid string\n");
	exit(0);
	
}
int yywrap(void) {
    return 1; // Return 1 to indicate that no more input files are available.
}

