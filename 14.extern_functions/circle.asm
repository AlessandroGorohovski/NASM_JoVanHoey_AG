;asmsyntax=nasm
;circle.asm

extern pi

section .data
section .bss

section .text
	global c_area
c_area:	; Площадь круга
	section .text
	push rbp
	mov  rbp, rsp

		movsd xmm1, qword [pi]
		mulsd xmm0, xmm0	; Радиус в регистре xmm0
		mulsd xmm0, xmm1

	mov  rsp, rbp
	pop  rbp
	ret
;----------------------------------

	global c_circum
c_circum:	; Длина окружности
	section .text
	push rbp
	mov  rbp, rsp

		movsd xmm1, qword [pi]
		addsd xmm0, xmm0	; Радиус в регистре xmm0
		mulsd xmm0, xmm1


	mov  rsp, rbp
	pop  rbp
	ret
