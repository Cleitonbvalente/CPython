%{
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <math.h>

extern FILE *yyin;
extern int linha_atual;

typedef enum {
    TIPO_INTEIRO_VAR,
    TIPO_REAL_VAR,
    TIPO_CARACTERE_VAR,
    TIPO_FUNCAO,
    TIPO_NAO_DECLARADO
} TipoSimbolo;

typedef struct Simbolo {
    char nome[100];
    TipoSimbolo tipo;
    int declarado;
    struct Simbolo* prox;
} Simbolo;

Simbolo* escopo_atual = NULL;

typedef struct EscopoNode {
    Simbolo* tabela;
    struct EscopoNode* anterior;
} EscopoNode;

EscopoNode* pilha_escopo = NULL;

FILE* out = NULL;
int tmp_count = 0;

char* novo_tmp() {
    char* buf = (char*)malloc(32);
    sprintf(buf, "_t%d", tmp_count++);
    return buf;
}

Simbolo* criar_simbolo(char* nome, TipoSimbolo tipo) {
    Simbolo* novo = (Simbolo*)malloc(sizeof(Simbolo));
    strcpy(novo->nome, nome);
    novo->tipo = tipo;
    novo->declarado = 1;
    novo->prox = NULL;
    return novo;
}

void inserir_simbolo(char* nome, TipoSimbolo tipo) {
    Simbolo* novo = criar_simbolo(nome, tipo);
    novo->prox = escopo_atual;
    escopo_atual = novo;
}

Simbolo* buscar_simbolo(char* nome) {
    Simbolo* atual = escopo_atual;
    while(atual != NULL) {
        if(strcmp(atual->nome, nome) == 0) return atual;
        atual = atual->prox;
    }
    return NULL;
}

Simbolo* buscar_no_escopo_atual(char* nome) {
    Simbolo* atual = escopo_atual;
    while(atual != NULL) {
        if(strcmp(atual->nome, nome) == 0) return atual;
        atual = atual->prox;
    }
    return NULL;
}

void push_escopo() {
    EscopoNode* novo = (EscopoNode*)malloc(sizeof(EscopoNode));
    novo->tabela = escopo_atual;
    novo->anterior = pilha_escopo;
    pilha_escopo = novo;
    escopo_atual = NULL;
}

void pop_escopo() {
    if(pilha_escopo != NULL) {
        Simbolo* atual = escopo_atual;
        while(atual != NULL) {
            Simbolo* temp = atual;
            atual = atual->prox;
            free(temp);
        }
        escopo_atual = pilha_escopo->tabela;
        EscopoNode* temp = pilha_escopo;
        pilha_escopo = pilha_escopo->anterior;
        free(temp);
    }
}

void verificar_ou_declarar_variavel(char* nome) {
    Simbolo* s = buscar_simbolo(nome);
    if(s == NULL) {
        inserir_simbolo(nome, TIPO_REAL_VAR);
        fprintf(out, "    double %s = 0;\n", nome);
    }
}

void verificar_redeclaracao(char* nome) {
    Simbolo* s = buscar_no_escopo_atual(nome);
    if(s != NULL) {
        printf("Erro Semântico (linha %d): Variável '%s' já foi declarada\n", linha_atual, nome);
        exit(1);
    }
}

int yylex();
void yyerror(char *s) {
    printf("Erro sintatico na linha %d: %s\n", linha_atual, s);
}

%}

%union {
    struct {
        char tmp[64];
        int  is_real;
    } expr;
    char str[200];
}

%token SE SENAO ENQUANTO FUNCAO RETORNE
%token INICIO_FUNCAO FIM_FUNCAO
%token TIPO_INTEIRO TIPO_REAL TIPO_CARACTERE
%token ESCREVA LEIA LEIA_CHAR
%token OP_IGUAL OP_DIFERENTE OP_MAIOR OP_MENOR OP_MAIOR_IGUAL OP_MENOR_IGUAL
%token OP_ATRIBUICAO OP_SOMA OP_SUBTRACAO OP_MULTIPLICACAO OP_DIVISAO OP_POTENCIA
%token ABRE_PARENTESE FECHA_PARENTESE DOIS_PONTOS VIRGULA
%token SQRT FAT

%token <expr> NUM_INT NUM_REAL
%token <str>  IDENTIFICADOR TEXTO

%type <expr> expressao termo fator
%type <str>  cabecalho_se cabecalho_funcao

