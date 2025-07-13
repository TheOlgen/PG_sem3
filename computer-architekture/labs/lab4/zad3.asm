.686
.model flat

public _odejmij_jeden


.code
_odejmij_jeden PROC
	push ebp ; zapisanie zawartości EBP na stosie
	mov ebp,esp ; kopiowanie zawartości ESP do EBP

	push ebx ; przechowanie zawartości rejestru EBX

; wpisanie do rejestru EBX adresu adresu zmiennej zdefiniowanej w kodzie w języku C
	mov ebx, [ebp+8]
	mov eax, [ebx] ;odczytanie adresu zmiennej
	mov ecx, [eax] ; odczytanie wartości zmiennej
	dec ecx ; dodanie 1
	mov [eax], ecx
	mov [ebx], eax ; odesłanie wyniku do zmiennej
; uwaga: trzy powyższe rozkazy można zastąpić jednym rozkazem w postaci: inc dword PTR [ebx]

pop ebx
pop ebp
ret
_odejmij_jeden ENDP

end
