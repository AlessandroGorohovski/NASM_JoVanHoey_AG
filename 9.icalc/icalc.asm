;asmsyntax=nasm
;icalc.asm

extern printf

section .data
	number1	dq	128	; числа, которые используем для
	number2	dq	19	; демонстрации арифметических вычислений
	neg_num	dq	-12	; и распространения знакового разряда
	fmt   	db	"The numbers are %ld and %ld; negative number is %ld",10,0
	fmtint	db	"%s %ld",10,0
	sumi  	db	"The sum is",0
	difi  	db	"The difference is",0
	inci  	db	"Number 1 Incremented:",0
	deci  	db	"Number 1 Decremented:",0
	sali  	db	"Number 1 Shift left 2 (x4):",0
	sari  	db	"Number 1 Shift right 2 (/4):",0
	sariex	db	"Negative number Shift right 2 (/4) with "
	      	db	"sign extension:",0
	multi 	db	"The product is",0
	divi  	db	"The integer quotient is",0
	remi  	db	"The modulo is",0

section .bss
	resulti	resq	1
	modulo	resq	1

section .text
	global main
main:
	push rbp
	mov  rbp, rsp
; Вывод чисел
	mov  rdi, fmt
	mov  rsi, [number1]
	mov  rdx, [number2]
	mov  rcx, [neg_num]
	xor  rax, rax
	call printf

; Сложение -------------------------------------------------
	mov  rax, [number1]
	add  rax, [number2]	; Складываем number2 с rax (number1)
	mov  [resulti], rax
; Вывод результата
	mov  rdi, fmtint
	mov  rsi, sumi
	mov  rdx, [resulti]
	xor  rax, rax
	call printf


; Вычитание ------------------------------------------------
	mov  rax, [number1]
	sub  rax, [number2]	; Вычитаем number2 из rax (number1)
	mov  [resulti], rax
; Вывод результата
	mov  rdi, fmtint
	mov  rsi, difi
	mov  rdx, [resulti]
	xor  rax, rax
	call printf

; Инкрементирование ----------------------------------------
	mov  rax, [number1]
	inc  rax	; Инкрементируем rax (number1) на 1
	mov  [resulti], rax
; Вывод результата
	mov  rdi, fmtint
	mov  rsi, inci
	mov  rdx, [resulti]
	xor  rax, rax
	call printf

; Декрементирование ----------------------------------------
	mov  rax, [number1]
	dec  rax	; Декрементируем rax (number1) на 1
	mov  [resulti], rax
; Вывод результата
	mov  rdi, fmtint
	mov  rsi, deci
	mov  rdx, [resulti]
	xor  rax, rax
	call printf

; Арифметический сдвиг влево -------------------------------
	mov  rax, [number1]
	sal  rax, 2	; Умножаем rax (number1) на 4
	mov  [resulti], rax
; Вывод результата
	mov  rdi, fmtint
	mov  rsi, sali
	mov  rdx, [resulti]
	xor  rax, rax
	call printf

; Арифметический сдвиг вправо ------------------------------
	mov  rax, [number1]
	sar  rax, 2	; Делим rax (number1) на 4
	mov  [resulti], rax
; Вывод результата

	mov  rdi, fmtint
	mov  rsi, sari
	mov  rdx, [resulti]
	xor  rax, rax
	call printf

; Арифметический сдвиг вправо с распространением знакового разряда ---
	mov  rax, [neg_num]
	sar  rax, 2	; Делим rax (number1) на 4
	mov  [resulti], rax
; Вывод результата
	mov  rdi, fmtint
	mov  rsi, sariex
	mov  rdx, [resulti]
	xor  rax, rax
	call printf

; Умножение ------------------------------------------------
	mov  rax, [number1]
	imul qword [number2]	; Умножаем rax (number1) на number2
	mov  [resulti], rax
; Вывод результата
	mov  rdi, fmtint
	mov  rsi, multi
	mov  rdx, [resulti]
	xor  rax, rax
	call printf

; Деление --------------------------------------------------
	mov  rax, [number1]
	xor  rdx, rdx	; Находится старшая часть делимого числа, иначе в rdx должен быть 0 перед idiv
	idiv qword [number2]	; Делим rax (number1) на number2, остаток в rdx
	mov  [resulti], rax
	mov  [modulo], rdx	; Сохраняем остаток от деления
; Вывод результата
	mov  rdi, fmtint
	mov  rsi, divi
	mov  rdx, [resulti]	; Целое от деления
	xor  rax, rax
	call printf

	mov  rdi, fmtint
	mov  rsi, remi
	mov  rdx, [modulo]	; Остаток от деления
	xor  rax, rax
	call printf

; Выход
	mov  rsp, rbp
	pop  rbp

	ret

