extern main
extern _exit

segment .bss

global penv

	;    char** penv
	penv resq 1

	segment .text
	global  _start

_start:

	;   rsp holds argc
	;   rsp + 8 is the start of argv
	mov rdi, [rsp]
	lea rsi, [rsp + 8]

	;   save env ptr
	lea rax, [rsp + rdi*8 + 16]
	mov [rel penv], rax

	;   align stack pointer
	and rsp, -16
	sub rsp, 8

	;    Function:
	;    main(int argc, char *argv[])
	;    Args:
	;    RDI: argc
	;    RSI: argv
	;    Return:
	;    RAX: int
	call main

	mov  rdi, rax
	call _exit
