.686
.XMM
.model flat

public _dodaj_SSE_char


.code
_dodaj_SSE_char PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	mov esi, [ebp+8]
	mov ebx, [ebp+12]
	mov edi, [ebp+16]

	movdqu xmm0, xmmword ptr [esi]
	movdqu xmm1, xmmword ptr [ebx]

	paddsb xmm0, xmm1
	movdqu [edi], xmm0

	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_dodaj_SSE_char ENDP
end
