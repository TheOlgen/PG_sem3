; Program gwiazdki.asm
; Wyświetlanie znaków * w takt przerwań zegarowych każde w kolejnej linii

.386

rozkazy SEGMENT use16
		ASSUME CS:rozkazy

;============================================================

; procedura obsługi przerwania zegarowego
obsluga_zegara PROC
	; przechowanie używanych rejestrów
	push ax
	push bx
	push es

	; wpisanie adresu pamięci ekranu do rejestru ES - pamięć
	; ekranu dla trybu tekstowego zaczyna się od adresu B8000H,
	; jednak do rejestru ES wpisujemy wartość B800H,
	; bo w trakcie obliczenia adresu procesor każdorazowo mnoży
	; zawartość rejestru ES przez 16
	mov ax, 0B800h ;adres pamięci ekranu
	mov es, ax

	; zmienna licznik zawiera adres biezacy w pamieci ekranu
	mov bx, cs:licznik

	mov byte ptr es:[bx], '*'
	mov al, cs:kolor
	mov byte ptr es:[bx+1], al

	cmp cs:kolor, byte ptr 128
	jb dodaj

	mov cs:kolor, 1
	jmp nieDodaj

	dodaj:
		add cs:kolor, byte ptr 1

	nieDodaj:
		; w bx znajduje sie wskaznik na odpowiednia kolumne i wiersz
		add bx, 160

		; jezeli przechodzimy do kolejnej kolumny
		mov ax, cs:licznik_wierszy
		cmp ax, 25
		jb dalej

		add cs:plus, word ptr 2

		mov bx, cs:plus
		mov cs:licznik_wierszy, word ptr 1
		jmp sprawdz

	dalej:
		inc ax
		mov cs:licznik_wierszy, ax

	sprawdz:
		cmp bx, 4000
		jb wysw_dalej

		mov bx, 0 ; wyzerowanie adresu biezacego gdy caly ekran zapisany

	wysw_dalej:
		mov cs:licznik, bx ; adres biezacy w liczniku

	pop es
	pop bx
	pop ax
	jmp dword ptr cs:wektor8

; wyswietlanie poczawszy od 0 wiersza
licznik dw 0
wektor8 dd ?
plus dw 0
licznik_wierszy dw 1
kolor db 1

obsluga_zegara ENDP

;============================================================


; program główny - instalacja i deinstalacja procedury obsługi przerwań
; ustalenie strony nr 0 dla trybu tekstowego
zacznij:
	mov al, 0
	mov ah, 5
	int 10
	mov ax, 0
	mov ds,ax ; zerowanie rejestru DS

; odczytanie zawartości wektora nr 8 i zapisanie go w zmiennej 'wektor8' (wektor nr 8 zajmuje w pamięci 4 bajty
; począwszy od adresu fizycznego 8 * 4 = 32)
	mov eax,ds:[32] ; adres fizyczny 0*16 + 32 = 32
	mov cs:wektor8, eax

; wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara'
	mov ax, SEG obsluga_zegara ; część segmentowa adresu
	mov bx, OFFSET obsluga_zegara ; offset adresu
	cli ; zablokowanie przerwań

; zapisanie adresu procedury do wektora nr 8
	mov ds:[32], bx ; OFFSET
	mov ds:[34], ax ; cz. segmentowa
	sti ;odblokowanie przerwań

; oczekiwanie na naciśnięcie klawisza 'x'
aktywne_oczekiwanie:
	mov ah,1
	int 16H
; funkcja INT 16H (AH=1) BIOSu ustawia ZF=1 jeśli naciśnięto jakiś klawisz
	jz aktywne_oczekiwanie

; odczytanie kodu ASCII naciśniętego klawisza (INT 16H, AH=0) do rejestru AL
	mov ah, 0
	int 16H
	cmp al, 'x' ; porównanie z kodem litery 'x'
	jne aktywne_oczekiwanie ; skok, gdy inny znak

; deinstalacja procedury obsługi przerwania zegarowego
; odtworzenie oryginalnej zawartości wektora nr 8
	mov eax, cs:wektor8
	cli
	mov ds:[32], eax ; przesłanie wartości oryginalnej do wektora 8 w tablicy wektorów przerwań
	sti

; zakończenie programu
	mov al, 0
	mov ah, 4CH
	int 21H
	rozkazy ENDS
	nasz_stos SEGMENT stack
	db 128 dup (?)
	nasz_stos ENDS
END zacznij
