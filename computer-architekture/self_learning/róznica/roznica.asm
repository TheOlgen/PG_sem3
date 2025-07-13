.686
.model flat

public _roznica

.code

_roznica PROC
	push ebp
	mov ebp,esp
		mov ecx, [ebp+8]
		mov eax, [ecx]
		mov ecx, [ebp + 12]
		mov ecx, [ecx]
		mov ecx, [ecx]
		sub eax, ecx

	pop ebp
	ret
_roznica ENDP

END
