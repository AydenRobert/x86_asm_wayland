; strchr.asm
; global functions:
;   char *_strchr_scalar(char *str, char target)

segment .text
global _strchr_scalar

	; char *strchr(char *str, char target)
    ;
    ; Arguments:
    ;   rdi: str, the pointer to the NULL terminated string
    ;   rsi: target, the character to look for
    ;
    ; Returns:
    ;   rax: the pointer to the first occurance, or NULL

_strchr_scalar:

.loop_start:

    ;   for (;*str;str++)
	cmp byte [rdi], 0
	je  .end_string
    ;   if (*str == target) return str
	cmp byte [rdi], sil
	je  .found_point
	inc rdi
	jmp .loop_start

.end_string:

    ;   return 0;
	mov rax, 0
    ret

.found_point:

    mov rax, rdi
	ret
