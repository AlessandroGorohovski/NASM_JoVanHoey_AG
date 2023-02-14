; asmsyntax=nasm
; console1.asm

section .data
	msg1 db "Hello, world!",10,0
	msg1len equ $ - msg1
	msg2 db "Your turn: ",0
	msg2len equ $ - msg2
	msg3 db "Your answered: ",0
	msg3len equ $ - msg3
	inputlen equ 10	; Длина буфера ввода

section .bss
	input resb inputlen + 1	; Обеспечение места для завершающего 0

section .text
	global main

main:
push rbp	; Пролог
mov rbp, rsp

	mov rsi, msg1	; вывод 1й строки
	mov rdx, msg1len
	call prints

	mov rsi, msg2	; вывод 2й строки
	mov rdx, msg2len
	call prints

	mov rsi, input	; Адрес буфера ввода inputbuffer
	mov rdx, inputlen	; Длина буфера ввода inputbuffer
	call reads	; Ожидание ввода

	mov rsi, msg3	; вывод 3й строки
	mov rdx, msg3len
	call prints

	mov rsi, input	; Вывод содержимого буфера ввода inputbuffer
	mov rdx, inputlen	; Длина буфера ввода inputbuffer
	call prints

leave	; Эпилог
ret

;	mov rax, 60		; 60 = номер функции "выйти из программы".
;	xor rdi, rdi	; 0 = код успешного завершения программы.
;	syscall
;----------------------------------------------------------

; INPUT:
; rsi -- адрес строки для вывода
; rdx -- длина этой строки
prints:
push rbp
mov rbp, rsp
	xor rax, rax
	inc al	; 1 = номер функции "запись".
	mov rdi, 1		; 1 = в поток стандартного вывода stdout.
	syscall			; Вывод строки

leave
ret
;----------------------------------------------------------

; INPUT:
; rsi -- адрес буфера ввода inputbuffer
; rdi -- длина буфера ввода inputbuffer
reads:
push rbp
mov rbp, rsp
	xor rax, rax	; 0 = чтение
	mov rdi, 1	; 1 = stdin - стандартный поток ввода
	syscall

leave
ret
