; Program linie.asm
; Wyświetlanie znaków * w takt przerwań zegarowych
; Uruchomienie w trybie rzeczywistym procesora x86
; lub na maszynie wirtualnej
; zakończenie programu po naciśnięciu dowolnego klawisza
; asemblacja (MASM 4.0): masm gwiazdki.asm,,,;
; konsolidacja (LINK 3.60): link gwiazdki.obj;

.386

rozkazy	SEGMENT use16
		ASSUME cs:rozkazy


obsluga_zegara PROC
    ; Przechowanie rejestrów
    push ax
    push bx
    push es

    ; Ustawienie segmentu pamięci ekranu dla trybu graficznego 13h
    mov ax, 0A000h      ; Adres segmentu pamięci ekranu
    mov es, ax

    ; --- Rysowanie pierwszej przekątnej ---
    mov bx, cs:adres_piksela1   ; Załaduj bieżący adres piksela dla pierwszej przekątnej
    mov al, cs:kolor           ; Pobierz kolor piksela
    mov es:[bx], al            ; Wpisz piksel do pamięci ekranu

    ; Przesunięcie adresu na kolejny piksel (w prawo i w dół: +321)
    add cs:adres_piksela1, 321
    cmp cs:adres_piksela1, 321*200 ; Sprawdź, czy osiągnięto koniec ekranu
    jb przekatna1_koniec
        mov cs:adres_piksela1, 0 ; Zresetuj adres pierwszej przekątnej

przekatna1_koniec:

    ; --- Rysowanie drugiej przekątnej ---
    mov bx, cs:adres_piksela2   ; Załaduj bieżący adres piksela dla drugiej przekątnej
    mov al, cs:kolor           ; Pobierz kolor piksela
    mov es:[bx], al            ; Wpisz piksel do pamięci ekranu

    ; Przesunięcie adresu na kolejny piksel (w prawo i w górę: -319)
    sub cs:adres_piksela2, 319
    cmp cs:adres_piksela2, 0    ; Sprawdź, czy osiągnięto początek ekranu
    ja przekatna2_koniec
        mov cs:adres_piksela2, 320*199 ; Zresetuj adres drugiej przekątnej

przekatna2_koniec:

    ; Zmiana koloru co pewną ilość przerwań
    inc cs:licznik_kolor        ; Zwiększenie licznika
    cmp cs:licznik_kolor, 18    ; Co około 1 sekundę (18 przerwań)
    jb koniec
        inc cs:kolor            ; Zmiana koloru
        and cs:kolor, 0Fh       ; Ograniczenie koloru do 0-15
        mov cs:licznik_kolor, 0 ; Reset licznika koloru

koniec:
    ; Odtworzenie rejestrów
    pop es
    pop bx
    pop ax

    ; Skok do oryginalnej procedury obsługi przerwania zegarowego
    jmp dword PTR cs:wektor8

; Zmienne dla procedury
kolor            db 1             ; Aktualny kolor piksela
licznik_kolor    db 0             ; Licznik do zmiany koloru
adres_piksela1   dw 0             ; Adres bieżącego piksela dla pierwszej przekątnej
adres_piksela2   dw 320*199       ; Adres bieżącego piksela dla drugiej przekątnej (lewy dolny róg)
wektor8          dd ?             ; Oryginalna procedura przerwania zegarowego

obsluga_zegara ENDP



; INT 10H, funkcja nr 0 ustawia tryb sterownika graficznego
zacznij:
	mov ah, 0
	mov al, 13H ; nr trybu

	int 10H
	mov bx, 0
	mov es, bx ; zerowanie rejestru ES
	mov eax, es:[32] ; odczytanie wektora nr 8
	mov cs:wektor8, eax; zapamiętanie wektora nr 8

; adres procedury 'linia' w postaci segment:offset
	mov ax, SEG obsluga_zegara
	mov bx, OFFSET obsluga_zegara
	cli ; zablokowanie przerwań

; zapisanie adresu procedury 'linia' do wektora nr 8
	mov es:[32], bx
	mov es:[32+2], ax
	sti ; odblokowanie przerwań

	czekaj:
		mov ah, 1 ; sprawdzenie czy jest jakiś znak
		int 16h ; w buforze klawiatury
		jz czekaj

		mov ah, 0 ; funkcja nr 0 ustawia tryb sterownika
		mov al, 3H ; nr trybu
		int 10H

; odtworzenie oryginalnej zawartości wektora nr 8
	mov eax, cs:wektor8
	mov es:[32], eax

; zakończenie wykonywania programu
	mov ax, 4C00H
	int 21H
rozkazy ENDS
stosik SEGMENT stack
db 256 dup (?)
stosik ENDS

END zacznij
