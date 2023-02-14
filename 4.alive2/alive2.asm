; asmsyntax=nasm
; alive2.asm

section .data
	msg1  	db "Hello, World!",0
	msg2  	db "Alive and Kicking!",0
	radius	dq 357
	pi    	dq 3.14
	fmtstr	db "%s",10,0	; Формат для вывода строки
	fmtflt	db "%lf",10,0	; Формат для вывода числа с плавающей точкой
	fmtint	db "%d",10,0	; Формат для вывода целого числа

section .bss

section .text
extern printf	; Объявление функции как внешней.
	global main
main:
	push rbp		; Пролог функции
	mov rbp,rsp	; Пролог

; Печать msg1
	mov  rax, 0	; Без числа с плавающей точкой
	mov  rdi, fmtstr	; Первый аргумент для функции printf
	mov  rsi, msg1	; Второй аргумент для функции printf
	call printf	; Вызов (внешней) функции

; Печать msg2
	mov  rax, 0	; Без числа с плавающей точкой
	mov  rdi, fmtstr
	mov  rsi, msg2
	call printf

; Печать radius
	mov  rax, 0	; Без числа с плавающей точкой
	mov  rdi, fmtint
	mov  rsi, [radius]
	call printf

; Печать pi
	mov  rax, 1		; Используется 1 регистр xmm
	movq xmm0, [pi]
	mov  rdi, fmtflt
	call printf

	mov  rsp,rbp	; Эпилог функции
	pop  rbp

	ret

;	mov rax, 60		; 60 = код выхода из программы.
;	xor rdi, rdi	; 0 = код успешного завершения программы.
;	syscall
