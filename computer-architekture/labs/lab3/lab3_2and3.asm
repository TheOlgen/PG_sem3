.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC
extern wyswietl_EAX : PROC
public _main

; wczytywanie liczby dziesiętnej z klawiatury – po
; wprowadzeniu cyfr należy nacisnąć klawisz Enter
; liczba po konwersji na postać binarną zostaje wpisana
; do rejestru EAX


.data
	obszar db 12 dup (?)
	dziesiec dd 10 ; mnożnik



.code

wczytaj_EAX PROC
	push ebx
	push ecx


	push dword PTR 12		; max ilość znaków wczytywanej liczby
	push dword PTR OFFSET obszar ; adres obszaru pamięci
	push dword PTR 0; numer urządzenia (0 dla klawiatury)
	call __read ; odczytywanie znaków z klawiatury
	add esp, 12 ; usunięcie parametrów ze stosu


; bieżąca wartość przekształcanej liczby przechowywana jest w rejestrze EAX; przyjmujemy 0 jako wartość początkową
	mov eax, 0
	mov ebx, OFFSET obszar ; adres obszaru ze znakami

pobieraj_znaki:
	mov cl, [ebx] ; pobranie kolejnej cyfry w kodzie ASCII
	inc ebx		; zwiększenie indeksu

	cmp cl,10	; sprawdzenie czy naciśnięto Enter
	je byl_enter	; skok, gdy naciśnięto Enter
	sub cl, 30H		; zamiana kodu ASCII na wartość cyfry
	movzx ecx, cl	; przechowanie wartości cyfry w rejestrze ECX

	mul dword PTR dziesiec  ; mnożenie wcześniej obliczonej wartości razy 10
	add eax, ecx	; dodanie ostatnio odczytanej cyfry
	jmp pobieraj_znaki ; skok na początek pętli


byl_enter:
; wartość binarna wprowadzonej liczby znajduje się teraz w rejestrze EAX

	pop ecx
	pop ebx
	ret
wczytaj_EAX ENDP


_main PROC
	call wczytaj_EAX
	cmp eax, 6000
	ja nic_nie_rob
	mul eax
	call wyswietl_EAX

	nic_nie_rob:
	
	push 0
	call _ExitProcess@4
_main ENDP
END
