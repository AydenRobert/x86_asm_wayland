segment .text
global  _mem_cmp_avx2

	; int _mem_cmp_avx2(char *ptr1, char *ptr2, int len)

_mem_cmp_avx2:

	mov eax, edi
	or  eax, esi
	mov r8, rdi
	mov r9, rsi

	and eax, 0xFFF; page_size - 1
	cmp eax, 0xFDF; page_size - vec_size
	ja  .cross_page_boundary

	vmovdqu   ymm0, [rdi]
	vpcmpeqb  ymm1, ymm0, [rsi]
	vpmovmskb eax, ymm1

	inc eax
	jz  .setup_loop

	tzcnt eax, eax
	cmp   eax, edx
	je    .ret_0

.main_ret:

	xor rcx, rcx
	mov cl, byte [rsi + rax]
	mov al, byte [rdi + rax]

	sub eax, ecx

	ret

.setup_loop:

	add rdi, 0x20
	add rsi, 0x20
	sub rdx, 0x20

.loop:

	cmp rdx, 0x80
	jb  .less_than_4qq

	vmovdqu  ymm0, [rdi]
	vpcmpeqb ymm0, ymm0, [rsi]

	vmovdqu  ymm1, [rdi + 0x20]
	vpcmpeqb ymm1, ymm1, [rsi + 0x20]

	vmovdqu  ymm2, [rdi + 0x40]
	vpcmpeqb ymm2, ymm2, [rsi + 0x40]

	vmovdqu  ymm3, [rdi + 0x60]
	vpcmpeqb ymm3, ymm3, [rsi + 0x60]

	vpminub ymm4, ymm1, ymm0
	vpminub ymm4, ymm4, ymm2
	vpminub ymm4, ymm4, ymm3

	add rdi, 0x80
	add rsi, 0x80
	sub rdx, 0x80

	vpmovmskb eax, ymm4
	inc       eax
	jz        .loop

	sub rdi, 0x80
	sub rsi, 0x80

	vpmovmskb eax, ymm0
	inc       eax
	xor       rcx, rcx
	jnz       .loop_ret

	vpmovmskb eax, ymm1
	inc       eax
	mov       ecx, 0x20
	jnz       .loop_ret

	vpmovmskb eax, ymm2
	inc       eax
	mov       ecx, 0x40
	jnz       .loop_ret

	vpmovmskb eax, ymm3
	inc       eax
	mov       ecx, 0x60
	jnz       .loop_ret

.loop_ret:

	tzcnt eax, eax
	add   eax, ecx
	xor   rcx, rcx
	mov   cl, byte [rsi + rax]
	mov   al, byte [rdi + rax]

	sub eax, ecx

	ret

.less_than_4qq:

	cmp rdx, 0x20
	jb  .less_than_qq

	vmovdqu   ymm0, [rdi]
	vpcmpeqb  ymm0, ymm0, [rsi]
	vpmovmskb eax, ymm0

	add rdi, 0x20
	add rsi, 0x20
	sub rdx, 0x20

	inc eax
	jz  .less_than_4qq

	sub rdi, 0x20
	sub rsi, 0x20

	jmp .vec_return

.less_than_qq:

	cmp rdx, 0x10
	jb  .less_than_dq

	vmovdqu   xmm0, [rdi]
	vpcmpeqb  xmm0, xmm0, [rsi]
	vpmovmskb eax, ymm0

	add rdi, 0x10
	add rsi, 0x10
	sub rdx, 0x10

	inc ax
	jz  .less_than_dq

	sub rdi, 0x10
	sub rsi, 0x10

.vec_return:

	tzcnt eax, eax
	xor   rcx, rcx
	mov   cl, byte [rsi + rax]
	mov   al, byte [rdi + rax]

	sub eax, ecx

	ret

.less_than_dq:

	mov rcx, rdx
	dec rcx

.scalar_loop_start:

	mov dl, byte [rdi]
	cmp dl, byte [rsi]
	jne .scalar_loop_end

	inc  rdi
	inc  rsi
	loop .scalar_loop_start

.scalar_loop_end:

	xor rcx, rcx
	mov cl, byte [rsi + rax]
	mov al, byte [rdi + rax]

	sub eax, ecx

	ret

.end_mem:

	mov eax, 0

	ret

.cross_page_boundary:

	cmp rdx, 0x20
	jb  .less_than_qq

	vmovdqu   ymm0, [rdi]
	vpcmpeqb  ymm0, ymm0, [rsi]
	vpmovmskb eax, ymm0

	inc eax
	jz  .setup_loop

	tzcnt eax, eax
	mov   cl, [rsi + rax]
	mov   al, [rdi + rax]

	sub eax, ecx

	ret

.ret_0:

	mov eax, 0
	ret
