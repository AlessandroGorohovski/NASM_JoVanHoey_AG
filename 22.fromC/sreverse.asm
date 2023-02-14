;asmsyntax=nasm
;sreverse.asm -- реверсировать строку (перевернуть на обратный порядок символов)

section .data
section .bss

section .text

global sreverse
sreverse:
	push rbp
	mov  rbp, rsp

pushing:
	mov  rbx, rdi	; в rdi = адрес строки
	mov  rcx, rsi	; в rsi = длина строки
	mov  r12, 0

	pushLoop:
		mov  rax, qword[rbx+r12]
		push rax
		inc  r12
		loop pushLoop

popping:
	mov  rcx, rsi
	mov  rbx, rdi
	mov  r12, 0

	popLoop:
		pop  rax
		mov  byte[rbx+r12], al
		inc  r12
		loop popLoop

;	mov  rax, rdi	; Возвращаем rax = адрес строки. Зачем #AG?

; Выход
	leave
	ret
