; strlen.asm
; global functions:
;   int strlen(char *str)
; side effects:
;   strlen: changes internal strlen_ptr to reflect CPU capabilities

extern is_avx2_supported

extern _strlen_scalar
extern _strlen_avx2

segment .data

strlen_ptr: dq strlen.resolve

segment .text
global  strlen

	; int strlen(char *str)
    ; 
    ; arguments:
    ;   rdi: str, pointer to the first character of the null terminated string
    ;
    ; returns:
    ;   rax: length of the string, not including null terminator

strlen:
	jmp [rel strlen_ptr]

.resolve:
	call is_avx2_supported
	test eax, eax
	jnz  .use_avx2

.use_scalar:
	lea rax, [rel _strlen_scalar]
	mov qword [rel strlen_ptr], rax
	jmp rax

.use_avx2:
	lea rax, [rel _strlen_avx2]
	mov qword [rel strlen_ptr], rax
	jmp rax
