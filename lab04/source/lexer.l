%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

//Define the tokens that you want to return from your lex as follows
#define ID 256
#define INTVAL 257
#define PREPROC 258
#define DBLVAL 259
#define CHARVAL 260
#define FLTVAL 261
#define STRVAL 262
#define VOID 263
#define SHORT 264
#define LONG 265
#define DOUBLE 266
#define CHAR 267
#define INT 268
#define FLOAT 269
#define EQ 270
#define LE 271
#define ADD 272
#define DIV 273
#define AND 274
#define BITXOR 275
#define LSH 276
#define SETADD 277
#define SETDIV 278
#define SETAND 279
#define SETRSH 280
#define NE 281
#define GT 282
#define SUB 283
#define MOD 284
#define BITOR 285
#define NOT 286
#define RSH 287
#define SETSUB 288
#define SETMOD 289
#define SETXOR 290
#define GE 291
#define LT 292
#define MUL 293
#define OR 294
#define BITAND 295
#define COM 296
#define SET 297
#define SETMUL 298
#define SETOR 299
#define SETLSH 300
#define RETURN 301
#define WHILE 302
#define SWITCH 303
#define DEFAULT 304
#define ELSE 305
#define BREAK 306
#define DO 307
#define FOR 308
#define CASE 309
#define IF 310
#define CONTINUE 311
#define GOTO 312
#define UNSIGNED 313
#define STRUCT 314
#define CONST 315
#define EXTERN 316
#define REGISTER 317
#define TYPEDEF 318
#define UNION 319
#define STATIC 320
#define AUTO 321
#define SIZEOF 322

int list_type;
%}

