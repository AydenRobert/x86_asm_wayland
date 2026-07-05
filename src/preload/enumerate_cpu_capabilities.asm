extern _exit

extern is_cpuid_supported

segment .data

global instruction_set_bits
instruction_set_bits dq 0

segment .text

global enumerate_cpu_capabilities

	; void enumerate_cpu_capabilities()

enumerate_cpu_capabilities:

	call is_cpuid_supported

	mov eax, 0x7
	xor ecx, ecx
	cpuid

	mov    rdx, 0x1
	xor    rcx, rcx
	test   ebx, 5
	cmovnz rcx, rdx
	or     qword [rel instruction_set_bits], rcx

	mov    rdx, 0x2
	xor    rcx, rcx
	test   ebx, 16
	cmovnz rcx, rdx
	or     qword [rel instruction_set_bits], rcx

	ret

.Lenumerate_cpu_capabilities_exit:

	mov  rdi, 1
	call _exit