%left OP_IGUAL OP_DIFERENTE OP_MAIOR OP_MENOR OP_MAIOR_IGUAL OP_MENOR_IGUAL
%left OP_SOMA OP_SUBTRACAO
%left OP_MULTIPLICACAO OP_DIVISAO
%right OP_POTENCIA

%start programa

%%

programa:
    lista_funcoes
;

lista_funcoes:
    lista_funcoes funcao
    | funcao
;

/* Separa o cabeçalho da função para emitir o código antes do corpo */
cabecalho_funcao:
    FUNCAO IDENTIFICADOR ABRE_PARENTESE parametros FECHA_PARENTESE DOIS_PONTOS
    {
        if(strcmp($2, "principal") == 0)
            fprintf(out, "int main() {\n");
        else
            fprintf(out, "void %s() {\n", $2);
        push_escopo();
        strcpy($$, $2);
    }
;

funcao:
    cabecalho_funcao INICIO_FUNCAO lista_comandos FIM_FUNCAO
    {
        if(strcmp($1, "principal") == 0)
            fprintf(out, "    return 0;\n");
        fprintf(out, "}\n\n");
        pop_escopo();
    }
;

parametros:
    parametros VIRGULA IDENTIFICADOR
    {
        verificar_redeclaracao($3);
        inserir_simbolo($3, TIPO_REAL_VAR);
    }
    | IDENTIFICADOR
    {
        verificar_redeclaracao($1);
        inserir_simbolo($1, TIPO_REAL_VAR);
    }
    | /* vazio */
;

lista_comandos:
    lista_comandos comando
    | comando
;

comando:
      atribuicao
    | declaracao_variavel
    | escrita
    | leitura
    | leitura_char
    | condicao
    | loop
;

declaracao_variavel:
    TIPO_INTEIRO IDENTIFICADOR
    {
        verificar_redeclaracao($2);
        inserir_simbolo($2, TIPO_INTEIRO_VAR);
        fprintf(out, "    int %s = 0;\n", $2);
    }
    | TIPO_REAL IDENTIFICADOR
    {
        verificar_redeclaracao($2);
        inserir_simbolo($2, TIPO_REAL_VAR);
        fprintf(out, "    double %s = 0.0;\n", $2);
    }
    | TIPO_CARACTERE IDENTIFICADOR
    {
        verificar_redeclaracao($2);
        inserir_simbolo($2, TIPO_CARACTERE_VAR);
        fprintf(out, "    char %s = '\\0';\n", $2);
    }
;

atribuicao:
    IDENTIFICADOR OP_ATRIBUICAO expressao
    {
        verificar_ou_declarar_variavel($1);
        fprintf(out, "    %s = %s;\n", $1, $3.tmp);
    }
;

leitura:
    LEIA ABRE_PARENTESE IDENTIFICADOR FECHA_PARENTESE
    {
        verificar_ou_declarar_variavel($3);
        Simbolo* s = buscar_simbolo($3);
        if(s != NULL && s->tipo == TIPO_INTEIRO_VAR)
            fprintf(out, "    scanf(\"%%d\", &%s);\n", $3);
        else
            fprintf(out, "    scanf(\"%%lf\", &%s);\n", $3);
    }
;

leitura_char:
    LEIA_CHAR ABRE_PARENTESE IDENTIFICADOR FECHA_PARENTESE
    {
        verificar_ou_declarar_variavel($3);
        Simbolo* s = buscar_simbolo($3);
        if(s != NULL) s->tipo = TIPO_CARACTERE_VAR;
        fprintf(out, "    scanf(\" %%c\", &%s);\n", $3);
    }
;

/* ============================================================
   CONDICAO sem conflito:

   Regras separadas para cada "cabeçalho" resolvem os conflitos
   de mid-rule actions com prefixos idênticos.

   cabecalho_se        → emite:  if(cond) {
   cabecalho_else_bloco→ emite:  } else {

   bloco_senao decide pelo lookahead após FIM_FUNCAO:
     vazio → fecha o if com }
     SENAO INICIO_FUNCAO → abre else { ... }
     SENAO SE ... → encadeia else if
   ============================================================ */

/* ============================================================
   CONDICAO:
   cabecalho_se é uma regra separada — emite "if(cond) {"
   antes de entrar nos comandos, sem conflito de mid-rule.

   Para "senao se", geramos "} else {" e depois aninhamos
   uma condicao normal dentro. Os temporários da condição
   do else-if ficam DENTRO do bloco else, evitando o erro
   de variável não declarada no C gerado.
   ============================================================ */

