CC := gcc
NASM := nasm
SRC_DIR := src
OBJ_DIR := obj

asm_files = $(shell find $(SRC_DIR) -type f -name "*.asm")
asm_objects = $(patsubst $(SRC_DIR)/%.asm, $(OBJ_DIR)/%.o, $(asm_files))

.PHONY: all clean

all: clean main

main: $(asm_objects) $(SRC_DIR)/main.c
	$(CC) -g -nostdlib -fno-stack-protector -o $@ $^

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.asm
	@mkdir -p $(dir $@)
	$(NASM) -g -f elf64 -o $@ $<

clean:
	rm -rf $(OBJ_DIR) main
