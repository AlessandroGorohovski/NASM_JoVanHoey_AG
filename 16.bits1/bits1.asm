;asmsyntax=nasm
;bits1.asm

extern printb
extern printf

section .data
	msgn1 db	"Number 1",10,0
	msgn2 db	"Number 2",10,0
	msg1  db	"XOR",10,0
	msg2  db	"OR",10,0
	msg3  db	"AND",10,0
	msg4  db	"NOT number 1",10,0

	msg5  db	"SHL 2 lower byte of number 1",10,0
	msg6  db	"SHR 2 lower byte of number 1",10,0

	msg7  db	"SAL 2 lower byte of number 1",10,0
	msg8  db	"SAR 2 lower byte of number 1",10,0

	msg9  db	"ROL 2 lower byte of number 1",10,0
	msg10 db	"ROL 2 lower byte of number 2",10,0

	msg11 db	"ROR 2 lower byte of number 1",10,0
	msg12 db	"ROR 2 lower byte of number 2",10,0

	number1 dq	-72
	number2 dq	1064

section .bss

section .text
	global main
main:
	push rbp
	mov  rbp, rsp


; Вывод number1
	mov  rsi, msgn1
	call printmsg
	mov  rdi, [number1]
	call printb

; Вывод number2
	mov  rsi, msgn2
	call printmsg
	mov  rdi, [number2]
	call printb

; Вывод XOR (исключающего OR)-------------
	mov  rsi, msg1
	call printmsg
; xor и вывод
	mov  rax, [number1]
	xor  rax, [number2]
	mov  rdi, rax
	call printb

; Вывод AND ------------------------------
	mov  rsi, msg3
	call printmsg
; and и вывод
	mov  rax, [number1]
	and  rax, [number2]
	mov  rdi, rax
	call printb

; Вывод NOT ------------------------------
	mov  rsi, msg4
	call printmsg
; not и вывод
	mov  rax, [number1]
	not  rax
	mov  rdi, rax
	call printb

; Вывод SHL (сдвиг влево)-----------------
	mov  rsi, msg5
	call printmsg
; shl и вывод
	mov  rax, [number1]

	shl  al, 2
	mov  rdi, rax
	call printb

; Вывод SHR (сдвиг вправо)-----------------
	mov  rsi, msg6
	call printmsg
; shr и вывод
	mov  rax, [number1]
	shr  al, 2
	mov  rdi, rax
	call printb

; Вывод SAL (арифметический сдвиг влево)--
	mov  rsi, msg7
	call printmsg
; sal и вывод
	mov  rax, [number1]
	sal  al, 2
	mov  rdi, rax
	call printb

; Вывод SAR (арифметический сдвиг вправо)-
	mov  rsi, msg8
	call printmsg
; sar и вывод
	mov  rax, [number1]
	sar  al, 2
	mov  rdi, rax
	call printb

; Вывод ROL (вращение влево)--------------
	mov  rsi, msg9
	call printmsg
; rol и вывод
	mov  rax, [number1]
	rol  al, 2
	mov  rdi, rax
	call printb

	mov  rsi, msg10
	call printmsg
	mov  rax, [number2]
	rol  al, 2
	mov  rdi, rax

	call printb

; Вывод ROR (вращение вправо)-------------
	mov  rsi, msg11
	call printmsg
; ror и вывод
	mov  rax, [number1]
	ror  al, 2
	mov  rdi, rax
	call printb

	mov  rsi, msg10
	call printmsg
	mov  rax, [number2]
	ror  al, 2
	mov  rdi, rax
	call printb

leave
ret
;--------------------------------------------

printmsg:		; Вывод заголовка для каждой битовой операции
section .data
	.fmtstr db "%s",0

section .text
	mov  rdi, .fmtstr
	xor  rax, rax
	call printf
	ret
