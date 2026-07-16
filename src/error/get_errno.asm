extern errno

global get_errno

segment .text

get_errno:

	mov eax, dword [rel errno]

	ret
