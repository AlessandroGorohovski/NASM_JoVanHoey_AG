;asmsyntax=nasm
;function5.asm

extern printf

section .data
	first   db	"A",0
	second  db	"B",0
	third   db	"C",0
	fourth  db	"D",0
	fifth   db	"E",0
	sixth   db	"F",0
	seventh db	"G",0
	eighth  db	"H",0
	ninth   db	"I",0
	tenth   db	"J",0
	fmt1    db	"The string is: %s%s%s%s%s%s%s%s%s%s",10,0
	fmt2    db	"PI = %50.48f",10,0
	pi      dq	3.141592653589793238462643383279502884197169399375105

section .bss

section .text
	global main
main:
	push rbp
	mov  rbp, rsp

	mov  rdi, fmt1	; Сначала используются регистры
	mov  rsi, first
	mov  rdx, second
	mov  rcx, third
	mov  r8, fourth
	mov  r9, fifth
	push tenth	; Теперь начинается запись в стек
	push ninth	;  в обратном порядке
	push eighth
	push seventh

	push sixth
	xor  rax, rax
	call printf	; Вывод

	and  rsp, 0xfffffffffffffff0	; Выравнивание стека по 16-байтовой границе

; Вывод числа Pi с плавающей точкой
	movsd xmm0, [pi]
	mov  rax, 1	; Выводится одно число с плав.точкой
	mov  rdi, fmt2
	call printf

leave
ret
