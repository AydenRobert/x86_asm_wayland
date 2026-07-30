segment .text
global  li_str

	; int li_str(long int num, char *buffer, int buffer_len, int is_signed, enum base)

	; enum base_type {
	; NONE, -> DECIMAL
	; BINARY
	; OCTAL
	; DECIMAL
	; HEXADECIMAL
	;}

rem_to_ascii:
	db '0'
	db '1'
	db '2'
	db '3'
	db '4'
	db '5'
	db '6'
	db '7'
	db '8'
	db '9'
	db 'A'
	db 'B'
	db 'C'
	db 'D'
	db 'E'
	db 'F'

li_str:
	push rbx
	push r12
	push r13
	push r14

	mov r13, rcx
	mov r14, r8; r14 enum -> base

	cmp rdi, 0
	jne .setup_start

	mov [rsi], 48
	mov rcx, 1

	jmp .reverse_end

.setup_start:

	;   setup counter
	mov rcx, 0
	mov r8, rdx

	;   num to rax register
	mov rax, rdi

	;   set base
	mov rbx, 10

	;     BINARY
	mov   r10, 2
	cmp   r14, 1
	cmove rbx, r10
	;     OCTAL
	mov   r10, 8
	cmp   r14, 2
	cmove rbx, r10
	;     HEXADECIMAL
	mov   r10, 16
	cmp   r14, 4
	cmove rbx, r10

	cmp r13, 0
	je  .Lconv_start

.Lneg_check:

	mov r9, 1
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

.Lconv_start:

	;   r10 will be the pointer to the current char
	mov r10, rsi

	lea r11, [rel rem_to_ascii]; r11 = &rem_to_ascii

.loop_start:

	;   if at end of buffer
	cmp rcx, r8
	jz  .loop_end

	;   if finished writing number
	cmp rax, 0
	jz  .loop_end

	;   num / 10
	xor rdx, rdx
	div rbx

	;   convert to ascii and save to memory
	mov dl, byte [r11 + rdx]
	mov byte [r10], dl

	;   increment counter and pointer
	inc r10
	inc rcx

	jmp .loop_start

.loop_end:

	dec r10
	mov r12, rsi

	cmp r13, 0
	je  .Lplace_binary

	;   place negative symbol at the end
	cmp r9, 0
	je  .Lplace_binary
	inc r10
	inc rcx
	mov [r10], 45

	; place base specifier at the start

.Lplace_binary:
	;   BINARY
	cmp r14, 1
	jne .Lplace_octal

	mov [r10 + 1], 'b'
	mov [r10 + 2], '0'
	add r10, 2
	add rcx, 2

	jmp .reverse_start

.Lplace_octal:
	;   OCTAL
	cmp r14, 2
	jne .Lplace_hex

	inc r10
	inc rcx
	mov [r10], '0'

	jmp .reverse_start

.Lplace_hex:
	;   HEXADECIMAL
	cmp r14, 4
	jne .reverse_start

	mov [r10 + 1], 'x'
	mov [r10 + 2], '0'
	add r10, 2
	add rcx, 2

	jmp .reverse_start

.reverse_start:

	;   if (start >= end)
	cmp rsi, r10
	jge .reverse_end

	mov  r9b, byte [rsi]
	xchg r9b, byte [r10]
	mov  byte [rsi], r9b

	inc rsi
	dec r10

	jmp .reverse_start

.reverse_end:

	mov rax, rcx

	pop r14
	pop r13
	pop r12
	pop rbx
	ret
