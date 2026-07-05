segment .bss

global ppenv
global env_len

	;     char** penv
	ppenv resq 1
	;     unsigned long int
	env_len resq 1
