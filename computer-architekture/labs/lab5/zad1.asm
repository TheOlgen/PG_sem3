.686
.model flat

public _srednia_harm

.data
suma dd 0
wynik dd 0
jeden dd 1.0
dwa dd 2.0

.code

_srednia_harm PROC
	push ebp
	mov ebp, esp	
	push ebx
	push edi
	finit
	fldz


	mov ebx, [ebp + 8] ; adres tablicy z naszymi danymi
	mov ecx, [ebp +  12] ; liczba elementów tablicy
	mov edi, 0 ;indeks do poruszania sie po tablicy


	ptl:
		;działania
		fld jeden
		fld dword ptr[ebx + 4*edi]
		fdivp 
		faddp

		inc edi
		loop ptl

	fild dword ptr [ebp +  12]
	fxch st(1)
	fdivp

	pop edi
	pop ebx
	pop ebp
	ret
_srednia_harm ENDP




END
