; wczytywanie i wyświetlanie tekstu wielkimi literami
; (inne znaki się nie zmieniają)


.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreślenia)
extern __read : PROC ; (dwa znaki podkreślenia)
public _main


.data
tekst_pocz	db 10, 'Proszę napisać liczbe '
			db 'i nacisnac Enter', 10
koniec_t db ?
magazyn db 800 dup (?)
liczba db 40 dup (?)
wynik dd 0
nowa_linia db 10
liczba_znakow dd ?


.code
_main	PROC

; wyświetlenie tekstu informacyjnego

	mov	ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)	; liczba znaków tekstu
	push	ecx
	push	OFFSET tekst_pocz		; adres tekstu
	push	1			; nr urządzenia (tu: ekran - nr 1)
	call	__write	; wyświetlenie tekstu początkowego
	add	esp, 12	; usuniecie parametrów ze stosu

; czytanie wiersza z klawiatury
	push 80		; maksymalna liczba znaków
	push OFFSET liczba
	push 0			; nr urządzenia (tu: klawiatura - nr 0)
	call __read	; czytanie znaków z klawiatury
	add esp, 12	; usuniecie parametrów ze stosu
; kody ASCII napisanej liczby trafia do liczba

; funkcja read wpisuje do rejestru EAX liczbę  wprowadzonych znaków
	mov liczba_znakow, eax
	mov eax, 0
	mov ebx, 10 ;wartosc mnozenia
	mov ecx, 1 ;mnoznik
	mov esi, liczba_znakow ;indeksy dla liczby
	mov edi, 0 ;miejsce na wynik, debug
	sub esi,1

ptl:
	mov al, liczba[esi-1]
	sub al, 30h
	mul ecx  ;

	add edi, eax
	mov eax, ecx
	mul ebx
	mov ecx, eax

	mov eax, 0
	dec esi
	cmp esi, 0
	ja ptl

	mov wynik, edi

	mov ebx, 0

loop1:
	mov magazyn[ebx], 31h
	inc ebx
	cmp edi, ebx
	ja loop1



; rejestr ECX pełni rolę licznika obiegów pętli
	mov ecx, eax
	mov ebx, 0 ; indeks początkowy

 ; wyświetlenie przekształconego tekstu
	push liczba_znakow
	push OFFSET magazyn
	push 1
	call __write	; wyświetlenie przekształconego tekstu
	add esp, 12	; usuniecie parametrów ze stosu
	push 0

 call _ExitProcess@4 ; zakończenie programu
_main ENDP
END
