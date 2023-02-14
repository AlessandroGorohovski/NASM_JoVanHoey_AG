; asmsyntax=nasm
; betterloop.asm
; pp.71

extern printf

section .data
	number	dq 1000000000 ; 5
	fmt		db "The sum from 0 to %ld is %ld",10,0

section .bss

section .text
	global main
main:
	push rbp	; Пролог функции
	mov rbp, rsp

	mov rcx, [number]	; Инициализация регистра rcx значением Счётчика
	mov rax, 0	; Сумма будет сохраняться в регистре rax

bloop:
	add rax, rcx	; Прибавляем rcx для получения общей суммы
	loop bloop	; Цикл, на каждой итерации значение rcx меньшается на 1
					; До тех пор, когда rcx = 0

	mov rdi, fmt	; Подготовка вывода результата
	mov rsi, [number]
	mov rdx, rax
	mov rax, 0	; Регистр xmm не используется (нет чисел с плавающей точкой)
	call printf		; Вывод строки fmt

	mov rsp,rbp	; Эпилог функции
	pop rbp

;	mov rax, 60		; 60 = код выхода из программы.
;	xor rdi, rdi	; 0 = код успешного завершения программы.
;	syscall

	ret
