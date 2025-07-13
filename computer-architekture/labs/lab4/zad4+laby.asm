.686
.model flat 

public _przestaw
public _najmniejsza

.code
_przestaw PROC
	push ebp ; zapisanie zawartości EBP na stosie
	mov ebp,esp ; kopiowanie zawartości ESP do EBP
	push ebx ; przechowanie zawartości rejestru EBX

	mov ebx, [ebp+8] ; adres tablicy tabl
	mov ecx, [ebp+12] ; liczba elementów tablicy
	dec ecx

	; wpisanie kolejnego elementu tablicy do rejestru EAX
ptl: mov eax, [ebx]

	; porównanie elementu tablicy wpisanego do EAX z następnym
	cmp eax, [ebx+4]
	jle gotowe ; skok, gdy nie ma przestawiania

	; zamiana sąsiednich elementów tablicy
	mov edx, [ebx+4]
	mov [ebx], edx
	mov [ebx+4], eax

gotowe:
	add ebx, 4 ; wyznaczenie adresu kolejnego elementu
	loop ptl ; organizacja pętli


	pop ebx ; odtworzenie zawartości rejestrów
	pop ebp
ret ; powrót do programu głównego
_przestaw ENDP



_najmniejsza PROC
	push ebp ; zapisanie zawartości EBP na stosie
	mov ebp,esp ; kopiowanie zawartości ESP do EBP
	push ebx ; przechowanie zawartości rejestru EBX

	mov ebx, [ebp+8] ; adres tablicy tabl
	mov ecx, [ebp+12] ; liczba elementów tablicy
	dec ecx
	mov eax, [ebx]; wpisanie pierwszego elementu tablicy do rejestru EAX 

ptl: 
	
	; porównanie elementu tablicy wpisanego do EAX z następnym
	cmp eax, [ebx+4]
	jle gotowe ; skok, gdy nie ma zmiany na mniejsza cyfre

	mov eax, [ebx+4] ;zmiana najmniejszej cyfry

gotowe:
	add ebx, 4 ; wyznaczenie adresu kolejnego elementu
	loop ptl ; organizacja pętli
	

	pop ebx ; odtworzenie zawartości rejestrów
	pop ebp
	ret ; powrót do programu głównego

_najmniejsza ENDP
 END
