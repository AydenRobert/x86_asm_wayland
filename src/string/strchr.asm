; strchr.asm
; global functions:
;   char *strchr(char *str, char target)

extern is_avx2_supported
extern _strchr_scalar
extern _strchr_avx2

segment .data
strchr_ptr: dq strchr.resolve

segment .text
global  strchr

	; char *strchr(char *str, char target)
    ;
    ; Arguments:
    ;   rdi: str, the pointer to the NULL terminated string
    ;   rsi: target, the character to look for
    ;
    ; Returns:
    ;   rax: the pointer to the first occurance, or NULL


strchr:
    jmp [rel strchr_ptr]

.resolve:

	call is_avx2_supported
	test eax, eax
	jnz  .use_avx2

.use_scalar:
    
    lea rax, [rel _strchr_scalar]
    mov qword [rel strchr_ptr], rax
    jmp rax

.use_avx2:

    lea rax, [rel _strchr_avx2]
    mov qword [rel strchr_ptr], rax
    jmp rax
