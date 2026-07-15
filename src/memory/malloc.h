#pragma once

#include "../utils/int.h"

struct meta_block {
    size_t block_size;
    struct meta_block *next;
    int free;
};

extern void *malloc(size_t size);
extern void free(void *ptr);
