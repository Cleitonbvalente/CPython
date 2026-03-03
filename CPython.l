%{
#include <stdio.h>
%}

DIGITO      [0-9]
LETRA       [a-zA-Z_]
ID          {LETRA}({LETRA}|{DIGITO})*
NUM_INT     {DIGITO}+
NUM_REAL    {DIGITO}+"."{DIGITO}+

%%

"#".*                  { printf("COMENTARIO_LINHA\n"); }

"se"                   { printf("SE\n"); }
"senao"                { printf("SENAO\n"); }
"enquanto"             { printf("ENQUANTO\n"); }
"funcao"               { printf("FUNCAO\n"); }
"retorne"              { printf("RETORNE\n"); }

"iniciofunc"           { printf("INICIO_FUNCAO\n"); }
"fimfunc"              { printf("FIM_FUNCAO\n"); }

"inteiro"              { printf("TIPO_INTEIRO\n"); }
"real"                 { printf("TIPO_REAL\n"); }
"double"               { printf("TIPO_DOUBLE\n"); }
"float"                { printf("TIPO_FLOAT\n"); }
"bool"                 { printf("TIPO_BOOL\n"); }
"string"               { printf("TIPO_STRING\n"); }

"leia"                 { printf("LEIA\n"); }
"escreva"              { printf("ESCREVA\n"); }

"=="                   { printf("OP_IGUAL\n"); }
"!="                   { printf("OP_DIFERENTE\n"); }
">="                   { printf("OP_MAIOR_IGUAL\n"); }
"<="                   { printf("OP_MENOR_IGUAL\n"); }
">"                    { printf("OP_MAIOR\n"); }
"<"                    { printf("OP_MENOR\n"); }

"&&"                   { printf("OP_E_LOGICO\n"); }
"||"                   { printf("OP_OU_LOGICO\n"); }
"!"                    { printf("OP_NEGACAO\n"); }

"="                    { printf("OP_ATRIBUICAO\n"); }
"+"                    { printf("OP_SOMA\n"); }
"-"                    { printf("OP_SUBTRACAO\n"); }
"*"                    { printf("OP_MULTIPLICACAO\n"); }
"/"                    { printf("OP_DIVISAO\n"); }

"("                    { printf("ABRE_PARENTESE\n"); }
")"                    { printf("FECHA_PARENTESE\n"); }
":"                    { printf("DOIS_PONTOS\n"); }
","                    { printf("VIRGULA\n"); }

\"([^\"\n]*)\"         { printf("STRING\n"); }

{NUM_REAL}             { printf("NUM_REAL\n"); }
{NUM_INT}              { printf("NUM_INT\n"); }

{ID}                   { printf("IDENTIFICADOR\n"); }

[ \t\r\n]+             { }

.                      { printf("ERRO: %s\n", yytext); }

%%

int main() {
    yylex();
    return 0;
}
