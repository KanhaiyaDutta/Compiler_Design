%{
#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "ctype.h"

int no_of_args=0;
int t_count = 1;
FILE *op1, *op2, *op3;

extern int yylex(); //I need this fxn to modify input stream location

char *get_t_val();
void output(char *a1, char *a2, char *a3, char *a4);
int yywrap();
%}

%union{
char* str;
int num;
}
%token <str> NUM  //return number as string for now
%token <str> IDEN DATATYPE
%type <str> E T   //expressions should return t(x)

%left '+' '-'
%left '*' '/'
%right UMINUS

%%
S : S1 ';' S | ;
S1 : A | D | E | ;
D : DATATYPE IDEN | DATATYPE A ;
A : IDEN '=' E {output("=",$3, " ", $1); printf("(=, %s, ,%s)\n",$3,$1);}  //assign $3 to $1
	| IDEN '=' E ',' A {output("=",$3, "", $1); printf("(=, %s, ,%s)\n",$3,$1);} ;
E :	  E '+' E  {$$ = strdup(get_t_val()); output("+",$1,$3,$$); printf("(+, %s, %s, %s)\n", $1, $3, $$);} 
	| E '-' E  {$$ = strdup(get_t_val()); output("-",$1,$3,$$); printf("(-, %s, %s, %s)\n", $1, $3, $$);}
	| E '*' E  {$$ = strdup(get_t_val()); output("*",$1,$3,$$); printf("(*, %s, %s, %s)\n", $1, $3, $$);}
	| E '/' E  {$$ = strdup(get_t_val()); output("/",$1,$3,$$); printf("(/, %s, %s, %s)\n", $1, $3, $$);}
	| '(' E ')' {$$ = $2; } //no need to output anything here
	| '-'  E %prec UMINUS  {$$ = strdup(get_t_val());output("-",$2," ",$$); printf("(-, %s, , %s)\n", $2, $$);} 
	| T { $$=$1; };
T : NUM {$$=$1;}
  | IDEN {$$=$1;};
%%

int main(){
FILE *input_file = fopen("input.c","r");
yyrestart(input_file);
op1 = fopen("quadruples.txt","w");
op2 = fopen("three_addr.txt","w");
op3 = fopen("triples.txt","w");
yyparse();
}

char *ch_ip(char *x){
    char *y = malloc(13);
    y  = strdup(x);
    if(x[0]=='t' && isdigit(x[1]))    
    {
        int temp = atoi(x+1)-1;
        snprintf(y, 13, "(%d)",temp);
    }
    return y;
}

char *get_t_val(){
	char charStr[2] = "t";
	char numStr[11];  // number fits within int range
	snprintf(numStr, sizeof(numStr), "%d", t_count);
	t_count++;
    	// Concatenate the strings
	char *result = (char*)malloc(13 * sizeof(char)); //12+1
	strcpy(result, charStr);
	strcat(result, numStr);	
	return result;
}
//quadruples (op, arg1, arg2, res)
void output(char *op, char *a1, char *a2, char *res){
	fprintf(op1, "(%s,%s,%s,%s)\n",op,a1,a2,res); //quadruples
	
	if(op[0]== '=')
		fprintf(op2, "%s = %s;\n",res, a1); // a4 = a2;
	else if(op[0]=='-' && a2[0]==' ')
		fprintf(op2, "%s = -%s;\n",res, a1); //a4 = -a2;
	else
		fprintf(op2, "%s = %s %s %s;\n",res,a1,op,a2); //a4 = a2 a1 a3;
	
	char *b1,*b2, *ch_res;
	b1 = ch_ip(a1), b2 = ch_ip(a2); ch_res = ch_ip(res);
	if(op[0]=='=')
		fprintf(op3, "(%s,%s,%s)\n", op , ch_res , b1); //if of form, res = expression
	else
		fprintf(op3, "(%s,%s,%s)\n", op , b1 , b2); //triples
}
int yyerror(char *msg)
{
printf("YACC error: %s\n",msg);
exit(1);
}

int yywrap() {
	return 1;
}
