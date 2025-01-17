%{
	#include<stdio.h>
	#include<stdlib.h>		
	int yylex();
	int yyerror();
	int yywrap();
	
%}
%token NUM
%left '+' '-'
%left '/' '*'
%%
S:I {printf("Result is %d\n",$$);}
;
I:I'+'I 	{$$=$1+$3;}
|I'-'I 		{$$=$1-$3;}
|I'*'I 		{$$=$1*$3;}
|I'/'I 		{if($3==0){yyerror();}	else{$$=$1/$3;}}
|'('I')'	{$$=$2;}
|NUM		{$$=$1;}
|'-'NUM		{$$=-$2;}
;
%%
int main()
{
	printf("Enter operation:\n");
	yyparse();
	printf("Valid\n");
	return 0;
}
int yyerror()
{
	printf("Invalid\n");
	exit(0);
}

int yywrap(){
	return 1;
}
