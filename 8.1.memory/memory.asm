;asmsyntax=nasm
;memory.asm

section .data
	bNum    db	123
	wNum    dw	12345
	warray  times	5 dw 0	; Массив из 5 слов, состоящих из 0
	dNum    dd	12345
	qNum1   dq	12345
	text1   db	"abc",0
	qNum2   dq	3.141592654
	text2   db	"cde",0

section .bss
	bvar    resb	1
	dvar    resd	1
	wvar    resw	10
	qvar    resq	3

section .text

	global main
main:
	push rbp
	mov  rbp, rsp

; Загрузка адреса bNum в rax
	lea  rax, [bNum]
	mov  rax, bNum	; same

	mov  rax, [bNum]	; Загрузка значения bNum в rax
	mov  [bvar], rax	; Загрузка из rax в адрес памяти bvar

; Загрузка адреса переменных в rax
	lea  rax, [bvar]
	lea  rax, [wNum]

	mov  rax, [wNum]	; Загрузка значения wNum в rax


; Загрузка адреса text1 в rax
	lea  rax, [text1]
	mov  rax, text1
	mov  rax, text1+1	; адреса второго символа в rax
	lea  rax, [text1+1]	; same

; Загрузка значений в rax
	mov  rax, [text1]	; начиная с адреса text1
	mov  rax, [text1+1]	; начиная с адреса text1 + 1

; Выход
	mov  rsp, rbp
	pop  rbp
	ret
