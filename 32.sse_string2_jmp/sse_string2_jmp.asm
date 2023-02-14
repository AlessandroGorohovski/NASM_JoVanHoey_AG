;asmsyntax=nasm
;sse_string2_jmp.asm --- Сравнение строк с неявно заданной длиной

extern printf

section .data
	string1 db "the quick brown fox jumps over the lazy river",10,0
	string2 db "the quick brown fox jumps over the lazy river",10,0
	string3 db "the quick brown fox jumps over the lazy dog",10,0
	fmt1    db "Strings 1 and 2 are equal.",10,0
	fmt11   db "Strings 1 and 2 differ at position %i.",10,0
	fmt2    db "Strings 2 and 3 are equal.",10,0
	fmt22   db "Strings 2 and 3 differ at position %i.",10,0

section .bss

section .text
	global main
main:
	push rbp
	mov  rbp, rsp

; Сначала выводятся строки
	mov  rdi, string1
	xor  eax, eax	; !AG
	call printf

	mov  rdi, string2
	xor  eax, eax	; !AG
	call printf

	mov  rdi, string3
	xor  eax, eax	; !AG
	call printf

; Сравнение строк 1 и 2
	mov  rdi, string1
	mov  rsi, string2
	call pstrcmp

	mov  rdi, fmt1
	cmp  rax, 0
	je   eql_1	; Строки равны

	mov  rdi, fmt11	; Строки НЕ равны
eql_1:
	mov  rsi, rax
	xor  eax, eax	; !AG
	call printf


; Сравнение строк 2 и 3
	mov  rdi, string2
	mov  rsi, string3
	call pstrcmp

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

	xor  eax, eax
	xor  ebx, ebx
.loop:
	movdqu xmm1, [rdi+rbx]
; 00011000 -- Метод "равенство любому символу из заданного набора" (equal each) | отрицательная ориентация (справа налево)
	pcmpistri xmm1, [rsi+rbx], 0x18
	jc   .differ
	jz   .equal

	add  rbx, 16
	jmp  .loop

.differ:
	mov  rax, rbx
	add  rax, rcx	; Позиция отличающегося символа
	inc  rax	; Потому что индекс начинается с 0

.equal:
	leave
	ret
