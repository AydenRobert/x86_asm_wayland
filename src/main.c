#include "utils/aux.h"

extern char **ppenv;
extern unsigned long int env_len;

extern auxv_t *paux;
extern unsigned long int aux_len;

extern void print(char *str, int len);
extern void print_li(long int num);
extern void print_line();
extern int cstring_len(char *str);

int main(int argc, char *argv[]) {
    for (int i = 0; i < aux_len; i++) {
        char *str = at_str_list[paux[i].a_type];
        print(str, cstring_len(str));
        print_line();
    }
    return 0;
}
