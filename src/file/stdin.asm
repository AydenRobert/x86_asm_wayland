extern file_read

global stdin_file

segment .data

stdin_file:
	dd 0;          int     fd
	dd 0;          padding 
    dq 0;          char   *buffer
    dq 0;          size_t  buffer_len
    dq 0;          size_t  buffer_cap
	dq 0;          func    write
	dq file_read;  func    read
    dq 0;          func    flush
