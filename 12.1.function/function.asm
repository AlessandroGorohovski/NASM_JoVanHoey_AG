;asmsyntax=nasm
;function.asm

extern printf

section .data
	radius  dq	10.0
	pi      dq	3.14159265358979
	fmt     db	"The area of the circle is %.4f",10,0

section .bss
section .text
;-----------------------------
	global main
main:
	push rbp
	mov  rbp, rsp

	call area	; Значение площади возвращается в регистре xmm0
	mov  rdi, fmt
	xor  eax, eax
	inc  eax
	push rdi
	push rax
	call printf

	movsd xmm1, [radius]	; Запись числа с плав.точкой в регистр xmm1
	call area2
;	mov  rdi, fmt
;	xor  eax, eax
;	inc  eax
	pop  rax
	pop  rdi
	call printf

; Выход
	leave
	ret


;-----------------------------
area:
	push rbp
	mov  rbp, rsp

	movsd xmm0, [radius]	; Запись числа с плав.точкой в регистр xmm0
	mulsd xmm0, [radius]	; Умножение xmm0 на число с плав.точкой
	mulsd xmm0, [pi]	; Умножение xmm0 на (другое) число с плав.точкой

	leave
	ret

;-----------------------------
area2:
	push rbp
	mov  rbp, rsp

	movsd xmm0, xmm1	; Запись числа с плав.точкой в регистр xmm0
	mulsd xmm0, xmm1	; Умножение xmm0 на число с плав.точкой
	mulsd xmm0, [pi]	; Умножение xmm0 на (другое) число с плав.точкой

	leave
	ret


