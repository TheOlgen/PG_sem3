.686
.model flat

public _plus_jeden
public _liczba_przeciwna

.code
_plus_jeden PROC
	push ebp ; zapisanie zawartości EBP na stosie
	mov ebp,esp ; kopiowanie zawartości ESP do EBP

	push ebx ; przechowanie zawartości rejestru EBX

; wpisanie do rejestru EBX adresu zmiennej zdefiniowanej w kodzie w języku C
	mov ebx, [ebp+8]
	mov eax, [ebx] ; odczytanie wartości zmiennej
	inc eax ; dodanie 1
	mov [ebx], eax ; odesłanie wyniku do zmiennej
; uwaga: trzy powyższe rozkazy można zastąpić jednym rozkazem w postaci: inc dword PTR [ebx]

pop ebx
pop ebp
ret
_plus_jeden ENDP



_liczba_przeciwna PROC
	push ebp ; zapisanie zawartości EBP na stosie
	mov ebp,esp ; kopiowanie zawartości ESP do EBP

	push ebx ; przechowanie zawartości rejestru EBX

; wpisanie do rejestru EBX adresu zmiennej zdefiniowanej w kodzie w języku C
	mov ebx, [ebp+8]
	mov eax, [ebx] ; odczytanie wartości zmiennej
	neg eax ; zmiana liczby
	mov [ebx], eax ; odesłanie wyniku do zmiennej
; uwaga: trzy powyższe rozkazy można zastąpić jednym rozkazem w postaci: inc dword PTR [ebx]

pop ebx
pop ebp
ret
_liczba_przeciwna ENDP

 END
