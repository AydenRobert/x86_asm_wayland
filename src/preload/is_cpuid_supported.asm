segment .text
global  is_cpuid_supported

	; int is_cpuid_supported()

is_cpuid_supported:

	pushfq
	mov r15, [rsp]
	bts qword [rsp], 21
	jnc .Lis_cpuid_supported_skip
	btr qword [rsp], 21

.Lis_cpuid_supported_skip:

	popfq

	mov  rax, 1
	pushfq
	test [rsp], r15
	jnz  .Lis_cpuid_supported_done
	mov  rax, 0

.Lis_cpuid_supported_done:

	mov [rsp], r15
	popfq
	ret
