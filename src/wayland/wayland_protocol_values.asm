segment .data
global  wayland_display_object_id
global  wayland_wl_registry_event_global
global  wayland_shm_pool_event_format
global  wayland_wl_buffer_event_release
global  wayland_xdg_wm_base_event_ping
global  wayland_xdg_toplevel_event_configure
global  wayland_xdg_toplevel_event_close
global  wayland_xdg_surface_event_configure
global  wayland_wl_display_get_registry_opcode
global  wayland_wl_registry_bind_opcode
global  wayland_wl_compositor_create_surface_opcode
global  wayland_xdg_wm_base_pong_opcode
global  wayland_xdg_surface_ack_configure_opcode
global  wayland_wl_shm_create_pool_opcode
global  wayland_xdg_wm_base_get_xdg_surface_opcode
global  wayland_wl_shm_pool_create_buffer_opcode
global  wayland_wl_surface_attach_opcode
global  wayland_xdg_surface_get_toplevel_opcode
global  wayland_wl_surface_commit_opcode
global  wayland_wl_display_error_event
global  wayland_format_xrgb8888
global  wayland_header_size
global  color_channels

wayland_display_object_id                   dd 1
wayland_wl_registry_event_global            dw 0
wayland_shm_pool_event_format               dw 0
wayland_wl_buffer_event_release             dw 0
wayland_xdg_wm_base_event_ping              dw 0
wayland_xdg_toplevel_event_configure        dw 0
wayland_xdg_toplevel_event_close            dw 1
wayland_xdg_surface_event_configure         dw 0
wayland_wl_display_get_registry_opcode      dw 1
wayland_wl_registry_bind_opcode             dw 0
wayland_wl_compositor_create_surface_opcode dw 0
wayland_xdg_wm_base_pong_opcode             dw 3
wayland_xdg_surface_ack_configure_opcode    dw 4
wayland_wl_shm_create_pool_opcode           dw 0
wayland_xdg_wm_base_get_xdg_surface_opcode  dw 2
wayland_wl_shm_pool_create_buffer_opcode    dw 0
wayland_wl_surface_attach_opcode            dw 1
wayland_xdg_surface_get_toplevel_opcode     dw 1
wayland_wl_surface_commit_opcode            dw 6
wayland_wl_display_error_event              dw 0
wayland_format_xrgb8888                     dd 1
wayland_header_size                         dd 8
color_channels                              dd 4
