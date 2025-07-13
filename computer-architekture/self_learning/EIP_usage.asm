.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC
extern wczytaj_EAX :PROC
extern wyswietl_EAX_hex :PROC
public _main


.code

check_and_replace PROC ;sprawdza jaka jest nastepna instrukcja i ją modyfikuje jęsli to mov albo loop
	pop ebx ;adres powrotu
	mov esi, 0
	mov eax, 0

	mov eax, [ebx] ;adres nastepnego rozkazu

	cmp al, 66h
	jne bez_przedrostka
	shl eax, 8
	mov al, [ebx+2]
	inc ebx

	bez_przedrostka:
		cmp ah, 88h ;jesli jest mniejsze od 
		jb nie_mov
		cmp ah, 8Bh
		ja nie_mov
			or ax, 0200h

		nie_mov:
		cmp ah, 0E3h
		jne koniec
		mov al, [ebx+2]

	koniec:
	mov eax, edx
	mov word ptr [ebx], ax
	push ebx
	ret

check_and_replace ENDP


sum_and_skip PROC ;sumuje wartości worda za wywołaniem funkcji
	pop ebx
	mov eax, 0
	looop:
		movsx edx, word ptr [ebx]
		cmp dl, 90h ;zatrzynamnie na instrukcji nop
		je koniec
		add ebx, 2
		add eax, edx
		jmp looop

	koniec:
		push ebx
		ret

sum_and_skip ENDP


_main PROC


	;call check_and_replace
	mov eax, ecx
	nop

	call sum_and_skip
	dw 0fff3h
	dw 43h
	dw 55h
	dw 103h
	nop

	call wyswietl_EAX_hex

	push 0
	call _ExitProcess@4
_main ENDP
END
