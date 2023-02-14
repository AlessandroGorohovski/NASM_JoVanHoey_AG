;asmsyntax=nasm
;rect.asm

section .data
section .bss

section .text
	global r_area
r_area:	; Площадь прямоугольника
	section .text
	push rbp
	mov  rbp, rsp

		mov  rax, rdi	; side1
		imul rax, rsi	; side2

	mov  rsp, rbp
	pop  rbp
	ret
;----------------------------------

	global r_circum
r_circum:	; Периметр прямоугольника
	section .text
	push rbp
	mov  rbp, rsp

		mov  rax, rdi	; side1
		add  rax, rsi	; side2
		add  rax, rax
;		sal  rax, 1 ; same: add rax, rax

	mov  rsp, rbp
	pop  rbp
	ret

