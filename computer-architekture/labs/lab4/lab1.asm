.686
.model flat

public _szukaj_max
public _szukaj_max4
.code

_szukaj_max PROC
	push ebp ; zapisanie zawartości EBP na stosie
	mov ebp, esp ; kopiowanie zawartości ESP do EBP

		mov eax, [ebp+8] ; liczba x
		cmp eax, [ebp+12] ; porownanie liczb x i y
		jge x_wieksza ; skok, gdy x >= y

	; przypadek x < y
		mov eax, [ebp+12] ; liczba y
		cmp eax, [ebp+16] ; porownanie liczb y i z
		jge y_wieksza ; skok, gdy y >= z

	; przypadek y < z zatem z jest liczbą najwiekszą
	wpisz_z: 
		mov eax, [ebp+16] ; liczba z

	zakoncz:
		pop ebp
		ret

	x_wieksza:
		cmp eax, [ebp+16] ; porownanie x i z
		jge zakoncz ; skok, gdy x >= z
		jmp wpisz_z

	y_wieksza:
		mov eax, [ebp+12] ; liczba y
		jmp zakoncz

_szukaj_max ENDP


_szukaj_max4 PROC
	push ebp ; zapisanie zawartości EBP na stosie
	mov ebp, esp ; kopiowanie zawartości ESP do EBP
	push ebx
	push esi
	push edi

	mov eax, [ebp+8] ;x
	mov ebx, [ebp+12] ;y
	mov ecx, [ebp+16] ;z
	mov edx, [ebp+20] ;a
	

	; porownanie liczb x i y
		cmp eax, ebx 
		jge x_wieksza_od_y ; skok, gdy x >= y

		; przypadek x < y, prownanie y i z
			cmp ebx, ecx ; porownanie liczb y i z
			jge y_wieksza_od_z ; skok, gdy y >= z

			; przypadek y < z, porównanie z i a
			porownaj_z_a:
				cmp ecx, edx ; porownanie liczb z i a
				jge wpisz_z ; skok, gdy z >= a

				wpisz_a:
					mov eax, edx ; liczba a
					jmp zakoncz

				wpisz_z: 
					mov eax, ecx ; liczba z
					jmp zakoncz

			y_wieksza_od_z:
				cmp ebx, edx ; porownanie liczb y i a
				jle wpisz_a

				wpisz_y:
					mov eax, [ebp+12] ; liczba y
					jmp zakoncz

		x_wieksza_od_y:
			cmp eax, ecx ; porownanie x i z
			jge x_wieksza_od_z ; skok, gdy x >= z
			jmp porownaj_z_a

			x_wieksza_od_z:
				cmp eax, edx ; porownanie liczb x i a
				jle wpisz_a
				jmp zakoncz

zakoncz:
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_szukaj_max4 ENDP

END
