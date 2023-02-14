;asmsyntax=nasm
;matrix4x4.asm

extern printf

section .data
	fmt0  db 10,"4x4 DOUBLE PRECISION FLOATING POINT MATRICES.",10,0
	fmt1  db 10,"This is matrixA:",10,0
	fmt2  db 10,"This is matrixB:",10,0
	fmt3  db 10,"This is matrixA x matrixB:",10,0
	fmt4  db 10,"This is matrixC:",10,0
	fmt5  db 10,"This is the inverse of matrixC:",10,0
	fmt6  db 10,"Proof: matrixC x inverse =",10,0
	fmt7  db 10,"This is matrixS:",10,0
	fmt8  db 10,"This is the inverse of matrixS:",10,0
	fmt9  db 10,"Proof: matrixS x inverse =",10,0
	fmt10 db 10,"This matrix is singular!:",10,10,0

	align 32
	matrixA dq  1.,  3.,  5.,  7.
	        dq  9., 11., 13., 15.
	        dq 17., 19., 21., 23.
	        dq 25., 27., 29., 31.

	matrixB dq  2.,  4.,  6.,  8.
	        dq 10., 12., 14., 16.
	        dq 18., 20., 22., 24.
	        dq 26., 28., 30., 32.

	matrixC dq  2., 11., 21., 37.
	        dq  3., 13., 23., 41.
	        dq  5., 17., 29., 43.
	        dq  7., 19., 31., 47.

	matrixS dq  1.,  2.,  3.,  4.
	        dq  5.,  6.,  7.,  8.
	        dq  9., 10., 11., 12.
	        dq 13., 14., 15., 16.


section .bss
	align 32
	product resq 16
	inverse resq 16

section .text
	global main
main:
	push rbp
	mov  rbp, rsp

; Вывод заголовка
	mov  rdi, fmt0
	call printf

; Вывод матрицы matrixA
	mov  rdi, fmt1
	call printf
	mov  rsi, matrixA
	call printm4x4

; Вывод матрицы matrixB
	mov  rdi, fmt2
	call printf
	mov  rsi, matrixB
	call printm4x4

; Вычисление произведения матриц matrixA x matrixB
	mov  rdi, matrixA
	mov  rsi, matrixB
	mov  rdx, product
	call multi4x4

; Вывод произведения (результат умножения)
	mov  rdi, fmt3
	call printf
	mov  rsi, product
	call printm4x4

; Вывод матрицы matrixC
	mov  rdi, fmt4
	call printf
	mov  rsi, matrixC
	call printm4x4


; Выполняем обращение (инверсию) матрицы matrixC
	mov  rdi, matrixC
	mov  rsi, inverse
	call inverse4x4
	cmp  rax, 1
	je   singular

; Вывод обращённой матрицы
	mov  rdi, fmt5
	call printf
	mov  rsi, inverse
	call printm4x4

; Подтверждение операции умножения матрицы matrixC и обращения
	mov  rdi, matrixC
	mov  rsi, inverse
	mov  rdx, product
	call multi4x4

; Вывод подтверждения
	mov  rdi, fmt6
	call printf
	mov  rsi, product
	call printm4x4

; Сингулярная (вырожденная) матрица
; Вывод matrixS
	mov  rdi, fmt7
	call printf
	mov  rsi, matrixS
	call printm4x4

; Выполняем обращение (инверсию) матрицы matrixS
	mov  rdi, matrixS
	mov  rsi, inverse
	call inverse4x4
	cmp  rax, 1
	je   singular

; Вывод обращённой матрицы
	mov  rdi, fmt8
	call printf
	mov  rsi, inverse
	call printm4x4


; Подтверждение операции умножения матрицы matrixS и обращения
	mov  rdi, matrixS
	mov  rsi, inverse
	mov  rdx, product
	call multi4x4

; Вывод подтверждения
	mov  rdi, fmt9
	call printf
	mov  rsi, product
	call printm4x4
	jmp  exit

singular:
; Вывод сообщения об ошибке
	mov  rdi, fmt10
	call printf

exit:
	leave
	ret
;-----------------------------------------------------------

inverse4x4:
section .data
	align 32
	.identity   dq 1., 0., 0., 0.
	            dq 0., 1., 0., 0.
	            dq 0., 0., 1., 0.
	            dq 0., 0., 0., 1.

	.minus_mask dq 8000000000000000h
	.size       dq 4	; размер матрицы 4x4
; Коэффициенты
	.one        dq 1.0
	.two        dq 2.0
	.three      dq 3.0
	.four       dq 4.0

section .bss
	align 32
	.matrix1 resq 16	; Промежуточная матрица
	.matrix2 resq 16	; Промежуточная матрица
	.matrix3 resq 16	; Промежуточная матрица

	.matrix4 resq 16	; Промежуточная матрица
	.matrixI resq 16
	.mxcsr   resq 1	; Используется для проверки деления на ноль

