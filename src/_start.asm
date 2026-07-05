extern main
extern _exit

extern setup_env_aux
extern enumerate_cpu_capabilities

segment .text
global  _start

_start:

	;   rsp holds argc
	;   rsp + 8 is the start of argv
	mov r12, [rsp]
	lea r13, [rsp + 8]

	;    call env/aux setup
	lea  rdi, [rsp + r12*8 + 16]
	call setup_env_aux

    call enumerate_cpu_capabilities

	;   align stack pointer
	and rsp, -16
	sub rsp, 8

	mov rdi, r12
	mov rsi, r13

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
