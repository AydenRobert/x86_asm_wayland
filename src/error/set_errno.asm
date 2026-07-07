extern errno

global set_errno

segment .text

	; void set_errno(int val)

set_errno:

	xor   rsi, rsi
	cmp   rdi, 0
	cmovl rdi, rsi
	neg   rdi
	mov   [rel errno], rdi

	ret
