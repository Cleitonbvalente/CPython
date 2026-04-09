%{
#include <stdio.h>
#include <math.h>

int yylex();

void yyerror(char *s){
    printf("Erro sintatico: %s\n", s);
}

int fatorial(int n){
    if(n <= 1) return 1;
    return n * fatorial(n - 1);
}
%}

%union{
    float flo;
}

%token SE SENAO ENQUANTO FUNCAO RETORNE
%token INICIO_FUNCAO FIM_FUNCAO
%token TIPO_INTEIRO TIPO_REAL
%token ESCREVA

%token OP_IGUAL OP_DIFERENTE OP_MAIOR OP_MENOR OP_MAIOR_IGUAL OP_MENOR_IGUAL
%token OP_ATRIBUICAO OP_SOMA OP_SUBTRACAO OP_MULTIPLICACAO OP_DIVISAO OP_POTENCIA

%token ABRE_PARENTESE FECHA_PARENTESE DOIS_PONTOS VIRGULA

%token SQRT FAT
%token <flo> NUM_INT NUM_REAL
%token IDENTIFICADOR

%left OP_SOMA OP_SUBTRACAO
%left OP_MULTIPLICACAO OP_DIVISAO
%right OP_POTENCIA

%type <flo> expressao termo fator

%%

programa:
    lista_funcoes
;

lista_funcoes:
    lista_funcoes funcao
    | funcao
;

funcao:
    FUNCAO IDENTIFICADOR ABRE_PARENTESE parametros FECHA_PARENTESE DOIS_PONTOS
    INICIO_FUNCAO lista_comandos FIM_FUNCAO
;

parametros:
    parametros VIRGULA IDENTIFICADOR
    | IDENTIFICADOR
    |
;

lista_comandos:
    lista_comandos comando
    | comando
;

comando:
      atribuicao
    | escrita
;

atribuicao:
    IDENTIFICADOR OP_ATRIBUICAO expressao {
        printf("Resultado da expressao: %.2f\n", $3);
    }
;

expressao:
      expressao OP_SOMA termo {
          $$ = $1 + $3;
          printf("%.2f + %.2f = %.2f\n", $1, $3, $$);
      }
    | expressao OP_SUBTRACAO termo {
          $$ = $1 - $3;
          printf("%.2f - %.2f = %.2f\n", $1, $3, $$);
      }
    | termo { $$ = $1; }
;

termo:
      termo OP_MULTIPLICACAO fator {
          $$ = $1 * $3;
          printf("%.2f * %.2f = %.2f\n", $1, $3, $$);
      }
    | termo OP_DIVISAO fator {
          $$ = $1 / $3;
          printf("%.2f / %.2f = %.2f\n", $1, $3, $$);
      }
    | fator { $$ = $1; }
;

fator:
      fator OP_POTENCIA fator {
          $$ = pow($1, $3);
          printf("%.2f ^ %.2f = %.2f\n", $1, $3, $$);
      }
    | NUM_INT { $$ = $1; }
    | NUM_REAL { $$ = $1; }
    | ABRE_PARENTESE expressao FECHA_PARENTESE { $$ = $2; }
    | SQRT ABRE_PARENTESE expressao FECHA_PARENTESE {
        $$ = sqrt($3);
        printf("sqrt(%.2f) = %.2f\n", $3, $$);
      }
    | FAT ABRE_PARENTESE expressao FECHA_PARENTESE {
        $$ = fatorial((int)$3);
        printf("fat(%.2f) = %.2f\n", $3, $$);
      }
;

escrita:
    ESCREVA ABRE_PARENTESE expressao FECHA_PARENTESE {
        printf("Saida: %.2f\n", $3);
    }
;

%%

#include "lex.yy.c"

int main(){
    yyin = fopen("teste.txt", "r");
    yyparse();
    fclose(yyin);
    return 0;
}
