extern void print(char *str, int len);
extern void print_line();
extern void print_li(long int x);
extern int wayland_display_connect();

extern unsigned int wayland_wl_display_get_registry(int fd);

int main(int argc, char *argv[]) {
    int fd = wayland_display_connect();
    unsigned int id = wayland_wl_display_get_registry(fd);
    return 0;
}
