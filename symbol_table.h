#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

struct symbol{
    char* name;
    void* value;
    int dtype;
};

struct symbol symbol_table[100];
int symbol_count = 0;

// Function to lookup a symbol in the table
struct symbol* lookup_symbol(char* name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            return &symbol_table[i];
        }
    }
    return NULL; // Symbol not found
}

// Function to insert a symbol into the table
void insert_symbol(char* name, int value, int dtype) { //dtype  1 for int and 2 for string
    struct symbol symbol;
    symbol.name = strdup(name);    
    symbol.value = (void*)value;
    symbol.dtype = dtype;
    symbol_table[symbol_count++] = symbol;
}