; asmsyntax=nasm
; alive.asm

section .data
	msg1		db "Hello, World!",10,0	; Строка с NL и 0.
	msg1Len	equ $-msg1-1	; Длина msg1 без завершающего 0.
	msg2		db "Alive and Kicking!", 10,0	; Строка с NL и 0.
	msg2Len	equ $-msg2-1	; Длина msg1 без завершающего 0.
	radius	dq 357	; Это не строка, можно ли вывести?
	pi			dq 3.14	; Это не строка, можно ли вывести?

section .bss

section .text
	global main
main:
;	push rbp		; Пролог функции
;	mov rbp,rsp	; Пролог функции

	mov rax, 1		; 1 = запись.
	mov rdi, 1		; 1 = в поток стандартного вывода stdout.
	mov rsi, msg1	; Выводимая строка в регистре rsi.
	mov rdx, msg1Len	; Длина строки msg без последнего 0.
	syscall

	mov rax, 1		; 1 = запись.
	mov rdi, 1		; 1 = в поток стандартного вывода stdout.
	mov rsi, msg2	; Выводимая строка в регистре rsi.
	mov rdx, msg2Len	; Длина строки msg без последнего 0.
	syscall

;	mov rsp,rbp	; Эпилог функции
;	pop rbp

	mov rax, 60		; 60 = код выхода из программы.
	xor rdi, rdi	; 0 = код успешного завершения программы.
	syscall
