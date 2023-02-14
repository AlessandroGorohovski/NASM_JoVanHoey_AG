; asmsyntax=nasm
; hello2.asm

section .data
	msg db "Hello, world!",0
	NL  db 0xa		; Код ASCII для символа перехода на новую строку.

section .bss
section .text
	global main
main:
	xor rax, rax
	inc al
;	mov rax, 1		; 1 = номер функции "запись".
	mov rdi, 1		; 1 = в поток стандартного вывода stdout.
	mov rsi, msg	; Выводимая строка в регистре rsi.
	mov rdx, 12		; Длина строки msg без последнего 0.
	syscall			; Вывод строки

	mov rax, 1
	mov rdi, 1
	mov rsi, NL
	mov rdx, 1
	syscall

	mov rax, 60		; 60 = номер функции "выйти из программы".
	xor rdi, rdi	; 0 = код успешного завершения программы.
	syscall
