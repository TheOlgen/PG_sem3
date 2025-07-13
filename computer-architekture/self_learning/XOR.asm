.686
.model flat

public _main
public _xor

.data

.code

_xor PROC
	mov ecx, 32
	nastepny:
		bt edi, ecx
		jc jedynka
			bt esi, ecx
			jc wpisz_jeden
			jmp wpisz_zero
		jedynka:
			bt esi, ecx
			jc wpisz_zero
			jmp wpisz_jeden
	wpisz_zero:
		btr edi, ecx
		jmp koniec
	wpisz_jeden:
		bts edi, ecx
		jmp koniec
	koniec:
		dec ecx
		jnz nastepny
_xor ENDP

_main PROC  
	mov esi, 11
	mov edi, 15
	call _xor
_main ENDP


.data


 END

