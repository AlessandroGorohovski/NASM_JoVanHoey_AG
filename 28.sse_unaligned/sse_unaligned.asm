;asmsyntax=nasm
;sse_unaligned.asm
extern printf

section .data
; Данные с обычной точностью
	spvector1 dd 1.1
	          dd 2.2
	          dd 3.3
	          dd 4.4
	spvector2 dd 1.1
	          dd 2.2
	          dd 3.3
	          dd 4.4

; Данные с двойной точностью
	dpvector1 dq 1.1
	          dq 2.2
	dpvector2 dq 3.3
	          dq 4.4

	fmt1 db "Single Precision Vector 1: %f, %f, %f, %f",10,0
	fmt2 db "Single Precision Vector 2: %f, %f, %f, %f",10,0
	fmt3 db "Sum of Single Precision Vector 1 + Vector 2:"
	     db " %f, %f, %f, %f",10,0
	fmt4 db "Double Precision Vector 1: %f, %f",10,0
	fmt5 db "Double Precision Vector 2: %f, %f",10,0
	fmt6 db "Sum of Double Precision Vector 1 + Vector 2:"
	     db " %f, %f",10,0

section .bss
	spvector_res resd 4
	dpvector_res resq 2

section .text
	global main
main:
	push rbp

	mov rbp, rsp

; Сложение 2х векторов из чисел с плавающей точкой с ОБЫЧНОЙ точностью
	mov rsi, spvector1
	mov rdi, fmt1
	call printspfp	; Выводим исходный SP-вектор 1

	mov rsi, spvector2
	mov rdi, fmt2
	call printspfp	; Выводим исходный SP-вектор 2

	movups xmm0, [spvector1]	; копируем невыровненные упакованные данные с обычной точностью
	movups xmm1, [spvector2]	; same
	addps xmm0, xmm1	; Складываем упакованные данные с обычной точностью
	movups [spvector_res], xmm0
	mov rsi, spvector_res
	mov rdi, fmt3
	call printspfp	; Выводим сумму SP-векторов

; Сложение 2х векторов из чисел с плавающей точкой с ДВОЙНОЙ точностью
	mov rsi, dpvector1
	mov rdi, fmt4
	call printdpfp	; Выводим исходный DP-вектор 1

	mov rsi, dpvector2
	mov rdi, fmt5
	call printdpfp	; Выводим исходный DP-вектор 2

	movupd xmm0, [dpvector1]	; копируем невыровненные упакованные данные с двойной точностью
	movupd xmm1, [dpvector2]	; same
	addpd xmm0, xmm1
	movupd [dpvector_res], xmm0
	mov rsi, dpvector_res
	mov rdi, fmt6
	call printdpfp	; Выводим сумму DP-векторов

	leave
	ret
;-----------------------------------------------------------

printspfp:
	push rbp
	mov rbp, rsp

	movss xmm0, [rsi]

	cvtss2sd xmm0, xmm0	; преобразуем число одинарной в двойную точность (для printf)
	movss xmm1, [rsi+4]
	cvtss2sd xmm1, xmm1
	movss xmm2, [rsi+8]
	cvtss2sd xmm2, xmm2
	movss xmm3, [rsi+12]
	cvtss2sd xmm3, xmm3
	mov rax, 4	; Четыре числа с плав.точкой
	call printf

	leave
	ret
;-----------------------------------------------------------

printdpfp:
	push rbp
	mov rbp, rsp

	movsd xmm0, [rsi]
	movsd xmm1, [rsi+8]

	mov rax, 2	; Два числа с плав.точкой
	call printf

	leave
	ret
