#include <stdio.h>
#include <string.h>

char stack[100][10];
int top = 0;
int bottom = 0;
char tmp[3] = "t0";

int codegen(){
    printf("Intermediate code:%s = %s %s %s\n", tmp, stack[bottom], stack[bottom+2], stack[bottom+1]);
    bottom  = bottom+2;
    strcpy(stack[bottom],tmp);
    tmp[1]++;
    return 0;
}

int codegen_assign(){
    printf("Intermediate code:%s = %s\n", stack[bottom+1], stack[bottom]);
    bottom = bottom+2;
    return 0;
}

void push(char* input){
    strcpy(stack[top++], input);
    printf("pushed to stack:%s\n", input);
}

void push_int(int number){
    char str_extracted[20];
    sprintf(str_extracted, "%d", number); 
    strcpy(stack[top++], str_extracted);
    printf("pushed to stack:%s\n", str_extracted);
}

//inorder to pop the stack contents in case of conditional evaluation
void pop(){
    printf("The popped elements are: %s and %s\n", stack[bottom],stack[bottom+1]);
    bottom = bottom+2;
}