extern errno

global get_errno

segment .text

get_errno:

	mov rax, [rel errno]

	ret
