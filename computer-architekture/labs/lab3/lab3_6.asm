.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC
extern wyswietl_EAX :PROC
public _main


.data
	dekoder db '0123456789ABCDEF'


.code

wczytaj_do_EAX_hex PROC
; wczytywanie liczby szesnastkowej z klawiatury – liczba po konwersji na postać binarną zostaje wpisana do rejestru EAX
; po wprowadzeniu ostatniej cyfry należy nacisnąć klawisz Enter
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp

	sub esp, 12 ; rezerwacja 12 bajtów na stosie przeznaczonych na tymczasowe
				; przechowanie cyfr szesnastkowych wyświetlanej liczby rezerwacja poprzez zmniejszenie ESP
	mov esi, esp ; adres zarezerwowanego obszaru pamięci


	push dword PTR 10 ; max ilość znaków wczytyw. liczby
	push esi ; adres obszaru pamięci
	push dword PTR 0; numer urządzenia (0 dla klawiatury)
	call __read ; odczytywanie znaków z klawiatury
	add esp, 12 ; usunięcie parametrów ze stosu


	mov eax, 0 ; dotychczas uzyskany wynik

	pocz_konw:
		mov dl, [esi] ; pobranie kolejnego bajtu
		inc esi ; inkrementacja indeksu

		cmp dl, 10 ; sprawdzenie czy naciśnięto Enter
		je gotowe ; skok do końca podprogramu

		cmp dl, '0'	; sprawdzenie czy wprowadzony znak jest cyfrą 0, 1, 2 , ..., 9
		jb pocz_konw ; inny znak jest ignorowany

		cmp dl, '9'
		ja sprawdzaj_dalej

		sub dl, '0' ; zamiana kodu ASCII na wartość cyfry
		dopisz:
			shl eax, 4 ; przesunięcie logiczne w lewo o 4 bity
			or al, dl ; dopisanie utworzonego kodu 4-bitowego na 4 ostatnie bity rejestru EAX
			jmp pocz_konw ; skok na początek pętli konwersji

			sprawdzaj_dalej:  ; sprawdzenie czy wprowadzony znak jest cyfrą A, B, ..., F
				cmp dl, 'A'
				jb pocz_konw ; inny znak jest ignorowany

				cmp dl, 'F'
				ja sprawdzaj_dalej2

				sub dl, 'A' - 10 ; wyznaczenie kodu binarnego
				jmp dopisz

			sprawdzaj_dalej2:  ; sprawdzenie czy wprowadzony znak jest cyfrą a, b, ..., f
				cmp dl, 'a'
				jb pocz_konw ; inny znak jest ignorowany
				cmp dl, 'f'
				ja pocz_konw ; inny znak jest ignorowany
				sub dl, 'a' - 10
				jmp dopisz

	gotowe:
		; zwolnienie zarezerwowanego obszaru pamięci
		add esp, 12
		pop ebp
		pop edi
		pop esi
		pop edx
		pop ecx
		pop ebx
	ret
wczytaj_do_EAX_hex ENDP


_main PROC

	call wczytaj_do_EAX_hex
	call wyswietl_EAX

	push 0
	call _ExitProcess@4
_main ENDP
END
