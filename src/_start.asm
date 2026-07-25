extern main
extern _exit

%include "src/preload/startup.inc"

segment .text
global  _start

_start:

	;   rsp holds argc
	;   rsp + 8 is the start of argv
	mov r12, [rsp]
	lea r13, [rsp + 8]

	;    call env setup
	lea  rdi, [rsp + r12*8 + 16]
	mov  r14, rdi
	call setup_env

    lea rdi, [rax + 8]
	call setup_aux

	call enumerate_cpu_capabilities

	;   align stack pointer
	and rsp, -16
	sub rsp, 8

	mov rdi, [rsp]
	mov rsi, [rsp + 8]

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
