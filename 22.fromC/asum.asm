;asmsyntax=nasm
;asum.asm

section .data
section .bss

section .text

global asum
asum:
	section .text
	; Вычисление суммы
		mov  rbx, rdi	; в rdi = адрес строки
		mov  rcx, rsi	; в rsi = длина строки
		mov  r12, 0
		movsd xmm0, qword[rbx+r12*8]
		dec  rcx	; На одну иттерацию в цикле меньше,
		         ; т.к. 1-й элемент уже в регистре xmm0

	sloop:
		inc r12
		addsd xmm0, qword[rbx+r12*8]
		loop sloop

; Выход
		ret	; В xmm0 возвращаем сумму

