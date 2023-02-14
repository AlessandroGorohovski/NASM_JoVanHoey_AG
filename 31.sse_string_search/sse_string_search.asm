;asmsyntax=nasm
;sse_string_search.asm --- Поиск в строках

extern printf

section .data
;	Шаблон      123456789012345678901234567890123456789012345  6
;	Шаблон      0123456789abcdef0123456789abcdef0123456789abc  d
	string1 db "The quick brown fox jumps over the lazy river",0	; Строка, где ищем символ
	string2 db "e",0	; Искомый символ
	fmt1    db "This is our string: %s ",10,0
	fmt2    db "The first '%s' is at position %d.",10,0
	fmt3    db "The last '%s' is at position %d.",10,0
	fmt4    db "The character '%s' didn't show up!.",10,0

section .bss

section .text
	global main
main:
	push rbp
	mov  rbp, rsp

	mov  rdi, fmt1
	mov  rsi, string1
	xor  eax, eax	; !AG
	call printf

; Поиск первого вхождения
	mov  rdi, string1
	mov  rsi, string2
	call pstrscan_f
	cmp  rax, 0
	je   no_show

	mov  rdi, fmt2
	mov  rsi, string2
	mov  rdx, rax
	xor  eax, eax	; !AG
	call printf

; Поиск последнего вхождения
	mov  rdi, string1
	mov  rsi, string2
	call pstrscan_l

	mov  rdi, fmt3
	mov  rsi, string2
	mov  rdx, rax
	xor  eax, eax	; !AG

	call printf
	jmp  exit

no_show:
	mov  rdi, fmt4
	mov  rsi, string2
	xor  eax, eax
	call printf

exit:
; Выход
	leave
	ret
;-----------------------------------------------------------

; Функция Поиска первого вхождения
pstrscan_f:
	push rbp
	mov  rbp, rsp

	xor  eax, eax
	pxor xmm0, xmm0
	pinsrb xmm0, [rsi], 0	; Помещаем искомый аргумент в младший (0-й) байт регистра xmm0

.block_loop:
	pcmpistri xmm0, [rdi+rax], 00000000b	; Поиск "Равенство в любой позиции" заданного символа
	jc   .found
	jz   .none	; Находимся в последнем 16-ти байтном блоке? (ZF=1, если обнаружен 0)

	add  rax, 16
	jmp  .block_loop

.found:
	add  rax, rcx	; rcx содержит позицию символа
	inc  rax	; Начало отсчёта с 1 вместо 0
	leave
	ret

.none:
	xor  eax, eax	; Ничего не найдено, возвращаем 0
	leave
	ret
;-----------------------------------------------------------

; Функция Поcледнего вхождения
pstrscan_l:
	push rbp
	mov  rbp, rsp

	push rbx

	push r12
	xor  eax, eax
	pxor xmm0, xmm0
	pinsrb xmm0, [rsi], 0	; Помещаем искомый аргумент в младший (0-й) байт регистра xmm0
	xor  r12, r12

.block_loop:
	pcmpistri xmm0, [rdi+rax], 01000000b	; Поиск заданного символа из условия "Равенство в любой позиции и НЕ самый младший индекс"
	setz bl	; если ZF=1 (обнаружен 0) --> bl = 1, иначе bl = 0
	jc   .found
	jz   .done

	add  rax, 16
	jmp  .block_loop

.found:
	mov  r12, rax
	add  r12, rcx	; rcx содержит позицию символа
	inc  r12	; Начало отсчёта с 1 вместо 0
	cmp  bl, 1
	je   .done

	add  rax, 16
	jmp  .block_loop

	pop  r12	; ?AG не понятно когда исполняется
	pop  rbx
	leave
	ret

.done:
	mov  rax, r12	; Ничего не найдено, возвращаем 0
	pop  r12
	pop  rbx
	leave
	ret

