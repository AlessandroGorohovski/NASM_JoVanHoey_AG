; asmsyntax=nasm
; console2.asm -- Ввод/Вывод в консоли с обработкой переполнений

section .data
	msg1 db "Hello, world!",10,0
	msg2 db "Your turn (only a-z): ",0
	msg3 db "Your answered: ",0
	inputlen equ 10	; Длина буфера ввода inputbuffer
	NL db 0xa

section .bss
	input resb inputlen + 1	; Обеспечение места для завершающего 0

section .text
	global main

main:
push rbp	; Пролог
mov rbp, rsp

	mov rdi, msg1	; вывод 1й строки
	call prints

	mov rdi, msg2	; вывод 2й строки (без NL)
	call prints

	mov rdi, input	; Адрес буфера ввода inputbuffer
	mov rsi, inputlen	; Длина буфера ввода inputbuffer
	call reads	; Ожидание ввода

	mov rdi, msg3	; вывод 3й строки
	call prints

	mov rdi, input	; Вывод содержимого буфера ввода inputbuffer
	call prints

	mov rdi, NL
	call prints

leave	; Эпилог
ret

;	mov rax, 60		; 60 = номер функции "выйти из программы".
;	xor rdi, rdi	; 0 = код успешного завершения программы.
;	syscall
;----------------------------------------------------------

; INPUT:
; rdi -- адрес строки для вывода
prints:
push rbp
mov rbp, rsp
	push r12	; Сохраняем
; Подсчёт символов
	xor rdx, rdx	; Для длины строки
	mov r12, rdi
.lengthloop:
	cmp byte [r12], 0
	je .lengthfound
	inc rdx
	inc r12
	jmp .lengthloop

.lengthfound:	; Вывод строки, её длина в rdx
	cmp rdx, 0	; Строка отсутствует (длина = 0)
	je .done
	mov rsi, rdi	; rdi передает в rsi адрес строки
	xor rax, rax
	inc al	; 1 = номер функции "запись".
	mov rdi, 1		; 1 = в поток стандартного вывода stdout.
	syscall			; Вывод строки

.done:
	pop r12
leave
ret
;----------------------------------------------------------

; INPUT:
; rsi -- адрес буфера ввода inputbuffer
; rdi -- длина буфера ввода inputbuffer
reads:

section .data

section .bss
	.inputchar resb 1

section .text
push rbp
mov rbp, rsp
	push r12
	push r13
	push r14
	mov  r12, rdi	; Адрес буфера ввода inputbuffer
	mov  r13, rsi	; Максимальная длина в r13
	xor  r14, r14	; Счётчик символов

.readc:
	xor  rax, rax	; 0 = чтение
	mov  rdi, 1	; 1 = stdin - стандартный поток ввода
	lea  rsi, [.inputchar]	; Адрес источника ввода
	mov  rdx, 1	; Число считываемых символов
	syscall

	mov  al, [.inputchar]
	cmp  al, byte [NL]	; Введён символ NL ?
	je   .done	; NL -- конец ввода

	cmp  al, 97	; Код символа меньше 'a'?
	jl   .readc	; Отбросить символ

	cmp  al, 122	; Код символа меньше 'z'?
	jg   .readc	; Отбросить символ

	inc  r14	; Увеличить счётчик на +1
	cmp  r14, r13
	ja   .readc	; Максимальное заполнение буфера, отбросить лишнее

	mov  byte [r12], al	; Сохранить символ в буфере
	inc  r12	; Переместить указатель на следующий символ в буфере
	jmp  .readc

.done:
	inc  r12
	mov  byte [r12], 0	; Добавить завершающий 0 в буфер ввода inputbuffer
	pop  r14
	pop  r13
	pop  r12

leave
ret
