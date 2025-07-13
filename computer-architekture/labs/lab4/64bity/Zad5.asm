public szukaj64_max
public suma_siedmiu_liczb

.code

szukaj64_max PROC
	push rbx ; przechowanie rejestrów
	push rsi

	mov rbx, rcx ; adres tablicy
	mov rcx, rdx ; liczba elementów tablicy
	mov rsi, 0 ; indeks bieżący w tablicy

; w rejestrze RAX przechowywany będzie największy dotychczas
; znaleziony element tablicy - na razie przyjmujemy, że jest
; to pierwszy element tablicy
	mov rax, [rbx + rsi*8]

; zmniejszenie o 1 liczby obiegów pętli, bo ilość porównań
; jest mniejsza o 1 od ilości elementów tablicy
	dec rcx


ptl: inc rsi ; inkrementacja indeksu
	; porównanie największego, dotychczas znalezionego elementu tablicy z elementem bieżącym
	cmp rax, [rbx + rsi*8]
	jge dalej; skok, gdy element bieżący jest niewiększy od dotychczas znalezionego


	; przypadek, gdy element bieżący jest większy od dotychczas znalezionego
	mov rax, [rbx+rsi*8]

	dalej: loop ptl ; organizacja pętli


; obliczona wartość maksymalna pozostaje w rejestrze RAX
; i będzie wykorzystana przez kod programu napisany w języku C
pop rsi
pop rbx
ret
szukaj64_max ENDP




suma_siedmiu_liczb PROC
	push rbp

	mov rbp, rsp
	push rbx

	xor rax, rax
	xor rbx, rbx

	add rax, rcx
	add rax, rdx
	add rax, r8
	add rax, r9
; 8 bajtow - dopelnienie do wielokrotnosci 16
; 24 bajty - trzy parametry przekazywane
; 32 bajty - shadow space

	mov rbx, [rbp+48]
	add rax, rbx
	mov rbx, [rbp+56]
	add rax, rbx
	mov rbx, [rbp+64]
	add rax, rbx

pop rbx
pop rbp
ret
suma_siedmiu_liczb ENDP



END
