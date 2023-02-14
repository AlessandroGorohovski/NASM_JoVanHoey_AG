;asmsyntax=nasm
;sse_string6.asm --- Поиск подстроки символов

extern printf
extern print16b

section .data
	string1 db "a quick pink dinosour jumps over the "
	        db "lazy river and the lazy dinosour doesn't mind",10,0
	string2 db "dinosour",0
	NL      db 10,0
	fmt     db "Find the substring '%s' in:",10,0
	fmt_oc  db "I found %ld %ss",10,0

section .bss

section .text
	global main
main:
	push rbp
	mov  rbp, rsp

; Сначала выводятся строки
	mov  rdi, fmt
	mov  rsi, string2
	xor  eax, eax	; !AG
	call printf	; Искомая строка

; Вывод целевой строки
	mov  rdi, string1
	xor  eax, eax	; !AG
	call printf

; Поиск в строке
	mov  rdi, string1
	mov  rsi, string2
	call psubstringsrch

; Вывод кол-ва найденных вхождений заданной подстроки
	mov  rdi, fmt_oc
	mov  rsi, rax
	mov  rdx, string2
	call printf

; Выход

	leave
	ret
;-----------------------------------------------------------

; Функция Поиска подстроки и вывода маски
psubstringsrch:	; Поиск упакованной подстроки
	push rbp
	mov  rbp, rsp

	sub  rsp, 16	; Обеспечение пространства в стеке для сохранения xmm1
	xor  r12, r12	; Для общего кол-ва вхождений
	xor  ecx, ecx	; Для оповещения о конце строки
	xor  ebx, ebx	; Для вычисления адреса
	mov  rax, -16	; Для счётчика байт

; Формирование значения xmm1 -- загрузка подстроки
	pxor xmm1, xmm1	; ?AG: Why? 
	movdqu xmm1, [rsi]
.loop:
	add  rax, 16	; чтобы избежать установки флага
	mov  rsi, 16	; Если нет завершающего 0, то вывод 16 байт
	movdqu xmm2, [rdi+rbx]	; Загрузка 16 байт строки в xmm2

	; Метод "поиск равенства упорядоченной последовательности символов (equal ordered)" + 'байтовая маска в xmm0'
	pcmpistrm xmm1, xmm2, 01001100b
	setz cl	; Установить в 1, если найден завершающий 0
	cmp  cl, 0	; Проверить найден ли завершающий 0 --> определить его позицию
	je   .gotoprint	; Завершающий 0 НЕ найден

; Завершающий 0 НАЙДЕН
; Осталось менее 16 байт
; rdi -- содержит адрес строки
; rbx -- содержит число байт в блоках, обработанных до настоящего момента (ранее)
	add  rdi, rbx	; Адрес оставшейся части строки (взять только хвост этой строки)
	push rcx	; Сохраняем, поскольку меняет вызываемая функция 'pstrlen'
	call pstrlen	; Определение позиции завершающего 0. В rax возвращается длина
	pop  rcx
	dec  rax	; Длина без завершающего 0
	mov  rsi, rax	; Кол-во байт в хвосте строки

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
	mov  rax, r12	; Возвращаем кол-во найденных символов

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
	add  rax, 16	; чтобы избежать установки флага ZF, если rax = 0 после pcmpistri
	; 0000_1000 -- Метод "равенство любому символу из заданного набора" (equal each)
	pcmpistri xmm0, [rdi+rax], 0x08
	jnz  .loop	; Завершающий 0 найден?

	add  rax, rcx	; rax = число уже обработанных байт
	             	; rcx = число байтов, обработанных на последней итерации цикла
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
	; Маска для реверсирования
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
