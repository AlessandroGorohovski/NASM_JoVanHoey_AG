;asmsyntax=nasm
;mxcsr.asm
extern printf
extern print_mxcsr
extern print_hex

section .data
	eleven dq 11.0
	two    dq 2.0
	three  dq 3.0
	ten    dq 10.0
	zero   dq 0.0

	hex  db "0x",0
	fmt1 db 10,"Divide, default mxcsr:",10,0
	fmt2 db 10,"Divide by zero, default mxcsr:",10,0
	fmt4 db 10,"Divide, round up:",10,0
	fmt5 db 10,"Divide, round down:",10,0
	fmt6 db 10,"Divide, truncate:",10,0
	f_div db "%.1f divided by %.1f is %.16f, in hex: ",0
	f_before db 10,"mxcsr before:",9,0
	f_after db "mxcsr after:",9,0

; Значения регистра mxcsr
	default_mxcsr dd 0001111110000000b
	round_nearest dd 0001111110000000b
	round_down    dd 0011111110000000b
	round_up      dd 0101111110000000b
	truncate      dd 0111111110000000b

section .bss
	mxcsr_before resd 1
	mxcsr_after  resd 1
	xmm          resq 1


section .text
	global main
main:
	push rbp
	mov rbp, rsp

; Деление
; Значение mxcsr по умолчанию
	mov rdi, fmt1
	mov rsi, ten
	mov rdx, two
	mov ecx, [default_mxcsr]
	call apply_mxcsr

;---------------------------------------
; Деление с ошибкой потери точности (значимых разрядов)
; Значение mxcsr по умолчанию
	mov rdi, fmt1
	mov rsi, ten
	mov rdx, three
	mov ecx, [default_mxcsr]
	call apply_mxcsr

; Деление на ноль
; Значение mxcsr по умолчанию
	mov rdi, fmt2
	mov rsi, ten
	mov rdx, zero
	mov ecx, [default_mxcsr]
	call apply_mxcsr

; Деление с ошибкой потери точности (значимых разрядов)
; Округление в БОЛЬШУЮ сторону
	mov rdi, fmt4
	mov rsi, ten
	mov rdx, three
	mov ecx, [round_up]
	call apply_mxcsr

; Деление с ошибкой потери точности (значимых разрядов)
; Округление в МЕНЬШУЮ сторону
	mov rdi, fmt5
	mov rsi, ten
	mov rdx, three

	mov ecx, [round_down]
	call apply_mxcsr

; Деление с ошибкой потери точности (значимых разрядов)
; Усечение (отбрасывание разрядов)
	mov rdi, fmt6
	mov rsi, ten
	mov rdx, three
	mov ecx, [truncate]
	call apply_mxcsr

;---------------------------------------
; Деление с ошибкой потери точности (значимых разрядов)
; Значение mxcsr по умолчанию
	mov rdi, fmt1
	mov rsi, eleven
	mov rdx, three
	mov ecx, [default_mxcsr]
	call apply_mxcsr

; Деление с ошибкой потери точности (значимых разрядов)
; Округление в БОЛЬШУЮ сторону
	mov rdi, fmt4
	mov rsi, eleven
	mov rdx, three
	mov ecx, [round_up]
	call apply_mxcsr

; Деление с ошибкой потери точности (значимых разрядов)
; Округление в МЕНЬШУЮ сторону
	mov rdi, fmt5
	mov rsi, eleven
	mov rdx, three
	mov ecx, [round_down]
	call apply_mxcsr

; Деление с ошибкой потери точности (значимых разрядов)
; Усечение (отбрасывание разрядов)
	mov rdi, fmt6
	mov rsi, eleven
	mov rdx, three
	mov ecx, [truncate]
	call apply_mxcsr

; Выход

	leave
;	mov rsp, rbp
;	pop rbp
	ret
;-----------------------------------------------------------

; Функция
apply_mxcsr:
	push rbp
	mov rbp, rsp

	push rsi
	push rdx
	push rcx
	push rbp	; Для выравнивания стека
;	mov rax, 0	; Числа с плав.точкой не участвуют в выводе
	call printf
	pop rbp
	pop rcx
	pop rdx
	pop rsi

	mov [mxcsr_before], ecx
	ldmxcsr [mxcsr_before]	; Загружаем флаги из памяти в регистр mxcsr
	movsd xmm2, [rsi]	; Число с плав.точкой двойной точности в регистр xmm2
	divsd xmm2, [rdx]	; Деление xmm2 на rdx
	stmxcsr [mxcsr_after]	; Сохраняем флаги из mxcsr в память

	movsd [xmm], xmm2	; Для использования в функции print_xmm
	mov rdi, f_div
	movsd xmm0, [rsi]
	movsd xmm1, [rdx]
	call printf
	call print_xmm

; Вывод mxcsr
	mov rdi, f_before
	call printf

	mov rdi, [mxcsr_before]
	call print_mxcsr

	mov rdi, f_after
	call printf


	mov rdi, [mxcsr_after]
	call print_mxcsr

	leave
	ret
;-----------------------------------------------------------

; Функция
print_xmm:
	push rbp
	mov rbp, rsp

	mov rdi, hex	; Вывод префикса 0x
	call printf
	mov rcx, 8
.loop:
	xor rdi, rdi
	mov dil, [xmm+rcx-1]
	push rcx
	call print_hex
	pop rcx
	loop .loop

	leave
	ret


