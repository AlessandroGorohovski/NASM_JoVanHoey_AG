;asmsyntax=nasm
;sse_string3_exp.asm --- Сравнение строк с неявно заданной длиной

extern printf

section .data
	string1 db "the quick brown fox jumps over the lazy river"
	string1Len equ $ - string1
	string2 db "the quick brown fox jumps over the lazy river"
	string2Len equ $ - string2

	dummy   db "confuse the world"

	string3 db "the quick brown fox jumps over the lazy dog"
	string3Len equ $ - string3

	fmt1    db "Strings 1 and 2 are equal.",10,0
	fmt11   db "Strings 1 and 2 differ at position %i.",10,0
	fmt2    db "Strings 2 and 3 are equal.",10,0
	fmt22   db "Strings 2 and 3 differ at position %i.",10,0

section .bss
	buffer resb 64

section .text
	global main
main:
	push rbp
	mov  rbp, rsp

; ~~~~~~~~~~~~~~~~~~~~~~
; Сравнение строк 1 и 2
; ~~~~~~~~~~~~~~~~~~~~~~
	mov  rdi, string1
	mov  rsi, string2
	mov  rdx, string1Len
	mov  rcx, string2Len
	call pstrcmp
	push rax	; Сохраняем результат для дальнейшего пользования

; Вывод строк 1 и 2 и результата
; сначала создаётся строка с символом перехода на новую строку и завершающим 0
; string1
	mov  rsi, string1
	mov  rdi, buffer
	mov  rcx, string1Len
	rep  movsb
	mov byte[rdi], 10	; Добавляем NL в буфер
	inc rdi	; Добавляем завершающий 0 в буфер
	mov byte[rdi], 0

;	mov word[rdi], 0x000A	; !AG

; Вывод
	mov  rdi, buffer
	xor  eax, eax	; !AG
	call printf

; string2
	mov  rsi, string2
	mov  rdi, buffer
	mov  rcx, string2Len
	rep  movsb
	mov byte[rdi], 10	; Добавляем NL в буфер
	inc rdi	; Добавляем завершающий 0 в буфер
	mov byte[rdi], 0
;	mov word[rdi], 0x000A	; !AG

; Вывод
	mov  rdi, buffer
	xor  eax, eax	; !AG
	call printf

; Теперь вывод результата сравнения
	pop  rax	; Достаём результат сревнения
	mov  rdi, fmt1
	cmp  rax, 0
	je   eql_1	; Строки равны

	mov  rdi, fmt11	; Строки НЕ равны
eql_1:
	mov  rsi, rax
	xor  eax, eax	; !AG
	call printf

; ~~~~~~~~~~~~~~~~~~~~~~
; Сравнение строк 2 и 3
; ~~~~~~~~~~~~~~~~~~~~~~
	mov  rdi, string2
	mov  rsi, string3
	mov  rdx, string2Len
	mov  rcx, string3Len
	call pstrcmp
	push rax	; Сохраняем результат для дальнейшего пользования

; Вывод строки 3 и результата
; сначала создаётся строка с символом перехода на новую строку и завершающим 0
; string3
	mov  rsi, string3
	mov  rdi, buffer
	mov  rcx, string3Len

	rep  movsb
	mov byte[rdi], 10	; Добавляем NL в буфер
	inc rdi	; Добавляем завершающий 0 в буфер
	mov byte[rdi], 0
;	mov word[rdi], 0x000A	; !AG

; Вывод
	mov  rdi, buffer
	xor  eax, eax	; !AG
	call printf

; Теперь вывод результата сравнения
	pop  rax	; Достаём результат сревнения
	mov  rdi, fmt2
	cmp  rax, 0
	je   eql_2	; Строки равны

	mov  rdi, fmt22	; Строки НЕ равны
eql_2:
	mov  rsi, rax
	xor  eax, eax	; !AG
	call printf

; Выход
	leave
	ret
;-----------------------------------------------------------

; Функция Сравнения строк
pstrcmp:
	push rbp
	mov  rbp, rsp

	xor  ebx, ebx
	mov  rax, rdx	; В rax помещаем длину 1-й строки
	mov  rdx, rcx	; В rdx помещаем длину 2-й строки
	xor  ecx, ecx	; ecx -- индекс

.loop:
	movdqu xmm1, [rdi+rbx]
; 00011000 -- Метод "равенство любому символу из заданного набора" (equal each) | отрицательная ориентация (справа налево)
	pcmpestri xmm1, [rsi+rbx], 0x18
	jc   .differ
	jz   .equal

	add  rbx, 16
	sub  rax, 16
	sub  rdx, 16
	jmp  .loop


.differ:
	mov  rax, rbx
	add  rax, rcx	; Позиция отличающегося символа
	inc  rax	; Потому что индекс начинается с 0
	jmp  .exit

.equal:
	xor  eax, eax
.exit:
	leave
	ret
