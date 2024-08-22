%{
	#include "y.tab.h"
	extern int yylval;
%}
%%
"for" return FOR;
"int"|"float"|"double"|"bool" return TYPE;
">"|"<"|">="|"<="|"=="|"!=" return OP;
[a-zA-Z] {yylval = yytext[0];return IDEN;}
[0-9]+ {yylval = atoi(yytext); return NUM;}
[\t ]  ;
\n  return 0;
.   return yytext[0];
%%