section .text
	push rbp
	mov  rbp, rsp

	push rsi	; Сохранение адреса обращённой матрицы
	vzeroall	; Очистка всех ymm-регистров

; Вычисление промежуточных матриц
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Вычисление промежуточной матрицы matrix2
; rdi содержит адрес исходной матрицы
	mov  rsi, rdi
	mov  rdx, .matrix2
	push rdi
	call multi4x4
	pop  rdi

; Вычисление промежуточной матрицы matrix3
	mov  rsi, .matrix2
	mov  rdx, .matrix3
	push rdi
	call multi4x4
	pop  rdi

; Вычисление промежуточной матрицы matrix4
	mov  rsi, .matrix3
	mov  rdx, .matrix4
	push rdi
	call multi4x4
	pop  rdi

; Вычисление следов матриц
; ~~~~~~~~~~~~~~~~~~~~~~~~
; Вычисление следа матрицы trace1
	mov  rsi, [.size]
	call vtrace
	movsd xmm8, xmm0	; След 1 (s1) в xmm8

; Вычисление следа матрицы trace2
	push rdi	; Сохраняем адрес исходной матрицы
	mov  rdi, .matrix2

	mov  rsi, [.size]
	call vtrace
	movsd xmm9, xmm0	; След 2 (s2) в xmm9

; Вычисление следа матрицы trace3
	mov  rdi, .matrix3
	mov  rsi, [.size]
	call vtrace
	movsd xmm10, xmm0	; След 3 (s3) в xmm10

; Вычисление следа матрицы trace4
	mov  rdi, .matrix4
	mov  rsi, [.size]
	call vtrace
	movsd xmm11, xmm0	; След 4 (s4) в xmm11

; Вычисление коэффициентов
; ~~~~~~~~~~~~~~~~~~~~~~~~
; Вычисление коэффициента p1
; p1 = -s1
	vxorpd xmm12, xmm8, [.minus_mask]	; p1 в xmm12

; Вычисление коэффициента p2
; p2 = -1/2 * (p1 * s1 + s2)
	movsd xmm13, xmm12	; Копируем p1 в xmm13
	vfmadd213sd xmm13, xmm8, xmm9	; p1 * s1 + s2 --> xmm13 = xmm13 * xmm8 + xmm9
	vxorpd xmm13, xmm13, [.minus_mask]	; p2 будет в xmm13
	divsd xmm13, [.two]	; Делим xmm13 на 2

; Вычисление коэффициента p3
; p3 = -1/3 * (p2 * s1 + p1 * s2 + s3)
	movsd xmm14, xmm12	; Копируем p1 в xmm14
	vfmadd213sd xmm14, xmm9, xmm10	; p1 * s2 + s3    --> xmm14 = xmm14 * xmm9 + xmm10
	vfmadd231sd xmm14, xmm13, xmm8	; xmm14 + p2 * s1 --> xmm14 = xmm14 + xmm13 * xmm8
	vxorpd xmm14, xmm14, [.minus_mask]	; p3 будет в xmm14
	divsd xmm14, [.three]	; Делим xmm14 на 3

; Вычисление коэффициента p4
; p4 = -1/4 * (p3 * s1 + p2 * s2 + p1 * s3 + s4)
	movsd xmm15, xmm12	; Копируем p1 в xmm15
	vfmadd213sd xmm15, xmm10, xmm11	; p1 * s3 + s4    --> xmm15 = xmm15 * xmm10 + xmm11
	vfmadd231sd xmm15, xmm13, xmm9	; xmm15 + p2 * s2 --> xmm15 = xmm15 + xmm13 * xmm9
	vfmadd231sd xmm15, xmm14, xmm8	; xmm15 + p3 * s1 --> xmm15 = xmm15 + xmm14 * xmm8
	vxorpd xmm15, xmm15, [.minus_mask]	; p4 будет в xmm15
	divsd xmm15, [.four]	; Делим xmm15 на 4


; Умножение матриц с чоответствующим коэффициентом
	mov  rcx, [.size]
	xor  eax, eax
	xor  rax, rax	; ??? оставить то, что оптимальнее

	; загружаем значения с плавающей запятой как один кортеж из xmm-регистров в память и трансляция в четыре места в ymm-регистры
	vbroadcastsd ymm1, xmm12	; p1
	vbroadcastsd ymm2, xmm13	; p2
	vbroadcastsd ymm3, xmm14	; p3

	pop  rdi	; Восстанавливаем адрес исходной матрицы

.loop1:
	vmovapd ymm0, [rdi+rax]
	vmulpd ymm0, ymm0, ymm2
	vmovapd [.matrix1+rax], ymm0

	vmovapd ymm0, [.matrix2+rax]
	vmulpd ymm0, ymm0, ymm1
	vmovapd [.matrix2+rax], ymm0

	vmovapd ymm0, [.identity+rax]
	vmulpd ymm0, ymm0, ymm3
	vmovapd [.matrixI+rax], ymm0

	add rax, 32
	loop .loop1

