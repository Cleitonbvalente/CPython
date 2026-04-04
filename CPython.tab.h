/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_CPYTHON_TAB_H_INCLUDED
# define YY_YY_CPYTHON_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    SE = 258,                      /* SE  */
    SENAO = 259,                   /* SENAO  */
    ENQUANTO = 260,                /* ENQUANTO  */
    FUNCAO = 261,                  /* FUNCAO  */
    RETORNE = 262,                 /* RETORNE  */
    INICIO_FUNCAO = 263,           /* INICIO_FUNCAO  */
    FIM_FUNCAO = 264,              /* FIM_FUNCAO  */
    TIPO_INTEIRO = 265,            /* TIPO_INTEIRO  */
    TIPO_REAL = 266,               /* TIPO_REAL  */
    ESCREVA = 267,                 /* ESCREVA  */
    OP_IGUAL = 268,                /* OP_IGUAL  */
    OP_DIFERENTE = 269,            /* OP_DIFERENTE  */
    OP_MAIOR = 270,                /* OP_MAIOR  */
    OP_MENOR = 271,                /* OP_MENOR  */
    OP_MAIOR_IGUAL = 272,          /* OP_MAIOR_IGUAL  */
    OP_MENOR_IGUAL = 273,          /* OP_MENOR_IGUAL  */
    OP_ATRIBUICAO = 274,           /* OP_ATRIBUICAO  */
    OP_SOMA = 275,                 /* OP_SOMA  */
    OP_SUBTRACAO = 276,            /* OP_SUBTRACAO  */
    OP_MULTIPLICACAO = 277,        /* OP_MULTIPLICACAO  */
    OP_DIVISAO = 278,              /* OP_DIVISAO  */
    OP_POTENCIA = 279,             /* OP_POTENCIA  */
    ABRE_PARENTESE = 280,          /* ABRE_PARENTESE  */
    FECHA_PARENTESE = 281,         /* FECHA_PARENTESE  */
    DOIS_PONTOS = 282,             /* DOIS_PONTOS  */
    VIRGULA = 283,                 /* VIRGULA  */
    SQRT = 284,                    /* SQRT  */
    FAT = 285,                     /* FAT  */
    NUM_INT = 286,                 /* NUM_INT  */
    NUM_REAL = 287,                /* NUM_REAL  */
    IDENTIFICADOR = 288            /* IDENTIFICADOR  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 17 "CPython.y"

    float flo;

#line 101 "CPython.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_CPYTHON_TAB_H_INCLUDED  */
