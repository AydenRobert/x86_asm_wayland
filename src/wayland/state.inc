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
    .shm_pool_data: resq 1
    .state:         resd 1
    .padding:       resd 1
endstruc

