#pragma once

#include "aux_type_strings.h"

typedef struct {
    int a_type;
    union {
        long a_val;
        void *a_ptr;
        void (*a_fnc)();
    } a_un;
} auxv_t;

extern auxv_t *paux;
extern unsigned long int aux_len;
