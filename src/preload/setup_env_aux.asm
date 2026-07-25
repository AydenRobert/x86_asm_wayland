; setup_env_aux.asm
; global functions:
;   char **setup_env(char **env_start)
;   uint64_t *setup_aux(auxv_t *aux_start)
; side effects:
;   setup_env stores the starting pointer of the environment entries array in ppenv
;             stores the length of the environment entries array in env_len
;   setup_aux stores the starting pointer of the auxiliary-vector entries array in paux
;             stores the length of the auxiliary-vector entries array in aux_len

%include "src/utils/env.inc"
%include "src/utils/aux.inc"
%include "src/assert/assert.inc"

segment .text
global  setup_env, setup_aux
    
    ; char **setup_env(char **env_start)
    ;
    ; Arguments:
    ;   rdi: env_start, pointer to first environment entry
    ;
    ; Returns:
    ;   rax: pointer to terminating NULL environment entry
    ;
    ; Writes:
    ;   [ppenv]: pointer to first environment entry
    ;   [env_len]: number of environment entries
    ;
    ; Preserves:
    ;   r12

setup_env:

    push r12
    mov  r12, rdi

    ;    assert(env_start != NULL)
	test rdi, rdi
    jnz .valid_env_start

	mov  edi, 1
	call assert
    ud2

.valid_env_start:

    mov rdi, r12
    mov qword [rel ppenv], rdi

;     for (; *env_ptr; env_ptr++);
align 16
.find_terminator:

    ;   *env_ptr
    cmp qword [rdi], 0
    je .terminator_found
    ;   env_ptr++
    add rdi, ENV_ENTRY_SIZE
    jmp .find_terminator

.terminator_found:

	;   return env_ptr
    mov rax, rdi

	;   env_len = (env_ptr - env_start) >> 3
    sub rdi, qword [rsp]
    shr rdi, ENV_ENTRY_SHIFT
    mov [rel env_len], rdi

    pop r12

    ret

    ; uint64_t *setup_env(auxv_t *aux_start)
    ;
    ; Arguments:
    ;   rdi: aux_start, pointer to first auxiliary-vector entry
    ;
    ; Returns:
    ;   rax: pointer to terminating NULL auxiliary-vector entry
    ;
    ; Writes:
    ;   [paux]: pointer to first auxiliary-vector entry
    ;   [aux_len]: number of auxiliary-vector entries
    ;
    ; Preserves:
    ;   r12

setup_aux:

    push r12
    mov r12, rdi

    ;    assert(aux_start != NULL)
    test rdi, rdi
    jnz  .valid_aux_start

	mov   edi, 1
	call  assert
    ud2

.valid_aux_start:

    mov rdi, r12
    mov qword [rel paux], rdi

;     for (; *aux_ptr; aux_ptr++);
align 16
.find_terminator:

    ;   *aux_ptr
    cmp dword [rdi], 0
    je .terminator_found
    ;   aux_ptr++
    add rdi, AUX_SIZE
    jmp .find_terminator

.terminator_found:

	;   return aux_ptr
    mov rax, rdi

	;   aux_len = (aux_ptr - aux_start) >> 4
    sub rdi, qword [rsp]
    shr rdi, AUX_SHIFT
    mov [rel aux_len], rdi

    pop r12

    ret
