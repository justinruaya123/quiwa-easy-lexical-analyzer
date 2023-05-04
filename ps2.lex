/* 
 * Problem Set 2 - Quiwa Tokenizer 
 * By: Justin Ruaya
 * Usage: (1) $ flex ps2.lex
 *        (2a on Mac OS X) $ gcc lex.yy.c -ll 
 *        (2b on Linux)    $ gcc lex.yy.c -lfl
 *        (3) $ ./a.out <FILE_NAME>.easy
 * If you're using a different QUIWA pseudocode
 */

%option noyywrap

%{
#include <stdio.h>
#include <math.h>
void ret_print(char *token_type);
void yyerror();

// PARAMETERS
// ================================================
// how many spaces to count as "indentation"?
#define TAB_DEPTH 3

// ================================================

int comma_count = 0;
int semicolon_count = 0;
int open_parenthesis_count = 0;
int close_parenthesis_count = 0;
int open_square_bracket_count = 0;
int close_square_bracket_count = 0;

// Define a stack for parentheses
char stack[100];
int stack_top = 0;

void push(char c) {
  stack[stack_top] = c;
  stack_top++;
}

char pop() {
  stack_top--;
  return stack[stack_top];
}



int dot_count = 0;
int colon_count = 0;

int indent_consumed = 0;
int line_space = 0;
%}

T_OP_ARITH      [*/+-]
T_ASSIGN        [=]
T_OP_LOGICAL    ((and)|(or)|(not)) 
T_OP_RELATIONAL ((:=)|(==)|(!=)|(<=)|(>=)|(<)|(>))
T_STRING        ('[^\']*')
T_FLOAT         ([-+]?([0-9]+)(((\.[0-9]+))|([eE][\-+][0-9]+)){1,2})
T_INT           ([0-9]+)
T_DELIMITER     [,:;().\[\]]
T_RES_TRANS     ((go to)|(exit))
T_RES_COND      ((if)|(then)|(else)|(case))
T_RES_ITER      ((for)|(while)|(do)|(repeat)|(until)|(loop)|(forever)|(to)|(by))
T_RES_IO        ((input)|(output))
T_RES_CLOSURE   ((endcase)|(endwhile)|(endfor)|(end))
T_RES_DECL      ((array)|(node))
T_FUNCTION      ((call)|(return)|(procedure))
T_IDENTIFIER    ([_a-zA-Z]+[_a-zA-Z0-9]*)
T_WHITESPACE    ([ \t\n])
T_COMMENT       ((\/\/).*)
%%

{T_OP_ARITH}        { ret_print("T_OP_ARITH"); }
{T_ASSIGN}          { ret_print("T_ASSIGN"); }
{T_OP_LOGICAL}      { ret_print("T_OP_LOGICAL"); }
{T_OP_RELATIONAL}   { ret_print("T_OP_RELATIONAL"); }
{T_STRING}          { ret_print("T_STRING"); }
{T_FLOAT}           { ret_print("T_FLOAT"); }
{T_INT}             { ret_print("T_INT"); }
{T_DELIMITER}       { 
                     switch (yytext[0]) {
                        case ',':
                          comma_count++;
                          break;
                        case ';':
                          semicolon_count++;
                          break;
                        case '(':
                          open_parenthesis_count++;
                          push('(');
                          break;
                        case ')':
                          close_parenthesis_count++;
                          pop();
                          break;
                        case '[':
                          open_square_bracket_count++;
                          push('[');
                          break;
                        case ']':
                          close_square_bracket_count++;
                          pop();
                          break;
                        case '.':
                          dot_count++;
                          break;
                        case ':':
                          colon_count++;
                          break;
                     }
                     ret_print("T_DELIMITER");
                    }
{T_RES_COND}        { ret_print("T_RES_COND"); }
{T_RES_ITER}        { ret_print("T_RES_ITER"); }
{T_RES_IO}          { ret_print("T_RES_IO"); }
{T_RES_CLOSURE}     { ret_print("T_RES_CLOSURE"); }
{T_RES_DECL}        { ret_print("T_RES_DECL"); }
{T_FUNCTION}        { ret_print("T_FUNCTION"); }
{T_IDENTIFIER}      { ret_print("T_IDENTIFIER"); }
{T_WHITESPACE}      {  
                      switch (yytext[0]) {
                        case '\n':
                          line_space = 0;
                          indent_consumed = 0;
                          break;
                        case '\t':
                          if(indent_consumed == 0)
                            line_space += TAB_DEPTH;
                          break;
                        case ' ':
                          if(indent_consumed == 0)
                            line_space++;
                          break;
                      }
                    } // Eat up whitespace 
{T_COMMENT}         { ret_print("T_COMMENT"); }

%%

void ret_print (char *token_type) {
    // Indentation to match quiwa code
    for (int i = 0; i < line_space; i++) {
      printf(".");
    }
    for (int i = 0; i < stack_top; i++) {
      printf("+");
    }
    indent_consumed = 1; // Don't add any other whitespaces beyond this until newline
    printf("<%s,%s>\n", token_type, yytext);
}

void yyerror(char *message) {
    printf("Error: %s\n", message);
    exit(1);
}

int main( int argc, char **argv )
    {
    ++argv, --argc;  /* skip over program name */
    if ( argc > 0 )
            yyin = fopen( argv[0], "r" );
    else
            yyin = stdin;

    yylex();

    printf("Total number of commas: %d\n", comma_count);
    printf("Total number of semicolons: %d\n", semicolon_count);
    printf("Total number of dots: %d\n", dot_count);
    printf("Total number of colons: %d\n", colon_count);

    printf("Total number of open parentheses: %d\n", open_parenthesis_count);
    printf("Total number of close parentheses: %d\n", close_parenthesis_count);
    printf("Total number of open square brackets: %d\n", open_square_bracket_count);
    printf("Total number of close square brackets: %d\n", close_square_bracket_count);
    if(stack_top != 0) {
      printf("Parentheses: Mismatch!\n");
    } else {
      printf("Parentheses: Match!\n");
    }
    fclose(yyin);
    return 0;
}