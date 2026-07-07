#pragma once

#include "../utils/int.h"

typedef enum {
    STATE_NONE,
    STATE_SURFACE_ACK_CONFIGURED,
    STATE_SURFACE_ATTACHED,
} state_state_t;

typedef struct {
    uint32_t wl_registry;
    uint32_t wl_shm;
    uint32_t wl_shm_pool;
    uint32_t wl_buffer;
    uint32_t xdg_wm_base;
    uint32_t xdg_surface;
    uint32_t wl_compositor;
    uint32_t wl_surface;
    uint32_t xdg_toplevel;
    uint32_t stride;
    uint32_t w;
    uint32_t h;
    uint32_t shm_pool_size;
    int shm_fd;
    uint8_t *shm_pool_data;

    state_state_t state;
} state_t;