%option noyywrap nounput yylineno
PREPROC ^"#".*
ID [a-zA-Z][a-zA-Z0-9_]*
INTVAL [a-fA-F0-9]*
DBLVAL [0-9]*"."[0-9]*
CHARVAL "\'"(.|"\\".)"\'"
FLTVAL [0-9]*"."[0-9]*"f"
STRVAL "\""[^\"]*"\""
%x COMMENT MULTI

%%
"//" {
    /****************************************
    * Matching with Single line comments in our
    * C code
    ******************************************/
    BEGIN COMMENT;
}

"/*" {
    /* Multiline comment */
    BEGIN MULTI;
}

<COMMENT>[\n](\r)? {
    /****************************************
    * A new line indicates end of a single
    * line comment in C
    ****************************************/

    BEGIN 0;
}

<COMMENT>[ \t] {
    /****************************************
    * Lexer ignores the comments section
    * by Ignoring anything inside a comment
    ****************************************/
}

<MULTI>"*/" {
    BEGIN 0;
}

<COMMENT,MULTI>. {
}

{PREPROC} {
    printf("PREPROC\n");
    return PREPROC;
}

"(" {
    printf("(\n");
    return '(';
}

")" {
    printf(")\n");
    return ')';
}

" {" {
    printf("{\n");
    return '{';
}

"}" {
    printf("}\n");
    return '}';
}

"[" {
    printf("[\n");
    return '[';
}

"]" {
    printf("]\n");
    return ']';
}

"," {
    printf(",\n");
    return ',';
}

";" {
    printf(";\n");
    return ';';
}

"void" {
    printf("VOID\n");
    return VOID;
}

"short" {
    printf("SHORT\n");
    return SHORT;
}

"long" {
    printf("LONG\n");
    return LONG;
}

"double" {
    printf("DOUBLE\n");
    return DOUBLE;
}

"char" {
    printf("CHAR\n");
    return CHAR;
}

"int" {
    printf("INT\n");
    return INT;
}

"float" {
    printf("FLOAT\n");
    return FLOAT;
}


"==" {
    printf("EQ\n");
    return EQ;
}

"<=" {
    printf("LE\n");
    return LE;
}

"+" {
    printf("ADD\n");
    return ADD;
}

"/" {
    printf("DIV\n");
    return DIV;
}

"&&" {
    printf("AND\n");
    return AND;
}

"^" {
    printf("BITXOR\n");
    return BITXOR;
}

"<<" {
    printf("LSH\n");
    return LSH;
}

"+=" {
    printf("SETADD\n");
    return SETADD;
}

"/=" {
    printf("SETDIV\n");
    return SETDIV;
}

"&=" {
    printf("SETAND\n");
    return SETAND;
}

">>=" {
    printf("\n");
    return SETRSH;
}

"!=" {
    printf("NE\n");
    return NE;
}

">" {
    printf("GT\n");
    return GT;
}

"-" {
    printf("SUB\n");
    return SUB;
}

"%" {
    printf("MOD\n");
    return MOD;
}

"|" {
    printf("BITOR\n");
    return BITOR;
}

"!" {
    printf("NOT\n");
    return NOT;
}

">>" {
    printf("RSH\n");
    return RSH;
}

"-=" {
    printf("SETSUB\n");
    return SETSUB;
}

"%=" {
    printf("SETMOD\n");
    return SETMOD;
}

"^=" {
    printf("SETXOR\n");
    return SETXOR;
}

">=" {
    printf("GE\n");
    return GE;
}

"<" {
    printf("LT\n");
    return LT;
}

"*" {
    printf("MUL\n");
    return MUL;
}

"||" {
    printf("OR\n");
    return OR;
}

"&" {
    printf("BITAND\n");
    return BITAND;
}

"~" {
    printf("COM\n");
    return COM;
}

"=" {
    printf("SET\n");
    return SET;
}

"*=" {
    printf("SETMUL\n");
    return SETMUL;
}

"|=" {
    printf("SETOR\n");
    return SETOR;
}

"<<=" {
    printf("SETLSH\n");
    return SETLSH;
}


"return" {
    printf("RETURN\n");
    return RETURN;
}

"while" {
    printf("WHILE\n");
    return WHILE;
}

"switch" {
    printf("SWITCH\n");
    return SWITCH;
}

"default" {
    printf("DEFAULT\n");
    return DEFAULT;
}

"else" {
    printf("ELSE\n");
    return ELSE;
}

"break" {
    printf("BREAK\n");
    return BREAK;
}

"do" {
    printf("DO\n");
    return DO;
}

"for" {
    printf("FOR\n");
    return FOR;
}

"case" {
    printf("CASE\n");
    return CASE;
}

"if" {
    printf("IF\n");
    return IF;
}

"continue" {
    printf("CONTINUE\n");
    return CONTINUE;
}

"goto" {
    printf("GOTO\n");
    return GOTO;
}


"unsigned" {
    printf("UNSIGNED\n");
    return UNSIGNED;
}

"struct" {
    printf("STRUCT\n");
    return STRUCT;
}

"const" {
    printf("CONST\n");
    return CONST;
}

"extern" {
    printf("EXTERN\n");
    return EXTERN;
}

"register" {
    printf("REGISTER\n");
    return REGISTER;
}

"typedef" {
    printf("TYPEDEF\n");
    return TYPEDEF;
}

"union" {
    printf("UNION\n");
    return UNION;
}

"static" {
    printf("STATIC\n");
    return STATIC;
}

"auto" {
    printf("AUTO\n");
    return AUTO;
}

"sizeof" {
    printf("SIZEOF\n");
    return SIZEOF;
}


{ID} {
    /**************************************
    * If an identifier is matched, then
    * print ID and return a token ID
    **************************************/

    printf("ID\n");
    return ID;
}

{INTVAL} {
    printf("INTVAL\n");
    return INTVAL;
}

{DBLVAL} {
    printf("DBLVAL\n");
    return DBLVAL;
}

{CHARVAL} {
    printf("CHARVAL\n");
    return CHARVAL;
}

{FLTVAL} {
    printf("FLTVAL\n");
    return FLTVAL;
}

{STRVAL} {
    printf("STRVAL\n");
    return STRVAL;
}

[ \t\n\r] {
    /* whitespace */
}

%%
int main(int argc, const char* argv[]) {
    /*Make a call to yylex() recursively. Whenever yylex() is called, it scans
    tokens from the global input file yyin (which defaults to stdin). It
    continues until it either reaches an end-of-file (at which point it returns
    the value 0) or one of its actions executes a return statement.*/
    while(yylex() != 0) {}

    return 0;
}
