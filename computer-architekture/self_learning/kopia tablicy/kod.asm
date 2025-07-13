.686
.model flat

public _kopia_tablicy
extern _malloc : PROC

.code

_kopia_tablicy PROC
	push ebp
	mov ebp,esp
	push esi 
	push ebx
		
		mov esi, [ebp+8] ;adres tablicy wejsciowej
		mov ecx, [ebp + 12] ;ilosc elementow

		mov eax, 4
		imul ecx
		push eax
		call _malloc ;stworzenie tablicy, adres w eax
		sub esp, 4
		cmp eax, 0
		je koniec

		mov ecx, [ebp + 12] ;ilosc elementow
		mov ebx, 0 ; indeks do poruszania sie po tablicach
		nastepny:
			mov edx, [esi + 4*ebx] ;w edx nasza liczba
			bt edx, 0
			jnc zero
				mov edx, 0
			zero:
				mov [eax + 4*ebx], edx

			inc esi
			loop nastepny

	koniec:		
	pop ebx
	pop esi
	pop ebp
	ret
_kopia_tablicy ENDP

END
