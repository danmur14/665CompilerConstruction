%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <fcg.yacc.h>

#ifndef NDEBUG
#    define DEBUGF(...) DEBUGF(__VA_ARGS__)
#else
#    define DEBUGF(...)
#endif
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

<MULTI>. {
}

<MULTI>[ \t\n\r] {
}

<COMMENT>. {
}


{PREPROC} {
    DEBUGF("PREPROC\n");
    return PREPROC;
}

"(" {
    DEBUGF("(\n");
    return '(';
}

")" {
    DEBUGF(")\n");
    return ')';
}

"{" {
    DEBUGF("{\n");
    return '{';
}

"}" {
    DEBUGF("}\n");
    return '}';
}

"[" {
    DEBUGF("[\n");
    return '[';
}

"]" {
    DEBUGF("]\n");
    return ']';
}

"," {
    DEBUGF(",\n");
    return ',';
}

";" {
    DEBUGF(";\n");
    return ';';
}

%{ 
 /**************************************************************************
  * Scan C identifiers.
  *************************************************************************/
%}

"void" {
    DEBUGF("VOID\n");
    return VOID;
}

"short" {
    DEBUGF("SHORT\n");
    return SHORT;
}

"long" {
    DEBUGF("LONG\n");
    return LONG;
}

"double" {
    DEBUGF("DOUBLE\n");
    return DOUBLE;
}

"char" {
    DEBUGF("CHAR\n");
    return CHAR;
}

"int" {
    DEBUGF("INT\n");
    return INT;
}

"float" {
    DEBUGF("FLOAT\n");
    return FLOAT;
}

"==" {
    DEBUGF("EQ\n");
    return EQ;
}

"<=" {
    DEBUGF("LE\n");
    return LE;
}

"+" {
    DEBUGF("ADD\n");
    return ADD;
}

"/" {
    DEBUGF("DIV\n");
    return DIV;
}

"&&" {
    DEBUGF("AND\n");
    return AND;
}

"^" {
    DEBUGF("BITXOR\n");
    return BITXOR;
}

"<<" {
    DEBUGF("LSH\n");
    return LSH;
}

"+=" {
    DEBUGF("SETADD\n");
    return SETADD;
}

"/=" {
    DEBUGF("SETDIV\n");
    return SETDIV;
}

"&=" {
    DEBUGF("SETAND\n");
    return SETAND;
}

">>=" {
    DEBUGF("\n");
    return SETRSH;
}

"!=" {
    DEBUGF("NE\n");
    return NE;
}

">" {
    DEBUGF("GT\n");
    return GT;
}

"-" {
    DEBUGF("SUB\n");
    return SUB;
}

"%" {
    DEBUGF("MOD\n");
    return MOD;
}

"|" {
    DEBUGF("BITOR\n");
    return BITOR;
}

"!" {
    DEBUGF("NOT\n");
    return NOT;
}

">>" {
    DEBUGF("RSH\n");
    return RSH;
}

"-=" {
    DEBUGF("SETSUB\n");
    return SETSUB;
}

"%=" {
    DEBUGF("SETMOD\n");
    return SETMOD;
}

"^=" {
    DEBUGF("SETXOR\n");
    return SETXOR;
}

">=" {
    DEBUGF("GE\n");
    return GE;
}

"<" {
    DEBUGF("LT\n");
    return LT;
}

"*" {
    DEBUGF("MUL\n");
    return MUL;
}

"||" {
    DEBUGF("OR\n");
    return OR;
}

"&" {
    DEBUGF("BITAND\n");
    return BITAND;
}

"~" {
    DEBUGF("COM\n");
    return COM;
}

"=" {
    DEBUGF("SET\n");
    return SET;
}

"*=" {
    DEBUGF("SETMUL\n");
    return SETMUL;
}

"|=" {
    DEBUGF("SETOR\n");
    return SETOR;
}

"<<=" {
    DEBUGF("SETLSH\n");
    return SETLSH;
}


"return" {
    DEBUGF("RETURN\n");
    return RETURN;
}

"while" {
    DEBUGF("WHILE\n");
    return WHILE;
}

"switch" {
    DEBUGF("SWITCH\n");
    return SWITCH;
}

"default" {
    DEBUGF("DEFAULT\n");
    return DEFAULT;
}

"else" {
    DEBUGF("ELSE\n");
    return ELSE;
}

"break" {
    DEBUGF("BREAK\n");
    return BREAK;
}

"do" {
    DEBUGF("DO\n");
    return DO;
}

"for" {
    DEBUGF("FOR\n");
    return FOR;
}

"case" {
    DEBUGF("CASE\n");
    return CASE;
}

"if" {
    DEBUGF("IF\n");
    return IF;
}

"continue" {
    DEBUGF("CONTINUE\n");
    return CONTINUE;
}

"goto" {
    DEBUGF("GOTO\n");
    return GOTO;
}


"unsigned" {
    DEBUGF("UNSIGNED\n");
    return UNSIGNED;
}

"struct" {
    DEBUGF("STRUCT\n");
    return STRUCT;
}

"const" {
    DEBUGF("CONST\n");
    return CONST;
}

"extern" {
    DEBUGF("EXTERN\n");
    return EXTERN;
}

"register" {
    DEBUGF("REGISTER\n");
    return REGISTER;
}

"typedef" {
    DEBUGF("TYPEDEF\n");
    return TYPEDEF;
}

"union" {
    DEBUGF("UNION\n");
    return UNION;
}

"static" {
    DEBUGF("STATIC\n");
    return STATIC;
}

"auto" {
    DEBUGF("AUTO\n");
    return AUTO;
}

"sizeof" {
    DEBUGF("SIZEOF\n");
    return SIZEOF;
}

{ID} {
    /**************************************
    * If an identifier is matched, then
    * print ID and return a token ID
    **************************************/

    DEBUGF( "ID\n" ); 
    yylval.id = strdup(yytext);
    return ID;
}

{INTVAL} {
    DEBUGF("INTVAL\n");
    return INTVAL;
}

{DBLVAL} {
    DEBUGF("DBLVAL\n");
    return DBLVAL;
}

{CHARVAL} {
    DEBUGF("CHARVAL\n");
    return CHARVAL;
}

{FLTVAL} {
    DEBUGF("FLTVAL\n");
    return FLTVAL;
}

{STRVAL} {
    DEBUGF("STRVAL\n");
    return STRVAL;
}

[ \t\n\r] {}

%{
 /**************************************************************************
  * Anything else that matches is unexpected so print an error.
  *************************************************************************/
%}

. {
    DEBUGF( stderr, "Unexpected input at line %d: '%s'\n", yylineno, yytext );
    exit( 1 );
}
