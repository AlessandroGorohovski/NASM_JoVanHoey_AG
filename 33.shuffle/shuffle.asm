;asmsyntax=nasm
;shuffle.asm --- Основные принципы перемешивания строк

extern printf

section .data
	fmt0  db "These are the numbers in memory: ",10,0
	fmt00 db "This is xmm0: ",10,0
	fmt1  db "%d ",0
	fmt2  db "Shuffle-broadcast double word %i:",10,0
	fmt3  db "%d %d %d %d",10,0
	fmt4  db "Shuffle-reverse double word:",10,0
	fmt5  db "Shuffle-reverse packed bytes in xmm0:",10,0
	fmt6  db "Shuffle-rotate left:",10,0
	fmt7  db "Shuffle-rotate right:",10,0
	fmt8  db "%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c",10,0
	fmt9  db "Packed bytes in xmm0:",10,0
	NL    db 10,0

	number1 dd 1
	number2 dd 2
	number3 dd 3
	number4 dd 4

	char  db "abcdefghijklmnop"
	bytereverse db 15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0

section .bss

section .text
	global main
main:
	push rbp
	mov  rbp, rsp

	sub rsp, 32	; Резервируем пространство в стеке для исходного и изменённого xmm0

; ПЕРЕМЕШИВАНИЕ ДВОЙНЫХ СЛОВ
; Сначала выводим числа в обратном порядке
	mov  rdi, fmt0
;	xor  eax, eax	; !AG
	call printf

	mov  rdi, fmt1
	mov  rsi, [number4]
	xor  eax, eax	; !AG
	call printf

	mov  rdi, fmt1
	mov  rsi, [number3]

	xor  eax, eax	; !AG
	call printf

	mov  rdi, fmt1
	mov  rsi, [number2]
	xor  eax, eax	; !AG
	call printf

	mov  rdi, fmt1
	mov  rsi, [number1]
	xor  eax, eax	; !AG
	call printf

	mov  rdi, NL
	call printf

; Наполнение регистра xmm0 числами
	pxor xmm0, xmm0
	pinsrd xmm0, dword[number1], 0
	pinsrd xmm0, dword[number2], 1
	pinsrd xmm0, dword[number3], 2
	pinsrd xmm0, dword[number4], 3
	movdqu [rbp-16], xmm0	; Сохраняем xmm0 для дальнейшего пользования

	mov  rdi, fmt00
	call printf	; Вывод заголовка

	movdqu xmm0, [rbp-16]	; Восстановление xmm0 после printf
	call print_xmm0d	; Вывод xmm0

; ПЕРЕМЕШИВАНИЕ В ПРОИЗВОЛЬНОМ ПОРЯДКЕ
; Перемешивание: случайная перестановка младшего двойного слова (индекс 0)
	movdqu xmm0, [rbp-16]	; Снова Восстановление xmm0 после printf
	pshufd xmm0, xmm0, 00000000b	; Перемешивание

;ovdqu xmm1, [rbp-16]	; Снова Восстановление xmm0 после printf
;pshufd xmm0, xmm1, 00011011b	; Перемешивание

	mov  rdi, fmt2
	mov  rsi, 0
	movdqu [rbp-32], xmm0	; Сохраняем xmm0 для дальнейшего пользования
	call printf	; Вывод заголовка

	movdqu xmm0, [rbp-32]	; Восстановление xmm0 после printf
	call print_xmm0d	; Вывод xmm0

; Перемешивание: случайная перестановка двойного слова с индексом 1
	movdqu xmm0, [rbp-16]	; Восстановление xmm0 после printf
	pshufd xmm0, xmm0, 01010101b	; Перемешивание


	mov  rdi, fmt2
	mov  rsi, 1
	movdqu [rbp-32], xmm0	; Сохраняем xmm0 для дальнейшего пользования
	call printf	; Вывод заголовка

	movdqu xmm0, [rbp-32]	; Восстановление xmm0 после printf
	call print_xmm0d	; Вывод xmm0

; Перемешивание: случайная перестановка двойного слова с индексом 2
	movdqu xmm0, [rbp-16]	; Восстановление xmm0 после printf
	pshufd xmm0, xmm0, 10101010b	; Перемешивание

	mov  rdi, fmt2
	mov  rsi, 2
	movdqu [rbp-32], xmm0	; Сохраняем xmm0 для дальнейшего пользования
	call printf	; Вывод заголовка

	movdqu xmm0, [rbp-32]	; Восстановление xmm0 после printf
	call print_xmm0d	; Вывод xmm0