; Сложение 4х матриц и умножение на -1/p4
	mov  rcx, [.size]
; Вычисление -1/p4
	movsd xmm0, [.one]
	vdivsd xmm0, xmm0, xmm15	; 1/p4
; Проверка деления на ноль
	stmxcsr [.mxcsr]
	and  dword[.mxcsr], 4
	jnz  .singular

; Нет деления на ноль
	pop  rsi	; Восстановление адреса обращенной матрицы
	vxorpd xmm0, xmm0, [.minus_mask]	; -1/p4
	vbroadcastsd ymm2, xmm0

	xor  rax, rax


; Цикл по строкам
.loop2:
	; Складываем строки
	vmovapd ymm0, [.matrix1+rax]
	vaddpd ymm0, ymm0, [.matrix2+rax]
	vaddpd ymm0, ymm0, [.matrix3+rax]
	vaddpd ymm0, ymm0, [.matrixI+rax]
	vmulpd ymm0, ymm0, ymm2	; Умножение строки на -1/p4
	vmovapd [rsi+rax], ymm0
	add  rax, 32
	loop .loop2

	xor  eax, eax	; Возвращаем 0 -- нет ошибок
	leave
	ret

.singular:
	mov  eax, 1	; Возвращаем 1 -- вырожденная (сингулярная) матрица
	leave
	ret
;-----------------------------------------------------------

; Вычисление следа матрицы
vtrace:
	push rbp
	mov  rbp, rsp

; Формирование матрицы в памяти
	vmovapd ymm0, [rdi]
	vmovapd ymm1, [rdi+32]
	vmovapd ymm2, [rdi+64]
	vmovapd ymm3, [rdi+96]

	vblendpd ymm0, ymm0, ymm1, 0010b
	vblendpd ymm0, ymm0, ymm2, 0100b
	vblendpd ymm0, ymm0, ymm3, 1000b

	vhaddpd ymm0, ymm0, ymm0
	vpermpd ymm0, ymm0, 00100111b
	haddpd xmm0, xmm0

	leave
	ret
;-----------------------------------------------------------


printm4x4:
section .data
	.fmt db "%f",9, "%f",9, "%f",9, "%f",10,0

section .text
	push rbp
	mov  rbp, rsp

	push rbx	; Сохраняем регистр
	push r15	; too
	mov  rdi, .fmt
	mov  rcx, 4	; Количество строк матрицы
	xor  rbx, rbx	; Счётчик строк
.loop:
;	movsd xmm0, [rsi+rbx]
	movq xmm0, [rsi+rbx]

;	movsd xmm1, [rsi+rbx+8]
	movq xmm1, [rsi+rbx+8]

;	movsd xmm2, [rsi+rbx+16]
	movq xmm2, [rsi+rbx+16]

;	movsd xmm3, [rsi+rbx+24]
	movq xmm3, [rsi+rbx+24]

	mov  rax, 4	; Четыре числа с плавающей точкой (в строке)
	push rcx
	push rsi
	push rdi

	; Выравнивание стека, если необходимо
	xor  r15, r15
	test rsp, 0xf	; Последний байт равен 8 (стек не выровнен)?
	setnz r15b	; Установить флаг, если стек не выровнен
	shl r15, 3	; Умножаем на 8
	sub rsp, r15	; Вычитаем 0 или 8 (выравниваем стек)
	call printf

	add rsp, r15	; Возвращаем стек в исходное состояние
	pop rdi
	pop rsi
	pop rcx


	add rbx, 32	; Следующая строка
	loop .loop

	pop r15
	pop rbx

leave
ret
;-----------------------------------------------------------

multi4x4:
	push rbp
	mov  rbp, rsp

	xor  rax, rax
	mov  rcx, 4
	vzeroall	; Обнуление всех ymm-регистров
.loop:
	vmovapd ymm0, [rsi]

	vbroadcastsd ymm1, [rdi+rax]
	vfmadd231pd ymm12, ymm1, ymm0

	vbroadcastsd ymm1, [rdi+32+rax]
	vfmadd231pd ymm13, ymm1, ymm0

	vbroadcastsd ymm1, [rdi+64+rax]
	vfmadd231pd ymm14, ymm1, ymm0

	vbroadcastsd ymm1, [rdi+96+rax]
	vfmadd231pd ymm15, ymm1, ymm0

	add  rax, 8	; Один элемент содержит 8 байт (64 бит)
	add  rsi, 32	; Каждая строка содержит 32 байта (256 бит)
	loop .loop

; Перемещение результата в память, строка за строкой
	vmovapd [rdx], ymm12
	vmovapd [rdx+32], ymm13
	vmovapd [rdx+64], ymm14
	vmovapd [rdx+96], ymm15
	xor  eax, eax	; 0 -- возврат значения

leave
ret

; vim:ft=nasm
