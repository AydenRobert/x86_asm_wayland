segment .bss

global paux
global aux_len

	;    auxv_t* paux
	paux resq 1
	;    unsigned long int aux_len
	aux_len resq 1
