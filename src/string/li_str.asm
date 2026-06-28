segment .text
global  li_str

	; int li_str(long int num, char *buffer, int buffer_len)

li_str:
	push rbp
	push rbx
	push r12
	mov  rbp, rsp

	cmp rdi, 0
	jne .Lli_str_setup_start

	mov [rsi], 48
	mov rcx, 1

	jmp .Lli_str_reverse_end

.Lli_str_setup_start:

	;   setup counter
	mov rcx, 0
	mov r8, rdx

	mov r9, 1

	;   num to rax register
	mov rax, rdi

	;   base 10 to rbx
	mov rbx, 10

	;   negate rax
	neg rax
	;   need a zero value in a register
	xor r11, r11

	;     check if rax is negative
	cmp   rax, 0
	;     turn it positive again
	cmovl rax, rdi
	;     make r9 zero if rdi is positive
	cmovl r9, r11

	;   r10 will be the pointer to the current char
	mov r10, rsi

.Lli_str_loop_start:

	;   if at end of buffer
	cmp rcx, r8
	jz  .Lli_str_loop_end

	;   if finished writing number
	cmp rax, 0
	jz  .Lli_str_loop_end

	;   num / 10
	xor rdx, rdx
	div rbx

	;   convert to ascii and save to memory
	add rdx, 48
	mov [r10], rdx

	;   increment counter and pointer
	inc r10
	inc rcx

	jmp .Lli_str_loop_start

.Lli_str_loop_end:

	dec r10
	mov r12, rsi

	;   place negative symbol at the end
	cmp r9, 0
	je  .Lli_str_reverse_start
	inc r10
	inc rcx
	mov [r10], 45

.Lli_str_reverse_start:

	;   if (start >= end)
	cmp rsi, r10
	jge .Lli_str_reverse_end

	mov  r9b, byte [rsi]
	xchg r9b, byte [r10]
	mov  byte [rsi], r9b

	inc rsi
	dec r10

	jmp .Lli_str_reverse_start

.Lli_str_reverse_end:

	mov rax, rcx

	pop r12
	pop rbx
	pop rbp
	ret
