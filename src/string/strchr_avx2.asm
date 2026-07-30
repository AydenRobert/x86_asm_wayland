; strchr_avx2.asm
; global functions:
;   char *strchr_avx2(char *str, char target)

segment .text
global _strchr_avx2

    PAGE_SIZE equ 0x1000
    VEC_SIZE equ 0x20

	; char *_strchr_avx2(char *str, char target)
    ;
    ; Arguments:
    ;   rdi: str, the pointer to the NULL terminated string
    ;   rsi: target, the character to look for
    ;
    ; Returns:
    ;   rax: the pointer to the first occurance, or NULL

_strchr_avx2:

    ;   unsigned int lower_half = (unsigned int)str
    mov eax, edi

    ;     zero out ymm0
    vpxor ymm0, ymm0

    ;            fill ymm1 with target
    movzx        esi, sil
    vmovd        xmm1, esi
    vpbroadcastb ymm1, xmm1

    ;   lower_half &= PAGE_SIZE - 1
    and eax, PAGE_SIZE - 1
    ;   if (lower_half > PAGE_SIZE - (1 + VEC_SIZE))
    cmp eax, PAGE_SIZE - (1 + VEC_SIZE)
    ja .cross_page_boundary

    ;       load ymm2 with the first 32 bytes
    vmovups ymm2, yword [rdi]

    ;         compare with target
    vpcmpeqb  ymm3, ymm2, ymm1
    vpmovmskb eax, ymm3

    ;         compare with NULL
    vpcmpeqb  ymm4, ymm2, ymm0
    vpmovmskb edx, ymm4

    ;   check if anything has been found
    mov ecx, eax
    or  ecx, edx
    cmp ecx, 0
    je  .initial_unroll

    ;     check if the end was before the character
    tzcnt eax, eax
    tzcnt edx, edx
    cmp   edx, eax
    jl    .found_end

    lea rax, [rdi + rax]
    ret

.found_end:

    mov rax, 0
    ret

.initial_unroll:

    inc rdi
    or rdi, (VEC_SIZE - 1)

    vmovaps ymm2, yword [rdi + 1]

    ;         compare with target
    vpcmpeqb  ymm3, ymm2, ymm1
    vpmovmskb eax, ymm3

    ;         compare with NULL
    vpcmpeqb  ymm4, ymm2, ymm0
    vpmovmskb edx, ymm4

    mov ecx, eax
    or  ecx, edx

    cmp ecx, 0
    jne  .ret0

    vmovaps ymm5, yword [rdi + (1 + VEC_SIZE)]

    ;         compare with target
    vpcmpeqb  ymm6, ymm5, ymm1
    vpmovmskb eax, ymm6

    ;         compare with NULL
    vpcmpeqb  ymm7, ymm5, ymm0
    vpmovmskb edx, ymm7

    mov ecx, eax
    or  ecx, edx

    cmp ecx, 0
    je  .loop_4x

    tzcnt eax, eax
    tzcnt edx, edx
    cmp   edx, eax
    jl    .found_end

    lea rax, [rdi + rax + (1 + VEC_SIZE)]
    ret

.ret0:

    tzcnt eax, eax
    tzcnt edx, edx
    cmp   edx, eax
    jl    .found_end

    lea rax, [rdi + rax + 1]
    ret

.loop_4x:

    inc rdi
    or  rdi, ((VEC_SIZE * 2) - 1)

    vmovaps ymm2, [rdi + 1]
    vmovaps ymm3, [rdi + (1 + VEC_SIZE)]

    ;        parallelise more
    ;        will check if can parallelise more
    vpcmpeqb ymm4, ymm1, ymm2
    vpcmpeqb ymm5, ymm1, ymm3
    vpmaxub  ymm5, ymm5, ymm4

    vpcmpeqb ymm6, ymm0, ymm2
    vpcmpeqb ymm7, ymm0, ymm3
    vpmaxub  ymm7, ymm7, ymm6

    vpmaxub   ymm8, ymm5, ymm7
    vpmovmskb eax, ymm8

    cmp eax, 0
    je  .loop_4x

    ; do like actual looking

    vpmovmskb eax, ymm4
    vpmovmskb edx, ymm6

    mov  ecx, eax
    or   ecx, edx
    test ecx, ecx
    jnz  .ret_4x_0

    vpmovmskb eax, ymm5
    vpmovmskb edx, ymm7

    tzcnt eax, eax
    tzcnt edx, edx
    cmp   edx, eax
    jl    .found_end

    lea rax, [rdi + rax + (1 + VEC_SIZE)]
    ret

.ret_4x_0:

    tzcnt eax, eax
    tzcnt edx, edx
    cmp   edx, eax
    jl    .found_end

    lea rax, [rdi + rax + 1]
    ret

.cross_page_boundary:
    
    ;   save starting address
    mov r8, rdi
    mov r9, rdi

    ;   round down to nearest vec_size
    and rdi, -VEC_SIZE

    ;   get difference
    sub r8, rdi

    ;       load ymm2 with the first 32 bytes
    vmovups ymm2, yword [rdi]

    ;         compare with target
    vpcmpeqb  ymm3, ymm2, ymm1
    vpmovmskb eax, ymm3
    shrx      eax, r8

    ;         compare with NULL
    vpcmpeqb  ymm4, ymm2, ymm0
    vpmovmskb edx, ymm4
    shrx      edx, r8

    mov rdi, r9

    ;   check if anything has been found
    mov ecx, eax
    or  ecx, edx
    cmp ecx, 0
    je  .initial_unroll

    ;     check if the end was before the character
    tzcnt eax, eax
    tzcnt edx, edx
    cmp   edx, eax
    jl    .found_end

    lea rax, [rdi + rax]
    ret
