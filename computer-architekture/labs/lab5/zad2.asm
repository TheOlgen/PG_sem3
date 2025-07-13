.686
.model flat

public _nowy_exp
.data
	jeden dd 1.0

.code
_nowy_exp PROC
	push ebp
	mov ebp, esp	
	push edi
	finit
	fldz

	mov ecx, 20 ; liczba elementów ciągu 
	mov eax, 1 ;do wyliczania dzielenia
	mov edi, 1 ;indeks do poruszania sie

	fld jeden
	fld dword ptr [ebp + 8] ; załadowanie x na st
	fst st(2); sytuacja: st0=x, st1=1, st2=x

	dec ecx
	ptl:
		imul edi; mnożenie eax razy edi
		push eax
		fild dword PTR [esp] ;st0=eax st1=x st2=1 st3=x
		add esp, 4

		fdivp ;st0=x/eax st1=1 st2=x
		faddp ;st0=1+x/eax st1=x

		fxch
		fmul dword ptr [ebp + 8]
		fxch
		fld st(1)

		inc edi
		loop ptl


	pop edi
	pop ebp
	ret
_nowy_exp ENDP

 END
