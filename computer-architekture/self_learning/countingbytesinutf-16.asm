.686
.model flat

public _main

.data
stale dw 2, 1
napis dw 10 dup (3), 2
tekst	db	50H, 6FH, 0C5H, 82H, 0C4H, 85H, 63H, 7AH, 65H, 6EH, 69H, 61H, 20H 
		db	20H, 20H, 6BH, 6FH, 6CH, 65H, 6AH, 6FH, 77H, 6FH, 20H
		db	0E2H, 80H, 93H ; półpauza
		db	20H, 61H, 75H, 74H, 6FH, 62H, 75H, 73H, 6FH, 77H, 65H, 20H, 20H


.code


_main PROC  
	mov esi,0
	mov ecx, 0
	mov edx, 0
	nastepny_znak:
		mov dl, tekst[esi];
		cmp dl, 0
		je koniec
		rol dl, 1
		jc jedynka
		inc ecx
		inc esi
		jmp nastepny_znak
		jedynka:
			rol dl, 2
			jc bajty3
			inc ecx
			add esi, 2
			jmp nastepny_znak
			bajty3:
				inc ecx
				add esi, 3
				jmp nastepny_znak
	koniec:
		add ecx, ecx
_main ENDP


 END
