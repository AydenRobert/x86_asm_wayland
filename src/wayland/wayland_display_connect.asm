extern get_env
extern cstring_len
extern print
extern print_line
extern mem_cpy
extern _exit

segment .data

xdg_rd_env_var db "XDG_RUNTIME_DIR", 0
wayland_d_env_var db "WAYLAND_DISPLAY", 0
wayland_display_default db "wayland-0", 0

segment .text

global wayland_display_connect

	; int wayland_display_connect()

wayland_display_connect:
	push r12
	push r13
	push r14
	push r15
	push rbp

	mov rbp, rsp

	sub rsp, 110

	;    char *xdg_runtime_dir = get_env("XDG_RUNTIME_DIR")
	lea  rdi, [rel xdg_rd_env_var]
	call get_env

	;     if (xdg_runtime_dir == 0) return EINVAL
	test  rax, rax
	mov   r12, 22
	cmovz rax, r12
	jz    .ret

	mov r12, rax; r12 = xdg_runtime_dir

	;    xdg_runtime_dir_len = cstring_len(xdg_runtime_dir)
	mov  rdi, rax
	call cstring_len
	mov  r13, rax; r13 = xdg_runtime_dir_len

	;   addr = {.sun_family = AF_UNIX}
	mov dword [rsp], 1

	;    mem_cpy(addr.sun_path, xdg_runtime_dir, xdg_runtime_dir_len)
	lea  rdi, [rsp + 2]
	mov  rsi, r12
	mov  rdx, r13
	call mem_cpy

	;   socket_path_len = xdg_runtime_dir
	mov r15, r13; r13 is free

	;   addr.sun_path[socket_path_len++] = '/'
	mov byte [rsp + 2 + r15], 47
	inc r15

	;      char *wayland_display = get_env("WAYLAND_DISPLAY")
	lea    rdi, [rel wayland_d_env_var]
	call   get_env
	lea    r13, [rel wayland_display_default]; r13 = wayland_display
	test   rax, rax
	cmovnz r13, rax
	mov    r14, 9; r14 = wayland_display_len
	jz     .mem_cpy

	mov  rdi, rax
	call cstring_len
	mov  r14, rax

.mem_cpy:

	;    mem_cpy(addr.sun_path + socket_path_len, wayland_display, wayland_display_len)
	lea  rdi, [rsp + 2 + r15]
	mov  rsi, r13
	mov  rdx, r14
	call mem_cpy

	;   socket_path_len += wayland_display
	add r15, r14; r12-14 are free

	mov byte [rsp + 2 + r15], 0
	inc r15

	add r15, 2

	;   int fd = socket(AF_UNIX, SOCK_STREAM, 0)
	mov rax, 41; SYS_socket
	mov rdi, 1; AF_UNIX
	mov rsi, 1; SOCK_STREAM
	mov rdx, 0
	syscall

	cmp rax, 0
	jl  .exit

	mov r12, rax; r12 = fd

	;   connect(fd, addr, sizeof(addr))
	mov rdi, rax
	mov rax, 42; SYS_connect
	lea rsi, [rsp]
	mov rdx, r15
	syscall

	cmp rax, 0
	jl  .exit

	mov rax, r12

.ret:

	mov rsp, rbp

	pop rbp
	pop r15
	pop r14
	pop r13
	pop r12

	ret

.exit:

	mov  rdi, 1; TODO: figure out return codes
	call _exit
