#include "wayland/state.h"
#include "wayland/wayland_protocol_values.h"

extern int wayland_display_connect();
extern unsigned int wayland_wl_display_get_registry(int fd);
extern void *create_shared_memory_file(long int size);

extern size_t recv(int sockfd, void *buf, size_t size, int flags);

int main(int argc, char *argv[]) {
    int fd = wayland_display_connect();

    wayland_state = (state_t){
        .wl_registry = wayland_wl_display_get_registry(fd),
        .w = 117,
        .h = 150,
        .stride = 117 * color_channels,
    };

    wayland_state.shm_pool_size = wayland_state.h * wayland_state.stride;

    create_shared_memory_file(1024 * 1024);

    while (1) {
        char read_buf[4096] = "";
        int64_t read_bytes = recv(fd, read_buf, sizeof(read_buf), 0);
        if (read_bytes < 0) {
            _exit(1);
        }
    }

    return 0;
}
