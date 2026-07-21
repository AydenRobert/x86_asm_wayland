#pragma once

#include "../utils/int.h"

typedef struct file {
    int fd;
    char *buffer;
    size_t buffer_len;
    size_t buffer_cap;
    int (*write)(struct file *f, char *buffer, size_t write_len);
    int (*read)(struct file *f, char *buffer, size_t buffer_len);
    int (*flush)(struct file *f);
} file;

extern file stdout_file;
extern file stdin_file;
