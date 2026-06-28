extern void print(char *str, int len);
extern int wayland_display_connect();
extern void mem_cpy(void *dst, void *src, unsigned long len);
extern int li_str(long int num, char *buffer, int buffer_len);

int main(int argc, char *argv[]) {
    int fd = wayland_display_connect();
    char fd_str[20];
    int fd_str_len = li_str(fd, fd_str, 20);
    print(fd_str, fd_str_len);
    print("\n", 1);
    return 0;
}
