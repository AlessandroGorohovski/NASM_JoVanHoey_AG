;asmsyntax=nasm
;cpu_avx.asm

extern printf

section .data
	fmt_noavx    db "This CPU does not support AVX.",10,0
	fmt_avx      db "This CPU supports AVX.",10,0
	fmt_noavx2   db "This CPU does not supports AVX-2.",10,0
	fmt_avx2     db "This CPU supports AVX2.",10,0
	fmt_noavx512 db "This CPU does not supports AVX-512.",10,0
	fmt_avx512   db "This CPU supports AVX-512.",10,0

section .bss

section .text
	global main
main:
	push rbp
	mov  rbp, rsp
	call cpu_sse	; Возращает 1 в rax, если поддерживается AVX; иначе 0

leave
ret
;-----------------------------------------------------------

cpu_sse:
	push rbp
	mov  rbp, rsp

; Проверка поддержки AVX
	mov  eax, 1	; Запрос флагов характеристик CPU
	cpuid
	mov  eax, 28	; Для проверка бита 28 в ecx
	bt   ecx, eax
	jnc  no_avx

; Есть поддержка AVX
	xor  eax, eax
	mov  rdi, fmt_avx
	call printf

; Проверка поддержки AVX-2
	mov  eax, 7	; Запрос флагов характеристик CPU
	xor  ecx, ecx
	cpuid
	mov  eax, 5	; Для проверка бита 5 в ebx
	bt   ebx, eax
	jnc  no_avx2


	xor  eax, eax
	mov  rdi, fmt_avx2
	call printf

; Проверка поддержки основных функций AVX-512
	mov  eax, 7	; Запрос флагов характеристик CPU
	xor  ecx, ecx
	cpuid
	mov  eax, 16	; Для проверка бита 16 в ebx
	bt   ebx, eax
	jnc  no_avx512

	xor  eax, eax
	mov  rdi, fmt_avx512
	call printf
	xor  eax, eax
	inc  eax
	jmp  the_exit1	; Выход

no_avx:
	xor  eax, eax
	mov  rdi, fmt_noavx
	call printf	; Вывод сообщения, если AVX не поддерживается
	jmp  the_exit0	; Выход

no_avx2:
	xor  eax, eax
	mov  rdi, fmt_noavx2
	call printf	; Вывод сообщения, если AVX не поддерживается
	jmp  the_exit0	; Выход

no_avx512:
	xor  eax, eax
	mov  rdi, fmt_noavx512
	call printf	; Вывод сообщения, если AVX не поддерживается

the_exit0:
	xor  eax, eax	; Возврат 0 -- AVX не поддерживается

the_exit1:
	leave
	ret
