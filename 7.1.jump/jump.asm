; asmsyntax=nasm
; jump.asm
; p.67

extern printf

section .data
	number1	dq 42
	number2	dq 41
	fmt1		db "NUMBER1 >= NUMBER2",10,0
	fmt2		db "NUMBER1 <  NUMBER2",10,0

section .bss

section .text
	global main
main:
	push rbp		; Пролог функции
	mov rbp,rsp

	mov rax, [number1]	; Передаём числа в регистры
	mov rbx, [number2]
	cmp rax,rbx	; Сравниваем
	jge greater	; Если rax >= rbx, то переходим к метке greate

	mov rdi, fmt2	; Если rax < rbx
;	mov rax, 0		; Регистр xmm не используется
;	call printf		; Вывод строки fmt2
	jmp exit

greater:
	mov rdi, fmt1	; Если rax >= rbx

exit:
	mov rax, 0		; Регистр xmm не используется
	call printf		; Вывод строки fmt1

	mov rsp,rbp	; Эпилог функции
	pop rbp

;	mov rax, 60		; 60 = код выхода из программы.
;	xor rdi, rdi	; 0 = код успешного завершения программы.
;	syscall

	ret
