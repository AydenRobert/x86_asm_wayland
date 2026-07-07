%include "src/wayland/state.inc"

global wayland_state

segment .bss
    wayland_state: resb Wayland_State_size