cabecalho_se:
    SE ABRE_PARENTESE expressao FECHA_PARENTESE INICIO_FUNCAO
    {
        fprintf(out, "    if(%s) {\n", $3.tmp);
        strcpy($$, $3.tmp);
    }
;

condicao:
    cabecalho_se lista_comandos FIM_FUNCAO bloco_senao
;

bloco_senao:
    /* vazio - fecha o if */
    {
        fprintf(out, "    }\n");
    }
    | SENAO INICIO_FUNCAO
    {
        fprintf(out, "    } else {\n");
    }
    lista_comandos FIM_FUNCAO
    {
        fprintf(out, "    }\n");
    }
    | SENAO
    {
        /* Abre o bloco else antes de parsear o "se" encadeado.
           Os temporários da condição serão emitidos DENTRO deste bloco. */
        fprintf(out, "    } else {\n");
    }
    condicao
    {
        fprintf(out, "    }\n");
    }
;

/* ============================================================
   LOOP sem mid-rule action problemática:
   loop gera while(1) { if(!cond) break; ... }
   ============================================================ */

/* Para o while funcionar corretamente, a condição precisa ser
   reavaliada a cada iteração. Usamos while(1) + break.
   Os temporários da condição são emitidos dentro do loop. */

loop:
    ENQUANTO ABRE_PARENTESE
    {
        /* Abre o while(1) antes de parsear a condição,
           para que os temporários sejam emitidos dentro do loop */
        fprintf(out, "    while(1) {\n");
    }
    expressao FECHA_PARENTESE
    {
        /* Após calcular a condição, verifica e quebra se falsa */
        fprintf(out, "    if(!(%s)) break;\n", $4.tmp);
    }
    INICIO_FUNCAO lista_comandos FIM_FUNCAO
    {
        fprintf(out, "    }\n");
    }
;

/* ============================================================
   EXPRESSÕES - propaga is_real
   ============================================================ */

expressao:
      expressao OP_SOMA termo
        {
            char* t = novo_tmp();
            fprintf(out, "    double %s = %s + %s;\n", t, $1.tmp, $3.tmp);
            strcpy($$.tmp, t); free(t);
            $$.is_real = $1.is_real || $3.is_real;
        }
    | expressao OP_SUBTRACAO termo
        {
            char* t = novo_tmp();
            fprintf(out, "    double %s = %s - %s;\n", t, $1.tmp, $3.tmp);
            strcpy($$.tmp, t); free(t);
            $$.is_real = $1.is_real || $3.is_real;
        }
    | expressao OP_IGUAL termo
        {
            char* t = novo_tmp();
            fprintf(out, "    int %s = (%s == %s);\n", t, $1.tmp, $3.tmp);
            strcpy($$.tmp, t); free(t);
            $$.is_real = 0;
        }
    | expressao OP_DIFERENTE termo
        {
            char* t = novo_tmp();
            fprintf(out, "    int %s = (%s != %s);\n", t, $1.tmp, $3.tmp);
            strcpy($$.tmp, t); free(t);
            $$.is_real = 0;
        }
    | expressao OP_MAIOR termo
        {
            char* t = novo_tmp();
            fprintf(out, "    int %s = (%s > %s);\n", t, $1.tmp, $3.tmp);
            strcpy($$.tmp, t); free(t);
            $$.is_real = 0;
        }
    | expressao OP_MENOR termo
        {
            char* t = novo_tmp();
            fprintf(out, "    int %s = (%s < %s);\n", t, $1.tmp, $3.tmp);
            strcpy($$.tmp, t); free(t);
            $$.is_real = 0;
        }
    | expressao OP_MAIOR_IGUAL termo
        {
            char* t = novo_tmp();
            fprintf(out, "    int %s = (%s >= %s);\n", t, $1.tmp, $3.tmp);
            strcpy($$.tmp, t); free(t);
            $$.is_real = 0;
        }
    | expressao OP_MENOR_IGUAL termo
        {
            char* t = novo_tmp();
            fprintf(out, "    int %s = (%s <= %s);\n", t, $1.tmp, $3.tmp);
            strcpy($$.tmp, t); free(t);
            $$.is_real = 0;
        }
    | termo
        { $$ = $1; }
;

