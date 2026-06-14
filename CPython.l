%{
#include "CPython.tab.h"
#include <stdlib.h>
#include <string.h>

int linha_atual = 1;
%}

DIGITO      [0-9]
LETRA       [a-zA-Z_]
ID          {LETRA}({LETRA}|{DIGITO})*
NUM_INT     {DIGITO}+
NUM_REAL    {DIGITO}+"."{DIGITO}+
TEXTO       "\""[^\"]*"\""
CARACTERE   "'"[^"'\n]"'"

%option noyywrap

%%

"#".*       { /* ignora comentários */ }

"se"                   { return SE; }
"senao"                { return SENAO; }
"enquanto"             { return ENQUANTO; }
"funcao"               { return FUNCAO; }
"retorne"              { return RETORNE; }

"iniciofunc"           { return INICIO_FUNCAO; }
"fimfunc"              { return FIM_FUNCAO; }

"inteiro"              { return TIPO_INTEIRO; }
"real"                 { return TIPO_REAL; }
"caractere"            { return TIPO_CARACTERE; }

"escreva"              { return ESCREVA; }
"leia"                 { return LEIA; }
"leia_char"            { return LEIA_CHAR; }

"sqrt"                 { return SQRT; }
"fat"                  { return FAT; }

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
"^"                    { return OP_POTENCIA; }

"("                    { return ABRE_PARENTESE; }
")"                    { return FECHA_PARENTESE; }
":"                    { return DOIS_PONTOS; }
","                    { return VIRGULA; }

{NUM_REAL}             {
                           strcpy(yylval.expr.tmp, yytext);
                           yylval.expr.is_real = 1;
                           return NUM_REAL;
                       }

{NUM_INT}              {
                           strcpy(yylval.expr.tmp, yytext);
                           yylval.expr.is_real = 0;
                           return NUM_INT;
                       }

{CARACTERE}            {
                           /* 'X' → valor ASCII como inteiro */
                           sprintf(yylval.expr.tmp, "%d", (int)yytext[1]);
                           yylval.expr.is_real = 0;
                           return NUM_INT;
                       }

{TEXTO}                {
                           yytext[strlen(yytext)-1] = '\0';
                           strcpy(yylval.str, yytext+1);
                           return TEXTO;
                       }

{ID}                   { strcpy(yylval.str, yytext); return IDENTIFICADOR; }

[ \t\r]+               { }
"\n"                   { linha_atual++; }

.                      { printf("Erro lexico na linha %d: %s\n", linha_atual, yytext); }

%%
