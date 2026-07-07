extern int wayland_display_connect();
extern unsigned int wayland_wl_display_get_registry(int fd);
extern void *create_shared_memory_file(long int size);

int main(int argc, char *argv[]) {
    int fd = wayland_display_connect();
    unsigned int id = wayland_wl_display_get_registry(fd);
    void *memory = create_shared_memory_file(1024 * 1024);

    return 0;
}
