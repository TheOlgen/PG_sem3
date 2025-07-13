.686
.model flat

public _main
extern _MessageBoxW@16 : PROC
extern _MessageBoxA@16 : PROC
extern _ExitProcess@4 : PROC
Comment |
W 48-bajtowej tablicy bufor znajduje się tekst np. "Połączenia kolejowo – autobusowe"
zakodowany w formacie UTF-8. W tekście występują także symbole parowozu i autobusu. 
Napisać program w asemblerze, który wyświetli ten tekst na ekranie w postaci komunikatu typu MessageBoxW. 
W poniższej tablicy występują ciągi UTF-8  1-, 2-, 3 i 4-bajtowe
| 


.data

.code
_main PROC  
	mov esi,0   ; wskaznik odczytu
	mov edi,0   ; wskaznik zapisu	
	mov ecx,48   ; liczba bajtów do interpretacji z bufora
etykieta:
	mov eax, 0
	movzx ax, bufor[esi]
	add esi,1
	cmp al,7Fh     ;   <00 - 7fh> - znak w utf-8 jest jednobajtowy
	ja znak_wielobajtowy
; analiza jednobajtowego znaku utf-8
	mov output[edi],ax
	add edi,2
	jmp koniec

znak_wielobajtowy:
	BT eax,5   ; sprawdzenie czy znak jest 2 lub więcej bajtowy
	jc _3_lub_4_bajtowy_znak_utf8
	; znak jest dwubajtowy
	shl ax,8    ; przesyłamy starszą część znaku do ah
	mov al,bufor[esi]  ; odczytujemy młodszą część znaku tj. 10xx xxxx
	add esi,1
	shl al,2	; sklejamy obie części
	shl ax,3
	shr ax,5	; mamy gotowy znak utf-16, który zapisujemy
	mov output[edi],ax
	add edi,2
	jmp koniec	

_3_lub_4_bajtowy_znak_utf8:
	bt eax,4   ; sprawdzenie czy znak jest 3 czy 4 bajtowy
	jc _4_znakowy_utf_8
; tutaj znak 3 bajtowy
	shl eax,16		
	mov ah,bufor[esi]  ; odczyt młodszych bajtów do ax
	mov al,bufor[esi+1]
	add esi,2
	shl al,2		; posklejanie bitów
	shl ax,2
	shr eax,4
	mov output[edi],ax  ; zapis
	add edi,2
	jmp koniec	


_4_znakowy_utf_8:
; --------- TUTAJ NALEŻY DODAĆ OBSŁUGĘ 4 BAJTOWEGO ZNAKU UTF-8
; USTAWIENIE PREFIKSÓW W UTF-6 MOŻNA OTRZYMAĆ DODAJĄC DO 
; EAX WARTOŚĆ  11011000000000001101110000000000b  (wartość wyrażona w systemie dwójkowym - b na końcu)

	shl ax,8    ; przesyłamy starszą część znaku do ah
	mov al,bufor[esi]
	mov ebx, 0
	mov bh,bufor[esi+1]  ; odczyt młodszych bajtów do ax
	mov bl,bufor[esi+2]
	add esi, 3

	shl al,2 ;wydobycie wartości Unicode 
	shl ax, 5
	shl bl,2
	shl bx, 2

	shl eax, 9
	mov ax, bx
	shr eax,4

	sub eax, 10000h
	shl eax, 6
	shr ax, 6

	add eax, 11011000000000001101110000000000b
	
	mov ebx, eax
	shr ebx, 16
	mov output[edi],bx  ; zapis
	add edi,2
	mov output[edi],ax
	add edi,2
	jmp koniec	


koniec:
	dec ecx
	jnz etykieta

  ;  mov al,byte ptr b[1]
  ;	mov al,l_c[1]
  ;   mov al,ah
	push 4	 ; uint MB_YESNO
	push OFFSET tytul
	push OFFSET output
	push 0	 ; HWND
	call _MessageBoxW@16
	mov ax,[l_v]
	push 0
	call _ExitProcess@4
_main ENDP


.data
 tekst db  'C',0,'z',0,'y',0
 l_v   dw  '01',3031h
 tytul dw  'P','y','t','a','n','i','e',0

 liczba db 10,10h, 0FFh
l_c db 0
 db 1
 db 0,1
 dw 1
 dd 2
_bf dq 1122334455667788h
  db 88h,77h,66h,55h
  db 128 dup (' ')
  ; bufor ze znakami wejściowymi w utf-8
bufor	db	50H, 6FH, 0C5H, 82H, 0C4H, 85H, 63H, 7AH, 65H, 6EH, 69H, 61H, 20H 
		db	0F0H, 9FH, 9AH, 82H   ; parowóz
		db	20H, 20H, 6BH, 6FH, 6CH, 65H, 6AH, 6FH, 77H, 6FH, 20H
		db	0E2H, 80H, 93H ; półpauza
		db	20H, 61H, 75H, 74H, 6FH, 62H, 75H, 73H, 6FH, 77H, 65H, 20H, 20H
		db	0F0H,  9FH,  9AH,  8CH ; autobus

output  dw 48 dup (?)

 END


