;asmsyntax=nasm
;stack.asm

extern printf

section .data
	strng    db	"ABCDE",0
	strngLen equ $ - strng-1	; without 0
	fmt1     db	"The original string: %s",10,0
	fmt2     db	"The reversed string: %s",10,0

section .bss
section .text

	global main
main:
	push rbp
	mov  rbp, rsp

; Вывод исходной строки
	mov  rdi, fmt1
	mov  rsi, strng
	xor  eax, eax
	call printf

; Проталкивание (push) строки символ за символом в стек
	xor  eax, eax
	mov  rbx, strng	; Адрес строки strng в регистр rbx
	mov  rcx, strngLen	; Длина строки в регистре rcx (счётчик)
	mov  r12, 0
pushLoop:
	mov  al, byte [rbx+r12]	; Запись символа в регистр rax(al)
	push rax
	inc  r12
	loop pushLoop

; Выталкивание (pop) строки символ за символом из стек
; Фактически это реверсирование строки

	mov  rbx, strng
	mov  rcx, strngLen
	mov  r12, 0
popLoop:
	pop  rax
	mov  byte [rbx+r12], al	; Запись символа в регистр rax(al)
	inc  r12
	loop popLoop
	mov  byte [rbx+r12], 0	; Завершение строки 0-м

; Вывод реверсированной строки
	mov  rdi, fmt2
	mov  rsi, strng
	xor  eax, eax
	call printf

; Выход
	mov  rsp, rbp
	pop  rbp
	ret


