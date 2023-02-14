;asmsyntax=nasm
;aligned.asm

extern printf

section .data
	fmt     db	"2 times pi equals %.14f",10,0
	pi      dq	3.14159265358979

section .bss
section .text
;-----------------------------
func3:
	push rbp

	movsd xmm0, [pi]
	addsd xmm0, [pi]
	mov  rdi, fmt
	mov  rax, 1
	call printf

	pop  rbp
	ret

;-----------------------------
func2:
	push rbp

	call func3	; Вызов 3й функции

	pop  rbp
	ret

;-----------------------------
func1:
	push rbp


	call func2	; Вызов 2й функции

	pop  rbp
	ret

;-----------------------------
	global main
main:
	push rbp

	call func1	; Вызов 1й функции

; Выход
	pop  rbp
	ret


