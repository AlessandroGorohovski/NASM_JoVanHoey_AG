;asmsyntax=nasm
;bits2.asm

extern printf

section .data
	msgn1 db	"Number 1 is = %d",0
	msgn2 db	"Number 2 is = %d",0
	msg1  db	"SHL 2 = OK multiply by 4",0
	msg2  db	"SHR 2 = WRONG divide by 4",0
	msg3  db	"SAL 2 = correctly multiply by 4",0
	msg4  db	"SAR 2 = correctly divide by 4",0
	msg5  db	"SHR 2 = OK divide by 4",0

	number1 dq	8
	number2 dq	-8
	result  dq	0

section .bss

section .text
	global main
main:
	push rbp
	mov  rbp, rsp

; SHL-------------------------------------
; Положительное число
	mov  rsi, msg1
	call printmsg	; Вывод заголовка
	mov  rsi, [number1]
	call printnbr	; Вывод числа number1

	mov  rax, [number1]
	shl  rax, 2	; Умножение на 4 (логический сдвиг)
	mov  rsi, rax
	call printres


; Отрицательное число
	mov  rsi, msg1
	call printmsg	; Вывод заголовка
	mov  rsi, [number2]
	call printnbr	; Вывод числа number2

	mov  rax, [number2]
	shl  rax, 2	; Умножение на 4 (логический сдвиг)
	mov  rsi, rax
	call printres

; SAL-------------------------------------
; Положительное число
	mov  rsi, msg3
	call printmsg	; Вывод заголовка
	mov  rsi, [number1]
	call printnbr	; Вывод числа number1

	mov  rax, [number1]
	sal  rax, 2	; Умножение на 4 (арифметический сдвиг)
	mov  rsi, rax
	call printres

; Отрицательное число
	mov  rsi, msg3
	call printmsg	; Вывод заголовка
	mov  rsi, [number2]
	call printnbr	; Вывод числа number2

	mov  rax, [number2]
	sal  rax, 2	; Умножение на 4 (арифметический сдвиг)
	mov  rsi, rax
	call printres

; SHR-------------------------------------
; Положительное число
	mov  rsi, msg5
	call printmsg	; Вывод заголовка
	mov  rsi, [number1]
	call printnbr	; Вывод числа number1

	mov  rax, [number1]
	shr  rax, 2	; Деление на 4 (логический сдвиг)
	mov  rsi, rax
	call printres


; Отрицательное число
	mov  rsi, msg2
	call printmsg	; Вывод заголовка
	mov  rsi, [number2]
	call printnbr	; Вывод числа number2

	mov  rax, [number2]
	shr  rax, 2	; Деление на 4 (логический сдвиг)
	mov  [result], rax	; ???
	mov  rsi, rax
	call printres

; SAR-------------------------------------
; Положительное число
	mov  rsi, msg4
	call printmsg	; Вывод заголовка
	mov  rsi, [number1]
	call printnbr	; Вывод числа number1

	mov  rax, [number1]
	sar  rax, 2	; Деление на 4 (логический сдвиг)
	mov  rsi, rax
	call printres

; Отрицательное число
	mov  rsi, msg4
	call printmsg	; Вывод заголовка
	mov  rsi, [number2]
	call printnbr	; Вывод числа number2

	mov  rax, [number2]
	sar  rax, 2	; Деление на 4 (логический сдвиг)
	mov  rsi, rax
	call printres

leave
ret

;--------------------------------------------
printmsg:		; Вывод общего заголовка
section .data
	.fmtstr db 10,"%s",10,0	; Формат для вывода строки

section .text

	mov  rdi, .fmtstr
	xor  rax, rax
	call printf
ret

;--------------------------------------------
printnbr:		; Вывод исходного числа
section .data
	.fmtstr db "The original number is %lld",10,0	; Формат для вывода

section .text
	mov  rdi, .fmtstr
	xor  rax, rax
	call printf
ret

;--------------------------------------------
printres:		; Вывод результата
section .data
	.fmtstr db "The resulting number is %lld",10,0	; Формат для вывода

section .text
	mov  rdi, .fmtstr
	xor  rax, rax
	call printf
ret


