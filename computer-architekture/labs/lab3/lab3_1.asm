.686
.model flat
extern __write : PROC
extern _ExitProcess@4 : PROC
public _main


.data
znaki db 12 dup (?)


.code
wyswietl_EAX PROC
	push esi
	push ebx
	push edx
	push eax

	mov esi, 10 ; indeks w tablicy 'znaki'
	mov ebx, 10 ; dzielnik równy 10

konwersja:
	mov edx, 0 ; zerowanie starszej części dzielnej
	div ebx ; dzielenie przez 10, reszta w EDX, iloraz w EAX
	add dl, 30H ; zamiana reszty z dzielenia na kod ASCII
	mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
	dec esi ; zmniejszenie indeksu
	cmp eax, 0 ; sprawdzenie czy iloraz = 0
	jne konwersja ; skok, gdy iloraz niezerowy


; wypełnienie pozostałych bajtów spacjami i wpisanie znaków nowego wiersza
wypeln:
	or esi, esi
	jz wyswietl ; skok, gdy ESI = 0
	mov byte PTR znaki [esi], 20H ; kod spacji
	dec esi ; zmniejszenie indeksu
	jmp wypeln


wyswietl:
	mov byte PTR znaki [0], 0AH ; kod nowego wiersza
	mov byte PTR znaki [11], 0AH ; kod nowego wiersza

; wyświetlenie cyfr na ekranie
	push dword PTR 12 ; liczba wyświetlanych znaków
	push dword PTR OFFSET znaki ; adres wyśw. obszaru
	push dword PTR 1; numer urządzenia (ekran ma numer 1)
	call __write ; wyświetlenie liczby na ekranie
	add esp, 12 ; usunięcie parametrów ze stosu


	pop eax
	pop edx
	pop ebx
	pop esi

	ret
wyswietl_EAX ENDP


_main PROC
;wyswietlenie ciagu 1, 2, 4, 7, 11, 16, 22, 29 ....
	mov eax, 1   ;liczba którą bedziemy wyświetlać
	mov ebx, 1    ;licznik odliczajacy do 50

nastepny:
	call wyswietl_EAX
	add eax, ebx   ;dodanie licznika do liczby
	inc ebx   ;zwiekszenie licznika
	cmp ebx, 50     ;czy juz doszliśmy do 50 
	jbe nastepny
	
	push 0
	call _ExitProcess@4
_main ENDP

END
