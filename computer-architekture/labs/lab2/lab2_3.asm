; Przykład wywoływania emotek w message box
.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxA@16 : PROC
extern _MessageBoxW@16 : PROC
public _main

.data
tytul_Unicode	dw 'T','e','k','s','t',' ','w',' '
				dw 'f','o','r','m','a','c','i','e',' '
				dw 'U','T','F','-','1','6', 0
tekst_Unicode	dw 'K','o','w','b','o','j',' ',0D83EH, 0DD20H,' ', 'i',' '
				dw 'n','e','r','d',' ',0D83EH, 0DD13H, 0


.code
_main PROC

 push	0	; stala MB_OK
 push	OFFSET tytul_Unicode	; adres obszaru zawierającego tytuł
 push	OFFSET tekst_Unicode	; adres obszaru zawierającego tekst
 push	0		; NULL
 call	_MessageBoxW@16

 push	0	; kod powrotu programu
 call _ExitProcess@4

_main ENDP
END
