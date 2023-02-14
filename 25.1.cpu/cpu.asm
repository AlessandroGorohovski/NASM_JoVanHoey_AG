;asmsyntax=nasm
;cpu.asm
extern printf

section .data
	fmt_no_sse db "This CPU does not support SSE",10,0
	fmt_sse42  db "This CPU supports SSE 4.2",10,0
	fmt_sse41  db "This CPU supports SSE 4.1",10,0
	fmt_ssse3  db "This CPU supports SSSE 3",10,0
	fmt_sse3   db "This CPU supports SSE 3",10,0
	fmt_sse2   db "This CPU supports SSE 2",10,0
	fmt_sse    db "This CPU supports SSE",10,0

section .bss

section .text
	global main
main:
	push rbp
	mov rbp, rsp
	call cpu_sse	; Возращает 1 в rax, если поддерживается SSE, иначе 0

leave
ret
;-----------------------------------------------------------

cpu_sse:
	push rbp
	mov rbp, rsp

	xor r12, r12	; Флаг доступности SSE
	mov eax, 1	; Запрос флагов характеристик CPU
	cpuid

; Проверка поддержки SSE
	test edx, 2000000h	; Проверка 25-го бита (SSE), i.e.: 10000000000000000000000000b
	jz sse2

	mov r12, 1	; SSE-инструкции доступны
	xor rax, rax	; не используется xmm-регистры, т.е. без чисел с плавающей точкой
	mov rdi, fmt_sse
	push rcx	; Изменяется функцией printf
	push rdx	; Сохранение результата cpuid
	call printf
	pop rdx
	pop rcx

sse2:
	test edx, 4000000h	; Проверка 26-го бита (SSE-2)
	jz sse3


	mov r12, 1	; Версия SSE-2 доступна
	xor rax, rax
	mov rdi, fmt_sse2
	push rcx
	push rdx		; ??? Зачем сохранять
	call printf
	pop rdx
	pop rcx

sse3:
	test ecx, 1	; Проверка бита 0 (SSE-3)
	jz ssse3

	mov r12, 1	; Версия SSE-3 доступна
	xor rax, rax
	mov rdi, fmt_sse3
	push rcx
	call printf
	pop rcx

ssse3:
	test ecx, 9h	; Проверка битов 8 и 0 (SSE-3)
	jz sse41

	mov r12, 1	; Версия SSSE-3 доступна
	xor rax, rax
	mov rdi, fmt_ssse3
	push rcx
	call printf
	pop rcx

sse41:
	test ecx, 80000h	; Проверка бита 19 (SSE-4.1)
	jz sse42

	mov r12, 1	; Версия SSE-4.1 доступна
	xor rax, rax
	mov rdi, fmt_sse41
	push rcx
	call printf
	pop rcx

sse42:
	test ecx, 100000h	; Проверка бита 20 (SSE-4.2)
	jz wrapup

	mov r12, 1	; Версия SSE-4.2 доступна
	xor rax, rax
	mov rdi, fmt_sse42

	push rcx
	call printf
	pop rcx

wrapup:
	cmp r12, 1
	je sse_ok

	xor rax, rax
	mov rdi, fmt_no_sse
	call printf	; Вывод сообщения о недоступности SSE-инструкций
	jmp the_exit

sse_ok:
	mov rax, r12
the_exit:
	leave
	ret


