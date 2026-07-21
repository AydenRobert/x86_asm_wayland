struc File
    .fd          resd 1
                 resd 1
    .char_buffer resq 1
    .buffer_len  resq 1
    .buffer_cap  resq 1
    .write       resq 1
    .read        resq 1
    .flush       resq 1
endstruc
