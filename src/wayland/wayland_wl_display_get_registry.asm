extern buf_write_u32
extern buf_write_u16

extern wayland_display_object_id
extern wayland_wl_display_get_registry_opcode
extern wayland_header_size

extern _exit

extern print
extern print_li
extern print_line

segment .data
global  wayland_current_id
wayland_current_id dd 1

prstr1 db "-> wl_display@"
prstr2 db ".get_registry: wl_registry="

segment .text
global  wayland_wl_display_get_registry

	; unsigned int wayland_wl_display_get_registry(int fd)

wayland_wl_display_get_registry:

	push r12

	push rbp
	mov  rbp, rsp

	mov r12d, edi

	;   u64 msg_size = 0
	;   char msg[128] = ""
	sub rsp, 136
	and rsp, -16; align stack for function calling
	mov qword [rsp], 0; [rsp] = msg_size
	mov byte [rsp + 8], 0; [rsp + 8] = msg

	;    buf_write_u32(msg, &msg_size, sizeof(msg), wayland_display_object_id)
	lea  rdi, [rsp + 8]
	lea  rsi, [rsp]
	mov  rdx, 128
	mov  ecx, [rel wayland_display_object_id]
	call buf_write_u32

	;    buf_write_u16(msg, &msg_size, sizeof(msg), wayland_wl_display_get_registry_opcode)
	lea  rdi, [rsp + 8]
	lea  rsi, [rsp]
	mov  rdx, 128
	mov  cx, [rel wayland_wl_display_get_registry_opcode]
	call buf_write_u16

	;   u16 msg_announced_size = wayland_header_size + sizeof(wayland_current_id)
	mov cx, word [rel wayland_header_size]
	add cx, 4

	;    buf_write_u16(msg, &msg_size, sizeof(msg), msg_announced_size)
	lea  rdi, [rsp + 8]
	lea  rsi, [rsp]
	mov  rdx, 128
	call buf_write_u16

	;   wayland_current_id++
	inc [rel wayland_current_id]

	;    buf_write_u32(msg, &msg_size, sizeof(msg), wayland_current_id)
	lea  rdi, [rsp + 8]
	lea  rsi, [rsp]
	mov  rdx, 128
	mov  ecx, dword [rel wayland_current_id]
	call buf_write_u32

	;   send(fd, msg, msg_size, MSG_DONTWAIT)
	mov eax, 44
	mov edi, r12d; int fd
	lea rsi, [rsp + 8]; char *msg
	mov rdx, [rsp]; size_t len
	mov r10d, 0x40; int flags = MSG_DONTWAIT
	xor r8d, r8d
	xor r9d, r9d
	syscall

	;   if (msg_size != send(...)) exit(errno)
	cmp rax, [rsp]
	jne .exit

	lea  rdi, [rel prstr1]
	mov  rsi, 14
	call print

	mov  rdi, [rel wayland_display_object_id]
	call print_li

	lea  rdi, [rel prstr2]
	mov  rsi, 27
	call print

	mov  edi, dword [rel wayland_current_id]
	call print_li

	call print_line

	mov eax, dword [rel wayland_current_id]

	mov rsp, rbp
	pop rbp

	pop r12

	ret

.exit:

	mov  rdi, 1
	call _exit
