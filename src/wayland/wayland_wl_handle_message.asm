%include "src/wayland/state.inc"

extern wayland_wl_registry_event_global
extern wayland_state

extern buf_read_u16
extern buf_read_u32
extern buf_read_n

segment .text

	; wayland_wl_handle_message(int fd, state_t *state, char **msg, uint64_t *msg_len)

wayland_wl_handle_message:

	push rbp

	mov rbp, rsp
	sub rsp, 16

	mov r8, rdi; r8 = fd
	mov r9, rsi; r9 = state
	mov r10, rdx; r10 = msg
	mov r11, rcx; r11 = msg_len

	mov  rdi, r10
	mov  rsi, r11
	call buf_read_u32

	mov dword [rsp], eax; [rsp] = object_id

	mov  rdi, r10
	mov  rsi, r11
	call buf_read_u16

	mov word [rsp + 4], ax; [rsp + 4] = opcode

	mov  rdi, r10
	mov  rsi, r11
	call buf_read_u16

	mov word [rsp + 6], ax; [rsp + 6] = announced_size

	mov eax, dword [rsp]
	mov edx, dword [rel wayland_state + Wayland_State.wl_registry]
	cmp eax, edx
	je  .wl_registry

	jmp .ret

.wl_registry:

	mov ax, word [rsp + 4]
	mov dx, word [rel wayland_wl_registry_event_global]
	cmp ax, dx

	je .handle_event_global

	jmp .ret

.handle_event_global:

	sub rsp, 528

	mov  rdi, r10
	mov  rsi, r11
	call buf_read_u32

	mov dword [rsp], eax; [rsp] = name

	mov  rdi, r10
	mov  rsi, r11
	call buf_read_u32

	mov dword [rsp + 4], eax; [rsp + 4] = interface_len

	add eax, 3
	and eax, -4
	mov dword [rsp + 8], eax; [rsp + 8] = padded_interface_len

	mov  rdi, r10
	mov  rsi, r11
	lea  rdx, [rsp + 16]; [rsp + 16] = interface (char[512])
	mov  rcx, [rsp + 8]
	call buf_read_n

	mov  rdi, r10
	mov  rsi, r11
    call buf_read_u32

    mov dword [rsp + 12], eax; [rsp + 12] = version

.ret:

	mov rsp, rbp
	pop rbp
	ret
