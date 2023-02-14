;asmsyntax=nasm
;sse_string_length.asm --- Определение длины строки

extern printf

section .data
;	Шаблон      0123456789abcdef0123456789abcdef0123456789abcd  e
;	Шаблон      1234567890123456789012345678901234567890123456  7
	string1 db "The quick brown fox jumps over the lazy river.",0
	fmt1    db "This is our string: %s ",10,0
	fmt2    db "Our string is %d characters long.",10,0

section .bss

section .text
	global main
main:
	push rbp
	mov  rbp, rsp

	mov  rdi, fmt1
	mov  rsi, string1
	xor  eax, eax
	call printf

	mov  rdi, string1
	call pstrlen

	mov  rdi, fmt2
	mov  rsi, rax
	xor  eax, eax
	call printf

; Выход
	leave
;	mov rsp, rbp
;	pop rbp
	ret
;-----------------------------------------------------------

; Функция вычисление длины строки
pstrlen:
	push rbp
	mov  rbp, rsp

	mov  rax, -16	; Счётчик блоков (блок = 16 байт)
	pxor xmm0, xmm0	; 0 (конец строки) -- искомый символ

.not_found:
	add  rax, 16	; Исключить изменения ZF флага в дальнейшем - после вызова pcmpistri

	pcmpistri xmm0, [rdi+rax], 00001000b	; Поиск "Равенство любому символу из заданного набора" дляцелевого символа
	jnz  .not_found	; 0 не найден

	add  rax, rcx	; rcx содержит индекс завершающего 0
	inc  rax	; Корректировка индекса 0 относительно начала строки

	leave
	ret

