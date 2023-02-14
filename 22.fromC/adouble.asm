;asmsyntax=nasm
;adouble.asm -- удвоение элементов массива

section .data
section .bss

section .text

global adouble
adouble:
	section .text
	; Удвоение элементов
		mov  rbx, rdi	; в rdi = адрес массива
		mov  rcx, rsi	; в rsi = длина массива
		mov  r12, 0

	aloop:
		movsd xmm0, qword[rbx+r12*8]	; Взять элемент
		addsd xmm0, xmm0	; Удвоить его
		movsd qword[rbx+r12*8], xmm0	; Поместить результат обратно в массив
		inc r12
		loop aloop

; Выход
		ret

