.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC
extern wczytaj_EAX :PROC
;public _main


.data
	dekoder db '0123456789ABCDEF'


.code

wyswietl_EAX_hex PROC
; wyświetlanie zawartości rejestru EAX
; w postaci liczby szesnastkowej

	pusha ; przechowanie rejestrów


	sub esp, 12		; rezerwacja 12 bajtów na stosie (poprzez zmniejszenie rejestru ESP) przeznaczonych na tymczasowe przechowanie
					; cyfr szesnastkowych wyświetlanej liczby
	mov edi, esp	; adres zarezerwowanego obszaru pamięci

	; przygotowanie konwersji
	mov ecx, 8 ; liczba obiegów pętli konwersji
	mov esi, 1 ; indeks początkowy używany przy zapisie cyfr

	; pętla konwersji
	ptl3hex:

		rol eax, 4		; przesunięcie cykliczne (obrót) rejestru EAX o 4 bity w lewo w szczególności, w pierwszym obiegu pętli bity nr 31 - 28
						; rejestru EAX zostaną przesunięte na pozycje 3 - 0 wyodrębnienie 4 najmłodszych bitów i odczytanie z tablicy
						;'dekoder' odpowiadającej im cyfry w zapisie szesnastkowym
		mov ebx, eax ; kopiowanie EAX do EBX
		and ebx, 0000000FH ; zerowanie bitów 31 - 4 rej.EBX
		mov dl, dekoder[ebx] ; pobranie cyfry z tablicy

		; przesłanie cyfry do obszaru roboczego
		mov [edi][esi], dl
		inc esi ;inkrementacja modyfikatora

	loop ptl3hex ; sterowanie pętlą

	; wpisanie znaku nowego wiersza przed i po cyfrach
	mov byte PTR [edi][0], 10
	mov byte PTR [edi][9], 10

	;zmiana nieznaczacych zer na spacje
	mov ebx, 0
	zamien:
		inc ebx
		cmp byte ptr [edi][ebx], 30h
		jne wypisz
		mov byte PTR [edi][ebx], 20h
		jmp zamien


	wypisz:
		; wyświetlenie przygotowanych cyfr
		push 10 ; 8 cyfr + 2 znaki nowego wiersza
		push edi ; adres obszaru roboczego
		push 1 ; nr urządzenia (tu: ekran)
		call __write ; wyświetlenie

	add esp, 24		; usunięcie ze stosu 24 bajtów, w tym 12 bajtów zapisanych
					; przez 3 rozkazy push przed rozkazem call
					; i 12 bajtów zarezerwowanych na początku podprogramu

	popa ; odtworzenie rejestrów
	ret ; powrót z podprogramu
wyswietl_EAX_hex ENDP


;_main PROC

	call wczytaj_EAX
	call wyswietl_EAX_hex

	push 0
	call _ExitProcess@4
;_main ENDP
END
