%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>

/* header for symbol table */
#include "symbol_table.h"


extern int yylex();
extern char* yytext;

/* header for intermediate code generation */
#include "intermediate_code.h"

void yyerror(char *s);

int temp;
%}

/* declare tokens */
%union {
    char* string;
    double number;
    int integer;
} 

%token <number> NUMBER
%token DISPLAY
%token IF ENDIF ELSE THEN
%token FOR ENDFOR DO TO WHILE ENDWHILE
%token ADD SUB MUL DIV ABS
%token EQ LE GE NE GT LT AO
%token B_TRUE B_FALSE
%token OP CP
%token <string> IDENTIFIER
%token EOL
%token <string> STRING

%left GT LT GE LE EQ NE
%left ADD SUB ABS
%left MUL DIV

%type <integer> expression
%type <integer> factor
%type <integer> term
%type <integer> condition

%%

program:
    | statement_lists
    ;

statement_lists:
    statement
    | statement_lists statement
    ;

statement:
    functional_statement
    | conditional_statement
    | loop_statements
    | assignment_statements
    ;

assignment_statements:
    IDENTIFIER AO expression EOL { push($1); printf("Identifier name:%s Identifier value:%d\n",$1,$3); insert_symbol($1, $3, 1); codegen_assign(); }
    | IDENTIFIER AO expression { printf("Identifier name:%s Identifier value:%d\n",$1,$3); insert_symbol($1, $3, 1); }
    ;


functional_statement:
    DISPLAY STRING { printf("%s\n", $2); free($2); }   
    | DISPLAY STRING EOL { printf("%s\n", $2); free($2); }
    | DISPLAY IDENTIFIER { 
        struct symbol* variable = lookup_symbol($2);
        if(variable != NULL){
            int val = (int)(intptr_t)variable->value;
            printf("%d\n", val);
        }
        else{
            yyerror("variable not yet declared");
        }
    }
    | DISPLAY IDENTIFIER EOL { 
        struct symbol* variable = lookup_symbol($2);
        if(variable != NULL){
            int val = (int)(intptr_t)variable->value;
            printf("%d\n", val);
        }
        else{
            yyerror("variable not yet declared");
        }
    }
    ;

conditional_statement : 
    IF condition THEN statement_lists ENDIF { if ($2) printf("Condition is true.\n"); else printf("Condition is false.\n"); }
    | IF condition THEN statement_lists ELSE state
    IF condition THEN statement_lists ENDIF { if ($2) printf("Cment_lists ENDIF { if ($2) printf("Condition is true.\n"); else printf("Condition is false.\n"); }
    ;

loop_statements:
    for_loop
    | while_loop
    ;

for_loop:
    init_forloop frloop_cont
    ;

init_forloop:
    FOR IDENTIFIER AO NUMBER { temp = $4; }
    ;

frloop_cont:
    TO NUMBER DO statement_lists ENDFOR EOL { printf("For loop will go on till %d iterations\n",(int)$2-temp); }
    ;

while_loop:
    WHILE condition DO statement_lists ENDWHILE EOL { if ($2) printf("Condition is true.\n"); else printf("Condition is false.\n"); }
    ;

condition:
    NUMBER { $$ = ($1 > 0) ? 1 : 0; }
    | expression GT expression { $$ = ($1 > $3) ? 1 : 0; pop(); }
    | expression LT expression { $$ = ($1 < $3) ? 1 : 0; pop(); }
    | expression GE expression { $$ = ($1 >= $3) ? 1 : 0;pop(); }
    | expression LE expression { $$ = ($1 <= $3) ? 1 : 0;pop(); }
    | expression EQ expression { $$ = ($1 == $3) ? 1 : 0;pop(); }
    | expression NE expression { $$ = ($1 != $3) ? 1 : 0;pop(); }
    ;

expression:
    factor
 | expression ADD expression { $$ = (int)($1 + $3); push("+"); codegen(); }
 | expression SUB factor { $$ = (int)($1 - $3); push("-"); codegen(); }
 ;

factor: term
 | factor MUL term { $$ = (int)($1 * $3); push("*"); codegen(); }
 | factor DIV term { $$ = (int)($1 / $3); push("/"); codegen(); }
 ;

term: NUMBER { 
    push_int((int)$1); $$ = (int)$1; 
 }
 | IDENTIFIER {
    struct symbol* variable = lookup_symbol($1);
    if(variable != NULL){
        int val = (int)(intptr_t)variable->value;
        printf("%d\n", val);
        $$ = val;
        push_int(val);
    }
    else{
        yyerror("variable not yet declared");
    }
 }
 ;

%%

void yyerror(char *s) {
    fprintf(stderr, "error: %s\n", s);
}
