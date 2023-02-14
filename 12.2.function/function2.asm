;asmsyntax=nasm
;function2.asm

extern printf

section .data
	radius  dq	10.0

section .bss
section .text
;-----------------------------
area:	; Площадь круга
section .data
	.pi    dq	3.14159265358979	; Локальная переменная в функции area

section .text
	push rbp
	mov  rbp, rsp

		movsd xmm0, [radius]
;		mulsd xmm0, [radius]
		mulsd xmm0, xmm0

.M1:
		mulsd xmm0, [.pi]

	leave
	ret

;-----------------------------
circum:	; Длина окружности
section .data
	.pi    dq	3.14159265358979	; Локальная переменная в функции circum

section .text
	push rbp
	mov  rbp, rsp


		movsd xmm0, [radius]
;		addsd xmm0, [radius]
		addsd xmm0, xmm0	; Радиус в регистре xmm0
;		jmp  short area.M1
		jmp  area.M1
;		mulsd xmm0, [.pi]

	leave
	ret

;-----------------------------
circle:
	section .data
	.fmt_area   db	"The area of the circle is %f",10,0
	.fmt_circum db	"The circumference is %f",10,0

section .text
	push rbp
	mov  rbp, rsp

	call area
	mov  rdi, .fmt_area
	xor  eax, eax
	inc  eax	; Значение площади в регистре xmm0
	call printf

	call circum
	mov  rdi, .fmt_circum
	xor  eax, eax
	inc  eax	; Значение длины окружности в регистре xmm0
	call printf

	leave
	ret

;-----------------------------
	global main
main:
	push rbp
	mov  rbp, rsp

	call circle

; Выход
	leave
	ret


