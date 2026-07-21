extern file_write
extern file_flush

global stdout_file

segment .data

stdout_file:
	dd 1;          int     fd
	dd 0;          padding 
    dq 0;          char   *buffer
    dq 0;          size_t  buffer_len
    dq 0;          size_t  buffer_cap
	dq file_write; func    write
	dq 0;          func    read
    dq file_flush; func    flush
