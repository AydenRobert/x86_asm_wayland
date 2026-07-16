extern errno

global set_errno

segment .text

	; void set_errno(int val)

set_errno:

	mov   esi, edi
	neg   esi
	cmp   edi, 0
	cmovl edi, esi
	mov   dword [rel errno], edi

	ret
