%{
# include "main.tab.h"
%}

%%
"DISPLAY"           { printf("Keyword DISPLAY\n"); return DISPLAY; }
"IF"                { printf("Keyword IF\n"); return IF; }
"THEN"              { printf("Keyword THEN\n"); return THEN; }
"ENDIF"             { printf("Keyword ENDIF\n"); return ENDIF; }
"ELSE"              { printf("Keyword ELSE\n"); return ELSE; }
"FOR"               { printf("Keyword FOR\n"); return FOR; }
"ENDFOR"            { printf("Keyword ENDFOR\n"); return ENDFOR; }
"DO"                { printf("Keyword DO\n"); return DO; }
"TO"                { printf("Keyword TO\n"); return TO; }
"WHILE"             { printf("Keyword WHILE\n"); return WHILE; }
"ENDWHILE"          { printf("Keyword ENDWHILE\n"); return ENDWHILE; }
"TRUE"              { printf("Boolean TRUE\n"); return B_TRUE; }
"FALSE"             { printf("Boolean FALSE\n"); return B_FALSE; }
"<="                { printf("Operator: %s\n", yytext); return LE; }
">="                { printf("Operator: %s\n", yytext); return GE; }
"=="                { printf("Operator: %s\n", yytext); return EQ; }
"!="                { printf("Operator: %s\n", yytext); return NE; }
">"	                { printf("Operator: %s\n", yytext); return GT; }
"<"	                { printf("Operator: %s\n", yytext); return LT; }
"="                 { printf("Operator: %s\n", yytext); return AO; }
"+"	                { printf("Operator +\n"); return ADD; }
"-"	                { printf("Operator -\n"); return SUB; }
"*"	                { printf("Operator *\n"); return MUL; }
"/"	                { printf("Operator /\n"); return DIV; }
\"([^\\\"]|\\.)*\"  { printf("Format string: %s\n", yytext); yylval.string = strdup(yytext+1); yylval.string[strlen(yytext)-2] = '\0'; return STRING; }
[0-9]+(\.[0-9]+)?	{ printf("NUMBER: %s\n",yytext); yylval.number = atoi(yytext); return NUMBER; }
[_A-Za-z0-9]+       { printf("Identifier: %s\n", yytext); yylval.string = strdup(yytext); return IDENTIFIER;}
\n                  { return EOL; }
[ \t]               { /* ignore white space */ }
.	                { yyerror("Mystery character %c\n", *yytext); }
%%


int main(int argc, char **argv) {
   if (argc != 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (!file) {
        printf("Failed to open the input file.\n");
        return 1;
    }

    printf("> ");
    yyin = file;
    yyparse();
    fclose(file);

    return 0;
}