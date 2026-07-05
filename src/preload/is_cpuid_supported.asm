segment .text
global  is_cpuid_supported

	; int is_cpuid_supported()

is_cpuid_supported:

	pushfq
	mov r15, [rsp]
	bts qword [rsp], 21
	jnc .skip
	btr qword [rsp], 21

.skip:

	popfq

	mov  rax, 1
	pushfq
	test [rsp], r15
	jnz  .done
	mov  rax, 0

.done:

	mov [rsp], r15
	popfq
	ret
