;asmsyntax=nasm
;move_strings.asm

%macro prnt 2
	xor eax, eax
	inc eax	; 1 = запись
	mov rdi, rax	; 1 = в стандартный поток вывода stdout
	mov rsi, %1
	mov rdx, %2
	push rax
	syscall
	pop rax

	mov rdi, rax
	mov rsi, NL
	mov rdx, rax
	syscall
%endmacro

section .data
	length  equ 95
	NL      db 0xA

	string1 db    "my_string of ASCII:"
	string2 db 10,"my_string of zeros:"
	string3 db 10,"my_string of ones:"
	string4 db 10,"again my_string of ASCII:"
	string5 db 10,"copy my_string to other_string:"
	string6 db 10,"reverse copy my_string to other_string:"

section .bss
	my_string    resb length
	other_string resb length

section .text
	global main
main:
	push rbp

	mov  rbp, rsp
;---------------------------------------
; Заполнение строки видимыми ascii-символами
	prnt string1, 19	; #AG!
	mov  rax, 32
	mov  rdi, my_string
	mov  rcx, length

str_loop1:	; Простой метод
	mov  byte[rdi], al
	inc  rdi
	inc  al
	loop str_loop1
	prnt my_string, length

;---------------------------------------
; Заполнение строки ascii-символами 0
	prnt string2, 20
	mov  rax, 48
	mov  rdi, my_string
	mov  rcx, length

str_loop2:	; без inc rdi
	stosb
	loop str_loop2
	prnt my_string, length

;---------------------------------------
; Заполнение строки ascii-символами 1
	prnt string3, 19
	mov  rax, 49
	mov  rdi, my_string
	mov  rcx, length
	rep  stosb	; без цикла
	prnt my_string, length

;---------------------------------------
; Повторное заполнение строки видимыми ascii-символами
	prnt string4, 26
	mov  rax, 32
	mov  rdi, my_string
	mov  rcx, length

str_loop3:	; Простой метод
	mov  byte[rdi], al

	inc  rdi
	inc  al
	loop str_loop3
	prnt my_string, length

;---------------------------------------
; Копирование строки my_string в другую строку other_string
	prnt string5, 32
	mov  rsi, my_string	; Источник в rsi
	mov  rdi, other_string	; Цель в rdi
	mov  rcx, length
	rep  movsb
	prnt other_string, length

;---------------------------------------
; Копирование в обратном порядке строки my_string в другую строку other_string
	prnt string6, 40
	mov  rax, 48	; Очистка (заполнение 0) строки other_string
	mov  rdi, other_string	; Цель в rdi
	mov  rcx, length
	rep  stosb

	lea  rsi, [my_string+length-4]	; Источник в rsi
	lea  rdi, [other_string+length]	; Цель в rdi
	mov  rcx, 27	; Копирование только 27-1 символов
	std	; Устанавливаем флаг DF - направления копирования (cld -- сбросить DF)
	rep  movsb
	prnt other_string, length

;	mov rax, 60
;	xor rdi, rdi
;	syscall

	leave
	ret


