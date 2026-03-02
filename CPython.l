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

"inteiro"              { printf("TIPO_INTEIRO\n"); }
"real"                 { printf("TIPO_REAL\n"); }
"double"               { printf("TIPO_DOUBLE\n"); }
"float"                { printf("TIPO_FLOAT\n"); }
"bool"                 { printf("TIPO_BOOL\n"); }
"string"               { printf("TIPO_STRING\n"); }

"leia"                 { printf("LEIA\n"); }
"escreva"              { printf("ESCREVA\n"); }

"=="                   { printf("==\n"); }
"!="                   { printf("!=\n"); }
">="                   { printf(">=\n"); }
"<="                   { printf("<=\n"); }
">"                    { printf(">\n"); }
"<"                    { printf("<\n"); }
"&&"                   { printf("&&\n"); }
"||"                   { printf("||\n"); }
"!"                    { printf("!\n"); }

"="                    { printf("=\n"); }
"+"                    { printf("+\n"); }
"-"                    { printf("-\n"); }
"*"                    { printf("*\n"); }
"/"                    { printf("/\n"); }

"("                    { printf("(\n"); }
")"                    { printf(")\n"); }
"{"                    { printf("{\n"); }
"}"                    { printf("}\n"); }
"["                    { printf("[\n"); }
"]"                    { printf("]\n"); }
":"                    { printf(":\n"); }
","                    { printf(",\n"); }
";"                    { printf(";\n"); }

\"([^\"\n]*)\"         { printf("STRING\n"); }

{NUM_REAL}             { printf("NUM_REAL\n"); }
{NUM_INT}              { printf("NUM_INT\n"); }

{ID}                   { printf("IDENTIFICADOR\n"); }

[ \t\r\n]+             { /* ignora espaços */ }

.                      { printf("ERRO: %s\n", yytext); }

%%

int main() {
    yylex();
    return 0;
}
