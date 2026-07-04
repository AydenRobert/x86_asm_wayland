segment .text
global  cstring_len_avx2

	; int cstring_len_avx2(char *str)

cstring_len_avx2:

	mov   eax, edi; eax hold lower half of address
	mov   rdx, rdi; rdx holds full address
	vpxor xmm0, xmm0, xmm0; ymm0 is zero bytes

	;   use lower half of address to see if near a page boundary
	and eax, 0xFFF; page_size - 1
	cmp eax, 0xFDF; page_size - vec_size
	ja  .Lcstring_len_avx2_cross_page_boundary

	;         compare 0 bytes to char bytes in memory, store results in ymm1
	vpcmpeqb  ymm1, ymm0, [rdi]
	;         pack those 0 bytes into a bit mask where 1 is a match
	vpmovmskb eax, ymm1

	;    if eax is zero, we haven't found null terminator
	xor  rcx, rcx
	test eax, eax
	jz   .Lcstring_len_avx2_initial_unloop

	;     count the trailing zeros, that is the length of the string
	tzcnt eax, eax

	ret

.Lcstring_len_avx2_initial_unloop:

	;  Align data to 32 bytes
	or rdi, 0x1F

	; initial checks (medium len strings)

	vpcmpeqb  ymm1, ymm0, [rdi + 0x01]
	vpmovmskb eax, ymm1
	test      eax, eax
	jnz       .Lcstring_len_avx2_r0

	vpcmpeqb  ymm1, ymm0, [rdi + 0x21]
	vpmovmskb eax, ymm1
	test      eax, eax
	jnz       .Lcstring_len_avx2_r1

	vpcmpeqb  ymm1, ymm0, [rdi + 0x41]
	vpmovmskb eax, ymm1
	test      eax, eax
	jnz       .Lcstring_len_avx2_r2

	vpcmpeqb  ymm1, ymm0, [rdi + 0x61]
	vpmovmskb eax, ymm1
	test      eax, eax
	jnz       .Lcstring_len_avx2_r3

	jmp .Lcstring_len_avx2_4x_loop

.Lcstring_len_avx2_r0:

	tzcnt eax, eax
	add   rax, rdi
	sub   rax, rdx
	inc   rax

	ret

.Lcstring_len_avx2_r1:

	tzcnt eax, eax
	add   rax, rdi
	sub   rax, rdx
    add   rax, 0x21

	ret

.Lcstring_len_avx2_r2:

	tzcnt eax, eax
	add   rax, rdi
	sub   rax, rdx
    add   rax, 0x41

	ret

.Lcstring_len_avx2_r3:

	tzcnt eax, eax
	add   rax, rdi
	sub   rax, rdx
    add   rax, 0x61

	ret

.Lcstring_len_avx2_4x_loop:

	or  rdi, 0x7F; vec_size * 4 - 1

.Lcstring_len_avx2_cross_page_continue:

	vmovdqa ymm1, [rdi + 0x01]
	vpminub ymm2, ymm1, [rdi + 0x21]
	vmovdqa ymm3, [rdi + 0x41]
	vpminub ymm4, ymm3, [rdi + 0x61]

	vpminub   ymm5, ymm4, ymm1
	vpcmpeqb  ymm5, ymm5, ymm0
	vpmovmskb ecx, ymm5

	sub  rdi, -0x80
	test ecx, ecx
	jz   .Lcstring_len_avx2_4x_loop

.Lcstring_len_avx2_4x_check:

	vpcmpeqb  ymm1, ymm1, ymm0
	vpmovmskb eax, ymm1
	test      eax, eax
	jnz       .Lcstring_len_avx2_4x_r0

	vpcmpeqb  ymm2, ymm2, ymm0
	vpmovmskb eax, ymm2
	test      eax, eax
	jnz       .Lcstring_len_avx2_4x_r1

	vpcmpeqb  ymm3, ymm3, ymm0
	vpmovmskb eax, ymm3

	sal rcx, 32
	or  rax, rcx

	tzcnt rax, rax
	sub   rdi, 0x3F
	add   rax, rdi
	sub   rax, rdx

	ret

.Lcstring_len_avx2_4x_r0:

	tzcnt eax, eax
	sub   rdi, 0x7F
	add   rax, rdi
	sub   rax, rdx

	ret

.Lcstring_len_avx2_4x_r1:

	tzcnt eax, eax
	sub   rdi, 0x5F
	add   rax, rdi
	sub   rax, rdx

	ret

.Lcstring_len_avx2_cross_page_boundary:

	;         align backwards to 32 bytes
	or        rdi, 0x1F
	;         compare with zero bytes
	vpcmpeqb  ymm1, ymm0, [rdi - 0x1F]
	vpmovmskb eax, ymm1

	;    010s0110 -> xxxx010s
	;    shift bitmask to exclude bytes behind start of string
	sarx eax, eax, edx

	;     if there isn't a match, continue with usual path
	test  eax, eax
	jz    .Lcstring_len_avx2_cross_page_continue
	tzcnt eax, eax

	ret