termo:
      termo OP_MULTIPLICACAO fator
        {
            char* t = novo_tmp();
            fprintf(out, "    double %s = %s * %s;\n", t, $1.tmp, $3.tmp);
            strcpy($$.tmp, t); free(t);
            $$.is_real = $1.is_real || $3.is_real;
        }
    | termo OP_DIVISAO fator
        {
            char* t = novo_tmp();
            fprintf(out, "    double %s = (%s == 0) ? 0 : (double)%s / (double)%s;\n",
                    t, $3.tmp, $1.tmp, $3.tmp);
            strcpy($$.tmp, t); free(t);
            $$.is_real = 1;
        }
    | fator
        { $$ = $1; }
;

fator:
      fator OP_POTENCIA fator
        {
            char* t = novo_tmp();
            fprintf(out, "    double %s = pow(%s, %s);\n", t, $1.tmp, $3.tmp);
            strcpy($$.tmp, t); free(t);
            $$.is_real = 1;
        }
    | NUM_INT
        {
            char* t = novo_tmp();
            fprintf(out, "    double %s = %s;\n", t, $1.tmp);
            strcpy($$.tmp, t); free(t);
            $$.is_real = 0;
        }
    | NUM_REAL
        {
            char* t = novo_tmp();
            fprintf(out, "    double %s = %s;\n", t, $1.tmp);
            strcpy($$.tmp, t); free(t);
            $$.is_real = 1;
        }
    | ABRE_PARENTESE expressao FECHA_PARENTESE
        { $$ = $2; }
    | SQRT ABRE_PARENTESE expressao FECHA_PARENTESE
        {
            char* t = novo_tmp();
            fprintf(out, "    double %s = sqrt(%s);\n", t, $3.tmp);
            strcpy($$.tmp, t); free(t);
            $$.is_real = 1;
        }
    | FAT ABRE_PARENTESE expressao FECHA_PARENTESE
        {
            char* t = novo_tmp();
            fprintf(out, "    double %s = _fat((int)%s);\n", t, $3.tmp);
            strcpy($$.tmp, t); free(t);
            $$.is_real = 0;
        }
    | IDENTIFICADOR
        {
            verificar_ou_declarar_variavel($1);
            Simbolo* s = buscar_simbolo($1);
            strcpy($$.tmp, $1);
            $$.is_real = (s != NULL && s->tipo == TIPO_REAL_VAR) ? 1 : 0;
        }
;

/* ============================================================
   ESCRITA
   ============================================================ */

escrita:
    ESCREVA ABRE_PARENTESE lista_argumentos_escrita FECHA_PARENTESE
    {
        fprintf(out, "    printf(\"\\n\");\n");
    }
;

lista_argumentos_escrita:
    lista_argumentos_escrita VIRGULA argumento_escrita
    | argumento_escrita
;

argumento_escrita:
    TEXTO
    {
        fprintf(out, "    printf(\"%%s\", \"%s\");\n", $1);
    }
    | expressao
    {
        if($1.is_real)
            fprintf(out, "    printf(\"%%.2f\", (double)%s);\n", $1.tmp);
        else
            fprintf(out, "    printf(\"%%.0f\", (double)%s);\n", $1.tmp);
    }
;

%%

int main(int argc, char *argv[]) {
    if(argc < 2) {
        printf("Uso: %s <fonte.txt> [entrada.txt]\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if(yyin == NULL) {
        printf("Erro: Não foi possível abrir %s\n", argv[1]);
        return 1;
    }

    out = fopen("_saida.c", "w");
    if(out == NULL) {
        printf("Erro: Não foi possível criar _saida.c\n");
        return 1;
    }

    fprintf(out, "#include <stdio.h>\n");
    fprintf(out, "#include <math.h>\n\n");
    fprintf(out, "int _fat(int n) { return n <= 1 ? 1 : n * _fat(n-1); }\n\n");

    escopo_atual = NULL;
    pilha_escopo = NULL;

    yyparse();

    fclose(yyin);
    fclose(out);

    if(system("gcc _saida.c -o _prog -lm") != 0) {
        printf("Erro: falha ao compilar código gerado\n");
        return 1;
    }

    char cmd[512];
    if(argc >= 3)
        snprintf(cmd, sizeof(cmd), "./_prog < %s", argv[2]);
    else
        snprintf(cmd, sizeof(cmd), "./_prog");
    system(cmd);

    return 0;
}
