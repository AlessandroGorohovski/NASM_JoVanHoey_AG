;asmsyntax=nasm
;transpose4x4.asm -- Транспонирование матриц

extern printf

section .data
	fmt0 db "4x4 DOUBLE PRECISION FLOATING POINT MATRIX TRANSPOSE",10,0
	fmt1 db 10,"This is the matrix:",10,0
	fmt2 db 10,"This is the transpose (unpack): ",10,0
	fmt3 db 10,"This is the transpose (shuffle): ",10,0

	align 32
	matrix dq  1.,  2.,  3.,  4.
	       dq  5.,  6.,  7.,  8.
	       dq  9., 10., 11., 12.
	       dq 13., 14., 15., 16.

section .bss
	alignb    32
	transpose resd 16	; #AG

section .text
	global main
main:
	push rbp
	mov  rbp, rsp
; Вывод заголовка
	mov  rdi, fmt0
	call printf
; Вывод матрицы
	mov  rdi, fmt1
	call printf
	mov  rsi, matrix
	call printm4x4

; Вычисления транспонированной матрицы с неупакованными данными
	mov  rdi, matrix
	mov  rsi, transpose
	call transpose_unpack_4x4

; Вывод результата
	mov  rdi, fmt2
	xor  eax, eax
	call printf
	mov  rsi, transpose

	call printm4x4

; Вычисления транспонированной матрицы с применением перемешивания
	mov  rdi, matrix
	mov  rsi, transpose
	call transpose_shuffle_4x4

; Вывод результата
	mov  rdi, fmt3
	xor  eax, eax
	call printf
	mov  rsi, transpose
	call printm4x4

; Выход
;	mov rax, 60
;	xor rdi, rdi
;	syscall

leave
ret

;-----------------------------------------------------------
transpose_unpack_4x4:
	push rbp
	mov  rbp, rsp

; Загрузка матрицы в регистры
	vmovapd ymm0, [rdi]  	;  1  2  3  4
	vmovapd ymm1, [rdi+32]	;  5  6  7  8
	vmovapd ymm2, [rdi+64]	;  9 10 11 12
	vmovapd ymm3, [rdi+96]	; 13 14 15 16

; Распаковка
	vunpcklpd ymm12, ymm0, ymm1	;  1  5  3  7
	vunpckhpd ymm13, ymm0, ymm1	;  2  6  4  8
	vunpcklpd ymm14, ymm2, ymm3	;  9 13 11 15
	vunpckhpd ymm15, ymm2, ymm3	; 10 14 12 16

; Перестановка
	vperm2f128 ymm0, ymm12, ymm14, 00100000b	; 1  5  9 13
	vperm2f128 ymm1, ymm13, ymm15, 00100000b	; 2  6 10 14
	vperm2f128 ymm2, ymm12, ymm14, 00110001b	; 3  7 11 15
	vperm2f128 ymm3, ymm13, ymm15, 00110001b	; 4  8 12 16


; Запись в память
	vmovapd [rsi],    ymm0
	vmovapd [rsi+32], ymm1
	vmovapd [rsi+64], ymm2
	vmovapd [rsi+96], ymm3

leave
ret

;-----------------------------------------------------------
transpose_shuffle_4x4:
	push rbp
	mov  rbp, rsp

; Загрузка матрицы в регистры
	vmovapd ymm0, [rdi]  	;  1  2  3  4
	vmovapd ymm1, [rdi+32]	;  5  6  7  8
	vmovapd ymm2, [rdi+64]	;  9 10 11 12
	vmovapd ymm3, [rdi+96]	; 13 14 15 16

; Перемешивание
	vshufpd ymm12, ymm0, ymm1, 0000b	;  1  5  3  7
	vshufpd ymm13, ymm0, ymm1, 1111b	;  2  6  4  8
	vshufpd ymm14, ymm2, ymm3, 0000b	;  9 13 11 15
	vshufpd ymm15, ymm2, ymm3, 1111b	; 10 14 12 16

; Перестановка
	vperm2f128 ymm0, ymm12, ymm14, 00100000b	; 1  5  9 13
	vperm2f128 ymm1, ymm13, ymm15, 00100000b	; 2  6 10 14
	vperm2f128 ymm2, ymm12, ymm14, 00110001b	; 3  7 11 15
	vperm2f128 ymm3, ymm13, ymm15, 00110001b	; 4  8 12 16

; Запись в память
	vmovapd [rsi],    ymm0
	vmovapd [rsi+32], ymm1
	vmovapd [rsi+64], ymm2
	vmovapd [rsi+96], ymm3

leave
ret

;-----------------------------------------------------------
printm4x4:
section .data
	.fmt db "%.f",9, "%.f",9, "%.f",9, "%.f",10,0


section .text
	push rbp
	mov  rbp, rsp

	push rbx	; Сохраняем регистр
	push r15	; too
	mov  rdi, .fmt
	mov  rcx, 4	; Количество строк матрицы
	xor  rbx, rbx	; Счётчик строк
.loop:
	movsd xmm0, [rsi+rbx]
;	movq xmm0, [rsi+rbx]

	movsd xmm1, [rsi+rbx+8]
;	movq xmm1, [rsi+rbx+8]

	movsd xmm2, [rsi+rbx+16]
;	movq xmm2, [rsi+rbx+16]

	movsd xmm3, [rsi+rbx+24]
;	movq xmm3, [rsi+rbx+24]

	mov  rax, 4	; Четыре числа с плавающей точкой (в строке)
	push rcx
	push rsi
	push rdi

	; Выравнивание стека, если необходимо
	xor  r15, r15
	test rsp, 0fh	; Последний байт равен 8 (стек не выровнен)?
	setnz r15b	; Установить флаг, если стек не выровнен
	shl  r15, 3	; Умножаем на 8
	sub  rsp, r15	; Вычитаем 0 или 8 (выравниваем стек)
	call printf

	add  rsp, r15	; Возвращаем стек в исходное состояние
	pop  rdi
	pop  rsi
	pop  rcx

	add  rbx, 32	; Следующая строка
	loop .loop

	pop  r15

	pop  rbx

leave
ret

; vim:ft=nasm
