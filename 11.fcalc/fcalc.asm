;asmsyntax=nasm
;fcalc.asm

extern printf

section .data
	number1  dq	9.0
	number2  dq	73.0
	fmt      db	"The number are %f and %f",10,0
	fmtfloat db	"%s %f",10,0
	f_sum    db	"The float SUM of %f and %f is %f",10,0
	f_dif    db	"The float DIFFERENCE of %f and %f is %f",10,0
	f_mul    db	"The float PRODUCT of %f and %f is %f",10,0
	f_div    db	"The float DIVISION of %f and %f is %f",10,0
	f_sqrt   db	"The float SQUAREROOT of %f is %f",10,0

section .bss
section .text

	global main
main:
	push rbp
	mov  rbp, rsp

; Вывод чисел
	movsd xmm0, [number1]	; Число с плавающей точкой двойной точности
	movsd xmm1, [number2]
	mov  rdi, fmt
	mov  rax, 2	; Два числа с плавающей точкой
	call printf

; Вычисление суммы
	movsd xmm2, [number1]	; Число с плавающей точкой двойной точности
	addsd xmm2, [number2]	; Складываем
; Вывод результата
	movsd xmm0, [number1]
	movsd xmm1, [number2]
	mov  rdi, f_sum

	mov  rax, 3	; Три числа с плавающей точкой
	call printf

; Вычисление разности
	movsd xmm2, [number1]	; Число с плавающей точкой двойной точности
	subsd xmm2, [number2]	; Вычитаем
; Вывод результата
	movsd xmm0, [number1]
	movsd xmm1, [number2]
	mov  rdi, f_dif
	mov  rax, 3	; Три числа с плавающей точкой
	call printf

; Умножение
	movsd xmm2, [number1]	; Число с плавающей точкой двойной точности
	mulsd xmm2, [number2]	; Умножение заданного числа с xmm
; Вывод результата
	movsd xmm0, [number1]
	movsd xmm1, [number2]
	mov  rdi, f_mul
	mov  rax, 3	; Три числа с плавающей точкой
	call printf

; Деление
	movsd xmm2, [number1]	; Число с плавающей точкой двойной точности
	divsd xmm2, [number2]	; Деление xmm2 на заданное число
; Вывод результата
	movsd xmm0, [number1]
	movsd xmm1, [number2]
	mov  rdi, f_div
	mov  rax, 1	; Одно число с плавающей точкой, ИМХО, не влияет
;	mov  rax, 3	; Три числа с плавающей точкой
	call printf

; Вычисление квадратного корня
	sqrtsd xmm1, [number1]	; Квадратный корень двойной точности в xmm1
; Вывод результата
	movsd xmm0, [number1]
	mov  rdi, f_sqrt
	mov  rax, 2	; Два числа с плавающей точкой
	call printf

; Выход
	leave
	ret
