;asmsyntax=nasm
;cmdline.asm

extern printf

section .data
	msg db "The command and arguments: ",10,0
	fmt db "%s",10,0

section .bss

section .text
	global main
main:
	push rbp
	mov  rbp, rsp

	mov  r12, rdi	; Кол-во аргументов
	mov  r13, rsi	; Адрес массива аргументов

; Вывод заголовка
	mov  rdi, msg
	call printf

	mov  r14, 0
; Вывод имени команды и аргументов
.ploop:		; Цикл прохода по массиву аргументов и их вывода
	mov  rdi, fmt
	mov  rsi, qword [r13+r14*8]
	call printf
	inc  r14
	cmp  r14, r12	; Достигнуто максимальное кол-во аргументов?
	jl   .ploop

;	mov rax, 60
;	xor rdi, rdi
;	syscall

	leave
	ret


