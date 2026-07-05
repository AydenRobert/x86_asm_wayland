segment .data

global at_null_str
global at_ignore_str
global at_execfd_str
global at_phdr_str
global at_phent_str
global at_phnum_str
global at_pagesz_str
global at_base_str
global at_flags_str
global at_entry_str
global at_notelf_str
global at_uid_str
global at_euid_str
global at_gid_str
global at_egid_str
global at_platform_str
global at_hwcap_str
global at_clktck_str
global at_fpucw_str
global at_dcachebsize_str
global at_icachebsize_str
global at_ucachebsize_str
global at_ignorepcre_str
global at_secure_str
global at_base_platform_str
global at_random_str
global at_hwcap2_str
global at_rseq_feature_size_str
global at_rseq_align_str
global at_execfn_str
global at_sysinfo_str
global at_sysinfo_ehdr_str
global at_l1i_cachesize_str
global at_l1i_cachegeometry_str
global at_l1d_cachesize_str
global at_l1d_cachegeometry_str
global at_l2_cachesize_str
global at_l2_cachegeometry_str
global at_l3_cachesize_str
global at_l3_cachegeometry_str
global at_adi_blksz_str
global at_adi_nbits_str
global at_adi_ueonadi_str
global at_minsigstksz_str

global at_str_list

at_null_str              db "AT_NULL", 0
at_ignore_str            db "AT_IGNORE", 0
at_execfd_str            db "AT_EXECFD", 0
at_phdr_str              db "AT_PHDR", 0
at_phent_str             db "AT_PHENT", 0
at_phnum_str             db "AT_PHNUM", 0
at_pagesz_str            db "AT_PAGESZ", 0
at_base_str              db "AT_BASE", 0
at_flags_str             db "AT_FLAGS", 0
at_entry_str             db "AT_ENTRY", 0
at_notelf_str            db "AT_NOTELF", 0
at_uid_str               db "AT_UID", 0
at_euid_str              db "AT_EUID", 0
at_gid_str               db "AT_GID", 0
at_egid_str              db "AT_EGID", 0
at_platform_str          db "AT_PLATFORM", 0
at_hwcap_str             db "AT_HWCAP", 0
at_clktck_str            db "AT_CLKTCK", 0
at_fpucw_str             db "AT_FPUCW", 0
at_dcachebsize_str       db "AT_DCACHEBSIZE", 0
at_icachebsize_str       db "AT_ICACHEBSIZE", 0
at_ucachebsize_str       db "AT_UCACHEBSIZE", 0
at_ignorepcre_str        db "AT_IGNOREPPC", 0
at_secure_str            db "AT_SECURE", 0
at_base_platform_str     db "AT_BASE_PLATFORM", 0
at_random_str            db "AT_RANDOM", 0
at_hwcap2_str            db "AT_HWCAP2", 0
at_rseq_feature_size_str db "AT_RSEQ_FEATURE_SIZE", 0
at_rseq_align_str        db "AT_RSEQ_ALIGN", 0
at_execfn_str            db "AT_EXECFN", 0
at_sysinfo_str           db "AT_SYSINFO", 0
at_sysinfo_ehdr_str      db "AT_SYSINFO_EHDR", 0
at_l1i_cachesize_str     db "AT_L1I_CACHESIZE", 0
at_l1i_cachegeometry_str db "AT_L1I_CACHEGEOMETRY", 0
at_l1d_cachesize_str     db "AT_L1D_CACHESIZE", 0
at_l1d_cachegeometry_str db "AT_L1D_CACHEGEOMETRY", 0
at_l2_cachesize_str      db "AT_L2_CACHESIZE", 0
at_l2_cachegeometry_str  db "AT_L2_CACHEGEOMETRY", 0
at_l3_cachesize_str      db "AT_L3_CACHESIZE", 0
at_l3_cachegeometry_str  db "AT_L3_CACHEGEOMETRY", 0
at_adi_blksz_str         db "AT_ADI_BLKSZ", 0
at_adi_nbits_str         db "AT_ADI_NBITS", 0
at_adi_ueonadi_str       db "AT_ADI_UEONADI", 0
at_minsigstksz_str       db "AT_MINSIGSTKSZ", 0

; indexed by a_type, valid for 0..51
at_str_list:
    dq at_null_str               ;  0
    dq at_ignore_str             ;  1
    dq at_execfd_str             ;  2
    dq at_phdr_str               ;  3
    dq at_phent_str              ;  4
    dq at_phnum_str              ;  5
    dq at_pagesz_str             ;  6
    dq at_base_str               ;  7
    dq at_flags_str              ;  8
    dq at_entry_str              ;  9
    dq at_notelf_str             ; 10
    dq at_uid_str                ; 11
    dq at_euid_str               ; 12
    dq at_gid_str                ; 13
    dq at_egid_str               ; 14
    dq at_platform_str           ; 15
    dq at_hwcap_str              ; 16
    dq at_clktck_str             ; 17
    dq at_fpucw_str              ; 18
    dq 0                         ; 19
    dq 0                         ; 20
    dq 0                         ; 21
    dq 0                         ; 22
    dq at_secure_str             ; 23
    dq at_base_platform_str      ; 24
    dq at_random_str             ; 25
    dq at_hwcap2_str             ; 26
    dq at_rseq_feature_size_str  ; 27
    dq at_rseq_align_str         ; 28
    dq 0                         ; 29
    dq 0                         ; 30
    dq at_execfn_str             ; 31
    dq at_sysinfo_str            ; 32
    dq at_sysinfo_ehdr_str       ; 33
    dq 0                         ; 34
    dq 0                         ; 35
    dq 0                         ; 36
    dq 0                         ; 37
    dq at_l1i_cachesize_str      ; 38
    dq at_l1i_cachegeometry_str  ; 39
    dq at_l1d_cachesize_str      ; 40
    dq at_l1d_cachegeometry_str  ; 41
    dq at_l2_cachesize_str       ; 42
    dq at_l2_cachegeometry_str   ; 43
    dq at_l3_cachesize_str       ; 44
    dq at_l3_cachegeometry_str   ; 45
    dq at_adi_blksz_str          ; 46
    dq at_adi_nbits_str          ; 47
    dq at_adi_ueonadi_str        ; 48
    dq 0                         ; 49
    dq 0                         ; 50
    dq at_minsigstksz_str        ; 51