; Перемешивание: случайная перестановка двойного слова с индексом 3
	movdqu xmm0, [rbp-16]	; Восстановление xmm0 после printf
	pshufd xmm0, xmm0, 11111111b	; Перемешивание

	mov  rdi, fmt2
	mov  rsi, 3
	movdqu [rbp-32], xmm0	; Сохраняем xmm0 для дальнейшего пользования
	call printf	; Вывод заголовка

	movdqu xmm0, [rbp-32]	; Восстановление xmm0 после printf
	call print_xmm0d	; Вывод xmm0

; ПЕРЕМЕШИВАНИЕ: ПЕРЕСТАНОВКА В ОБРАТНОМ ПОРЯДКЕ
; Реверсирование двойных слов
	movdqu xmm0, [rbp-16]	; Восстановление xmm0 после printf
	pshufd xmm0, xmm0, 00011011b	; Перемешивание

	mov  rdi, fmt4
	movdqu [rbp-32], xmm0	; Сохраняем xmm0 для дальнейшего пользования
	call printf	; Вывод заголовка

	movdqu xmm0, [rbp-32]	; Восстановление xmm0 после printf
	call print_xmm0d	; Вывод xmm0

; ПЕРЕМЕШИВАНИЕ: ВРАЩЕНИЕ
; Вращение влево
	movdqu xmm0, [rbp-16]	; Восстановление xmm0 после printf
	pshufd xmm0, xmm0, 10010011b	; Перемешивание

	mov  rdi, fmt6

	movdqu [rbp-32], xmm0	; Сохраняем xmm0 для дальнейшего пользования
	call printf	; Вывод заголовка

	movdqu xmm0, [rbp-32]	; Восстановление xmm0 после printf
	call print_xmm0d	; Вывод xmm0

; Вращение вправо
	movdqu xmm0, [rbp-16]	; Восстановление xmm0 после printf
	pshufd xmm0, xmm0, 00111001b	; Перемешивание

	mov  rdi, fmt7
	movdqu [rbp-32], xmm0	; Сохраняем xmm0 для дальнейшего пользования
	call printf	; Вывод заголовка

	movdqu xmm0, [rbp-32]	; Восстановление xmm0 после printf
	call print_xmm0d	; Вывод xmm0

; ПЕРЕМЕШИВАНИЕ БАЙТОВ
	mov  rdi, fmt9
	call printf	; Вывод заголовка

	movdqu xmm0, [char]	; Загрузка символа в xmm0
	movdqu [rbp-32], xmm0	; Сохраняем xmm0 для дальнейшего пользования
	call print_xmm0b	; Вывод байт из xmm0

	movdqu xmm0, [rbp-32]	; Восстановление xmm0 после printf
	movdqu xmm1, [bytereverse]	; Загрузка маски

	pshufb xmm0, xmm1	; Перемешивание байтов

	mov  rdi, fmt5
	movdqu [rbp-32], xmm0	; Сохраняем xmm0 для дальнейшего пользования
	call printf	; Вывод заголовка

	movdqu xmm0, [rbp-32]	; Восстановление xmm0 после printf
	call print_xmm0b	; Вывод xmm0

; Выход
	leave
	ret
;-----------------------------------------------------------

; Функция Вывода двойных слов
print_xmm0d:
	push rbp
	mov  rbp, rsp

	mov  rdi, fmt3
	xor  eax, eax	; !AG
; Извлечение двойных слов в обратном порядке,

; порядок байт от младшего к старшему (прямой)
	pextrd esi, xmm0, 3
	pextrd edx, xmm0, 2
	pextrd ecx, xmm0, 1
	pextrd r8d, xmm0, 0
	call printf

	leave
	ret
;-----------------------------------------------------------

; Функция Вывода байтов
print_xmm0b:
	push rbp
	mov  rbp, rsp

	mov  rdi, fmt8
	xor  eax, eax	; !AG
; В обратном порядке, прямой порядок байтов
; Сначала используется регистры, затем стек
	pextrb esi, xmm0, 0
	pextrb edx, xmm0, 1
	pextrb ecx, xmm0, 2
	pextrb r8d, xmm0, 3
	pextrb r9d, xmm0, 4

	pextrb eax, xmm0, 15
	push rax
	pextrb eax, xmm0, 14
	push rax
	pextrb eax, xmm0, 13
	push rax
	pextrb eax, xmm0, 12
	push rax
	pextrb eax, xmm0, 11
	push rax
	pextrb eax, xmm0, 10
	push rax
	pextrb eax, xmm0, 9
	push rax
	pextrb eax, xmm0, 8
	push rax
	pextrb eax, xmm0, 7
	push rax
	pextrb eax, xmm0, 6
	push rax
	pextrb eax, xmm0, 5
	push rax
	xor  eax, eax
	call printf


	leave
	ret
