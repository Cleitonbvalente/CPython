%{
#include "CPython.tab.h"
#include <stdlib.h>
%}

DIGITO      [0-9]
LETRA       [a-zA-Z_]
ID          {LETRA}({LETRA}|{DIGITO})*
NUM_INT     {DIGITO}+
NUM_REAL    {DIGITO}+"."{DIGITO}+

%%

"#".*                  { }

"se"                   { return SE; }
"senao"                { return SENAO; }
"enquanto"             { return ENQUANTO; }
"funcao"               { return FUNCAO; }
"retorne"              { return RETORNE; }

"iniciofunc"           { return INICIO_FUNCAO; }
"fimfunc"              { return FIM_FUNCAO; }

"inteiro"              { return TIPO_INTEIRO; }
"real"                 { return TIPO_REAL; }

"escreva"              { return ESCREVA; }

"=="                   { return OP_IGUAL; }
"!="                   { return OP_DIFERENTE; }
">="                   { return OP_MAIOR_IGUAL; }
"<="                   { return OP_MENOR_IGUAL; }
">"                    { return OP_MAIOR; }
"<"                    { return OP_MENOR; }

"="                    { return OP_ATRIBUICAO; }
"+"                    { return OP_SOMA; }
"-"                    { return OP_SUBTRACAO; }
"*"                    { return OP_MULTIPLICACAO; }
"/"                    { return OP_DIVISAO; }

"("                    { return ABRE_PARENTESE; }
")"                    { return FECHA_PARENTESE; }
":"                    { return DOIS_PONTOS; }
","                    { return VIRGULA; }

{NUM_REAL}             { yylval.flo = atof(yytext); return NUM_REAL; }
{NUM_INT}              { yylval.flo = atof(yytext); return NUM_INT; }

{ID}                   { return IDENTIFICADOR; }

[ \t\r\n]+             { }

. { printf("Erro lexico: %s\n", yytext); }

%%
