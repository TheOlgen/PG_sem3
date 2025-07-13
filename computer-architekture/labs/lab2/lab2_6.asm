; wczytywanie i wyświetlanie tekstu wielkimi literami
; (inne znaki się nie zmieniają)


.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxA@16 : PROC
extern __write : PROC ; (dwa znaki podkreślenia)
extern __read : PROC ; (dwa znaki podkreślenia)
public _main


.data
tekst_pocz	db 10, 'Proszę napisać jakiś tekst '
			db 'i nacisnac Enter', 10
koniec_t db ?
magazyn db 80 dup (?)
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
	push OFFSET magazyn
	push 0			; nr urządzenia (tu: klawiatura - nr 0)
	call __read	; czytanie znaków z klawiatury
	add esp, 12	; usuniecie parametrów ze stosu
; kody ASCII napisanego tekstu zostały wprowadzone do obszaru 'magazyn'

; funkcja read wpisuje do rejestru EAX liczbę  wprowadzonych znaków
	mov liczba_znakow, eax

; rejestr ECX pełni rolę licznika obiegów pętli
	mov ecx, eax
	mov ebx, 0 ; indeks początkowy

ptl: mov dl, magazyn[ebx] ; pobranie kolejnego znaku

	cmp dl, 0A5H 
	je aogonek
	cmp dl, 086H 
	je ckreska
	cmp dl, 0A9H 
	je eogonek
	cmp dl, 88H
	je logonek
	cmp dl, 0E4H
	je nkreska
	cmp dl, 0A2H
	je okreska
	cmp dl, 98H
	je skreska
	cmp dl, 0ABH
	je zkreska
	cmp dl, 0BEH
	je zkropka

	cmp dl, 'a'
	jb dalej		; skok, gdy znak ma mniejsza wartosc niz a
	cmp dl, 'z'
	ja dalej		; skok, gdy znak ma wieksza wartosc niz z

	sub dl, 20H			; zamiana na wielkie litery
wpisz:	mov magazyn[ebx], dl	; odesłanie znaku do pamięci
	jmp dalej

aogonek: 	
		mov magazyn[ebx], 165
		jmp dalej
eogonek: 	
		mov magazyn[ebx], 202
		jmp dalej
logonek: 	
		mov magazyn[ebx], 163
		jmp dalej
ckreska: 	
		mov magazyn[ebx], 198
		jmp dalej
nkreska: 	
		mov magazyn[ebx], 209
		jmp dalej
okreska: 	
		mov magazyn[ebx], 211
		jmp dalej
skreska: 	
		mov magazyn[ebx], 140
		jmp dalej
zkreska: 	
		mov magazyn[ebx], 143
		jmp dalej
zkropka: 	
		mov magazyn[ebx], 175
		jmp dalej


dalej: inc ebx ; inkrementacja indeksu
	dec ecx
	jnz ptl


 ; wyświetlenie przekształconego tekstu
wypisanie:
	 mov magazyn[ebx], 0
	 push 0
	 push OFFSET magazyn
	 push OFFSET magazyn
	 push 0
	 call _MessageBoxA@16

 call _ExitProcess@4 ; zakończenie programu
_main ENDP
END
