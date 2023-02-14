;asmsyntax=nasm
;sse_string4.asm --- Поиск символов

extern printf
extern print16b

section .data
	string1 db "qdacdekkfijlmdoza"
	        db "becdfgdklkmdddaf"
	        db "fffffffdedeee",10,0
	string2 db "e",0
	string3 db "a",0
	fmt     db "Find all the characters '%s' and '%s' in:",10,0
	fmt_oc  db "I found %ld characters '%s' and '%s'",10,0
	NL      db 10,0

section .bss

section .text
	global main
main:
	push rbp
	mov  rbp, rsp

; Вывод искомых символов
	mov  rdi, fmt
	mov  rsi, string2
	mov  rdx, string3
	xor  eax, eax	; !AG
	call printf

; Вывод целевой строки
	mov  rdi, string1
	xor  eax, eax	; !AG
	call printf

; Поиск в строке и вывод маски
	mov  rdi, string1
	mov  rsi, string2
	mov  rdx, string3
	call pcharsrch

; Вывод числа(кол-ва) вхождений искомых символов в строке string2
	mov  rdi, fmt_oc
	mov  rsi, rax
	mov  rdx, string2
	mov  rcx, string3
	call printf

; Выход

	leave
	ret
;-----------------------------------------------------------

; Функция Поиска в строке и вывода маски
pcharsrch:	; Поиск упакованного символа
	push rbp
	mov  rbp, rsp

	sub  rsp, 16	; Обеспечение пространства в стеке для сохранения xmm1
	xor  r12, r12	; Для общего кол-ва вхождений
	xor  ecx, ecx	; Для оповещения о конце строки
	xor  ebx, ebx	; Для вычисления адреса
	mov  rax, -16	; Для счётчика байт

; Формирование значения xmm1 -- загрузка искомых символов
	pxor xmm1, xmm1
	pinsrb xmm1, byte[rsi], 0	; Первый символ по индексу 0
	pinsrb xmm1, byte[rdx], 1	; Второй символ по индексу 1
.loop:
	add  rax, 16	; чтобы избежать установки флага
	mov  rsi, 16	; Если нет завершающего 0, то вывод 16 байт
	movdqu xmm2, [rdi+rbx]	; Загрузка 16 байт строки в xmm2
	pcmpistrm xmm1, xmm2, 40h	; 0100_0000 -- Метод "равенство в любой позиции" (equal any) + 'байт маски в xmm0'
	setz cl	; Установить в 1, если найден завершающий 0
	cmp  cl, 0	; Проверить найден ли завершающий 0 --> определить его позицию
	je   .gotoprint	; Завершающий 0 НЕ найден

; Завершающий 0 НАЙДЕН
; Осталось менее 16 байт
; rdi -- содержит адрес строки
; rbx -- содержит число байт в блоках, обработанных до настоящего момента
	add  rdi, rbx	; Адрес оставшейся части строки
	push rcx	; Сохраняем, поскольку меняет вызываемая функция 'pstrlen'
	call pstrlen	; В rax возвращается длина
	pop  rcx
	dec  rax	; Длина без завершающего 0
	mov  rsi, rax

; Вывод маски
.gotoprint:
	call print_mask

; Продолжение выполнения для вычисления общего числа совпадений
	popcnt r13d, r13d	; Подсчёт числа битов, равных 1
	add  r12d, r13d	; Сохранение числа вхождений в r12d
	or   cl, cl	; Завершающий 0 обнаружен?
	jnz  .exit

	add  rbx, 16	; Подготовка следующих 16 байт

	jmp  .loop

.exit:
	mov  rdi, NL	; Добавление символа перехода на новую строку
	call printf
	mov  rax, r12	; Кол-во вхождений искомых символов (string2 и string3)

; Выход
	leave
	ret
;-----------------------------------------------------------

; Функция Поиска завершающего 0
pstrlen:
	push rbp
	mov  rbp, rsp

	sub  rsp, 16	; Для сохранения xmm0
	movdqu [rbp-16], xmm0	; Сохраняем в стек xmm0
	mov  rax, -16
	pxor xmm0, xmm0	; Поиск 0 (конца строки)

.loop:
	add  rax, 16	; чтобы избежать установки флага
	; 0000_1000 -- Метод "равенство любому символу из заданного набора" (equal each)
	pcmpistri xmm0, [rdi+rax], 0x08
	jnz  .loop	; Завершающий 0 найден?

	add  rax, rcx	; rax = число уже обработанных байт
	             	; rcx = байты, обработанные в завершающем цикле
	movdqu xmm0, [rbp-16]	; Восстанавливаем xmm0 из стека

; Выход
	leave
	ret
;-----------------------------------------------------------

; Функция вывода маски
; xmm0 -- содержит маску
; rsi -- содержит число бит, которые нужно вывести (16 или меньше)
print_mask:
	push rbp
	mov  rbp, rsp

	sub  rsp, 16	; Для сохранения xmm0
	call reverse_xmm0	; Прямой порядок байтов (от мл. к ст.)
	pmovmskb r13d, xmm0	; Запись байта маски в r13d
	movdqu [rbp-16], xmm1	; Сохраняем в стек xmm1 перед вызовом printf
	push rdi	; rdi -- содержит string1
	mov  edi, r13d	; Содержит маску, которую надо вывести

	push rdx	; Содержит маску
	push rcx	; Содержит флаг конца строки
	call print16b
	pop  rcx
	pop  rdx
	pop  rdi
	movdqu xmm1, [rbp-16]	; Восстановление xmm1 из стека

	leave
	ret
;-----------------------------------------------------------

; Функция вывода маски
reverse_xmm0:

section .data
	; mask for reversing
	.bytereverse db 15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0

section .text
	push rbp
	mov  rbp, rsp

	sub  rsp, 16	; Для сохранения xmm0
	movdqu [rbp-16], xmm2	; Сохраняем в стек
	movdqu xmm2, [.bytereverse]	; Загрузка маски в xmm2
	pshufb xmm0, xmm2	; Перетасовываем
	movdqu xmm2, [rbp-16]	; Восстановление xmm2 из стека

	leave
	ret	; Возвращаем перетасованное значение в xmm0
