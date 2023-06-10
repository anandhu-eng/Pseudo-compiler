main: 	main.l main.y
		bison -d main.y
		flex main.l
		cc -o $@ main.tab.c lex.yy.c -lfl