;asmsyntax=nasm
;macro.asm
extern printf

%define double_it(r) sar r, 1	; Однострочный макрос

%macro prntf 2	; Макрос из нескольких строк с 2 аргументами
	section .data
		%%arg1	db	%1,0	; Первый аргумент
		%%fmtint	db	"%s %ld",10,0	; Строка формата
	section .text
		mov  rdi, %%fmtint
		mov  rsi, %%arg1
		mov  rdx, [%2]	; Второй аргумент
		xor  rax, rax	; Числа с плавающей точкой для вывода не используются
		call printf
%endmacro

section .data
	number	dq	15

section .bss

section .text
	global main
main:
	push rbp
	mov  rbp, rsp

	prntf "The number is", number
	mov  rax, [number]
	double_it(rax)
	mov  [number], rax
	prntf "The number times 2 is", number

leave
ret


