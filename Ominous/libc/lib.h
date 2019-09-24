#ifndef LIB_H
#define LIB_H
int strncmp (const char* str1, const char* str2, size_t num);
size_t strlen (const char* str);
void bzero (char *s, size_t n);
char* itoa(int num, char* str, int base);
void printint(int i);
#endif