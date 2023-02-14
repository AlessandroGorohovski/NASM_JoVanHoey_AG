;asmsyntax=nasm
;avx_unaligned.asm

extern printf

section .data
; Данные с обычной точностью
	spvector1 dd 1.1
	          dd 2.1
	          dd 3.1
	          dd 4.1
	          dd 5.1
	          dd 6.1
	          dd 7.1
	          dd 8.1
	spvector2 dd 1.2
	          dd 1.2
	          dd 3.2
	          dd 4.2
	          dd 5.2
	          dd 6.2
	          dd 7.2
	          dd 8.2

; Данные с двойной точностью
	dpvector1 dq 1.1
	          dq 2.2
	          dq 3.3
	          dq 4.4
	dpvector2 dq 5.5
	          dq 6.6
	          dq 7.7
	          dq 8.8

	fmt1 db    "Single Precision Vector 1:",10,0
	fmt2 db 10,"Single Precision Vector 2:",10,0
	fmt3 db 10,"Sum of Single Precision Vector 1 + Vector 2:",10,0
	fmt4 db 10,"Double Precision Vector 1:",10,0

	fmt5 db 10,"Double Precision Vector 2:",10,0
	fmt6 db 10,"Sum of Double Precision Vector 1 + Vector 2:",10,0

section .bss
	spvector_res resd 8
	dpvector_res resq 4

section .text
	global main
main:
	push rbp
	mov  rbp, rsp

; ВЕКТОРЫ С ПЛАВАЮЩЕЙ ТОЧКОЙ ОБЫЧНОЙ ТОЧНОСТИ
	vmovups ymm0, [spvector1]	; Загрузка вектора 1 в регистр ymm0
; Извлечение из ymm0
	vextractf128 xmm2, ymm0, 0	; Первая часть ymm0
	vextractf128 xmm2, ymm0, 1	; Вторая часть ymm0

	vmovups ymm1, [spvector2]	; Загрузка вектора 2 в регистр ymm1
; Извлечение из ymm1
	vextractf128 xmm2, ymm1, 0	; Первая часть ymm1
	vextractf128 xmm2, ymm1, 1	; Вторая часть ymm1

; Сложение 2х векторов из чисел с плавающей точкой с ОБЫЧНОЙ точностью
	vaddps ymm2, ymm0, ymm1
	vmovups [spvector_res], ymm2
; Вывод векторов
	mov  rdi, fmt1
	call printf
	mov  rsi, spvector1
	call printspfpv

	mov  rdi, fmt2
	call printf
	mov  rsi, spvector2
	call printspfpv

	mov  rdi, fmt3
	call printf
	mov  rsi, spvector_res
	call printspfpv

; ВЕКТОРЫ С ПЛАВАЮЩЕЙ ТОЧКОЙ ДВОЙНОЙ ТОЧНОСТИ
	vmovups ymm0, [dpvector1]	; Загрузка вектора 1 в регистр ymm0

; Извлечение из ymm0
	vextractf128 xmm2, ymm0, 0	; Первая часть ymm0
	vextractf128 xmm2, ymm0, 1	; Вторая часть ymm0

	vmovups ymm1, [dpvector2]	; Загрузка вектора 2 в регистр ymm1
; Извлечение из ymm1
	vextractf128 xmm2, ymm1, 0	; Первая часть ymm1
	vextractf128 xmm2, ymm1, 1	; Вторая часть ymm1

; Сложение 2х векторов из чисел с плавающей точкой с ДВОЙНОЙ точностью
	vaddpd ymm2, ymm0, ymm1
	vmovupd [dpvector_res], ymm2
; Вывод векторов
	mov  rdi, fmt4
	call printf
	mov  rsi, dpvector1
	call printdpfpv

	mov  rdi, fmt5
	call printf
	mov  rsi, dpvector2
	call printdpfpv

	mov  rdi, fmt6
	call printf
	mov  rsi, dpvector_res
	call printdpfpv

leave
ret
;-----------------------------------------------------------

printspfpv:

section .data
	.NL   db 10,0
	.fmt1 db "%.1f, ",0

section .text
	push rbp
	mov  rbp, rsp

	push rcx
	push rbx
	mov  rcx, 8

	xor  ebx, ebx

.loop:
	mov  eax, 1	; Одно число с плав.точкой (в xmm0)
	movss xmm0, [rsi+rbx]
	cvtss2sd xmm0, xmm0	; преобразуем число одинарной в двойную точность (для printf)
	mov  rdi, .fmt1
	push rsi
	push rcx
	call printf
	pop  rcx
	pop  rsi
	add  rbx, 4
	loop .loop

	xor  eax, eax
	mov  rdi, .NL
	call printf
	pop  rbx
	pop  rcx

; Exit
	leave
	ret
;-----------------------------------------------------------

printdpfpv:

section .data
	.NL   db 10,0
	.fmt db "%.1f, %.1f, %.1f, %.1f",0

section .text
	push rbp
	mov  rbp, rsp

	mov  rdi, .fmt

	movq xmm0, [rsi]
	movq xmm1, [rsi+8]
	movq xmm2, [rsi+16]
	movq xmm3, [rsi+24]

	mov  eax, 4	; Четыре числа с плав.точкой
	call printf

	mov  rdi, .NL
	call printf

; Exit
	leave
	ret

