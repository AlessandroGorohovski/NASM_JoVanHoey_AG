; asmsyntax=nasm
; jumploop.asm
; pp.70-71

extern printf

section .data
	number	dq 1000000000 ; 5
	fmt		db "The sum from 0 to %ld is %ld",10,0

section .bss

section .text
	global main
main:
	push rbp		; Пролог функции
	mov rbp,rsp

	mov rbx, 0	; Счётчик
	mov rax, 0	; Сумма будет сохраняться в регистре rax

jloop:
	add rax, rbx
	inc rbx
	cmp rbx, [number]	; Конечное число итераций цикла достигнуто?
	jle jloop	; Продолжаем цикл

	mov rdi, fmt	; Подготовка вывода результата
	mov rsi, [number]
	mov rdx, rax
	mov rax, 0	; Регистр xmm не используется
	call printf		; Вывод строки fmt

exit:
	mov rsp,rbp	; Эпилог функции
	pop rbp

;	mov rax, 60		; 60 = код выхода из программы.
;	xor rdi, rdi	; 0 = код успешного завершения программы.
;	syscall

	ret
