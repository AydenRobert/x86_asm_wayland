	; typedef struct {
	; uint32_t wl_registry
	; uint32_t wl_shm
	; uint32_t wl_shm_pool
	; uint32_t wl_buffer
	; uint32_t xdg_wm_base
	; uint32_t xdg_surface
	; uint32_t wl_compositor
	; uint32_t wl_surface
	; uint32_t xdg_toplevel
	; uint32_t stride
	; uint32_t w
	; uint32_t h
	; uint32_t shm_pool_size
	; int      shm_fd
	; uint8_t *shm_pool_data

	; state_state_t state
	; } state_t

struc Wayland_State
    .wl_registry:   resd 1
    .wl_shm:        resd 1
    .wl_shm_pool:   resd 1
    .wl_buffer:     resd 1
    .xdg_wm_base:   resd 1
    .xdg_surface:   resd 1
    .wl_compositor: resd 1
    .wl_surface:    resd 1
    .xdg_toplevel:  resd 1
    .stride:        resd 1
    .w:             resd 1
    .h:             resd 1
    .shm_pool_size: resd 1
    .shm_fd:        resd 1
    .shm_pool_data: resd 1
    .state:         resd 1
    .padding:       resd 1
endstruc

segment .bss
    wayland_state: resb Wayland_State_size
