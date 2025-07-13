.686
.XMM
.model flat

public _int2float


.code
_int2float PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	mov esi, [ebp+8] ;adres całkowitych
	mov edi, [ebp+12] ;adres zmiennoprzecinkowych

	cvtpi2ps xmm5, qword PTR [esi]

	movdqu [edi], xmm5

	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_int2float ENDP
end
