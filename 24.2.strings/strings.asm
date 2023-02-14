;asmsyntax=nasm
;strings.asm

extern printf

section .data
	string1  db  "This is the 1st string.",10,0
	string2  db  "This is the 2nd string.",10,0
	strlen2  equ $ - string2 - 2
	string21 db  "Comparing strings: The strings do not differ.",10,0
	string22 db  "Comparing strings: The strings differ, "
	         db  "starting at position: %d.",10,0
	string3  db  "The quick brown fox jumps over the lazy dog.",0
	strlen3  equ $ - string3 - 2
	string33 db  "Now look at this string: %s",10,0
	string4  db  "z",0
	string44 db  "The character '%s' was found at position: %d.",10,0
	string45 db  "The character '%s' was not found.",10,0
	string46 db  "Scanning for the character '%s'.",10,0

section .bss
section .text
	global main
main:
	push rbp
	mov  rbp, rsp
;---------------------------------------
; Вывод 2х строк
	xor  rax, rax
	mov  rdi, string1
	call printf
	mov  rdi, string2
	call printf
;---------------------------------------
; Сравнение 2х строк
	lea  rdi, [string1]
	lea  rsi, [string2]
;	mov  rdx, strlen2

	mov  rax, strlen2
	call compare1
	cmp  rax, 0
	jnz  not_equal1

; Строки одинаковые, выводим
	mov  rdi, string21
	call printf
	jmp  otherversion

; Строки НЕ одинаковые, выводим
not_equal1:
	mov  rdi, string22
	mov  rsi, rax
	xor  rax, rax
	call printf

;---------------------------------------
; Сравнение 2х строк
otherversion:
	lea  rdi, [string1]
	lea  rsi, [string2]
;	mov  rdx, strlen2
	mov  rax, strlen2
	call compare2
	cmp  rax, 0
	jnz  not_equal2

; Строки одинаковые, выводим
	mov  rdi, string21
	call printf
	jmp  scanning

; Строки НЕ одинаковые, выводим
not_equal2:
	mov  rdi, string22
	mov  rsi, rax
	xor  rax, rax
	call printf

;---------------------------------------
; Поиск символа (сканирование) в строке
; Сначала выводим всю строку
	mov  rdi, string33
	mov  rsi, string3

	xor  rax, rax
	call printf

; Затем выводим искомый аргумент, который может быть только 1 символ
	mov  rdi, string46
	mov  rsi, string4
	xor  rax, rax
	call printf

scanning:
	lea  rdi, [string3]	; Строка
	lea  rsi, [string4]	; Искомый аргумент
	mov  rdx, strlen3
	call cscan
	cmp  rax, 0
	jz   char_not_found

; Символ найден, выводим
	mov  rdi, string44
	mov  rsi, string4
	mov  rdx, rax
	xor  rax, rax
	call printf
	jmp  exit

; Символ НЕ найден, выводим
char_not_found:
	mov  rdi, string45
	mov  rsi, string4
	xor  rax, rax
	call printf

exit:
;	mov rax, 60
;	xor rdi, rdi
;	syscall

	leave
	ret

;=======================================
; ФУНКЦИИ
;=======================================

; Функция-1 сравнения 2х строк

compare1:
;	mov  rcx, rdx
	mov  rcx, rax
	cld
cmpr:
	cmpsb
	jne  notequal
	loop cmpr
	xor  rax, rax
	ret

notequal:
;	mov  rax, strlen2
;	mov  rax, rdx
	dec  rcx	; Корректируем, поскольку был выход из цикла
	sub  rax, rcx	; Вычисление положения в строке
	ret
;---------------------------------------

; Функция-2 сравнения 2х строк
compare2:
;	mov  rcx, rdx
	mov  rcx, rax
	cld
	repe cmpsb
	je   equal2

;	mov  rax, strlen2
;	mov  rax, rdx
	sub  rax, rcx	; Вычисление положения в строке
	ret

equal2:
	xor  rax, rax
	ret
;---------------------------------------

; Функция-2 сравнения 2х строк
cscan:
	mov  rcx, rdx
	lodsb
	cld
	repne scasb
	jne  char_notfound


;	mov  rax, strlen3
	mov  rax, rdx
	sub  rax, rcx	; Вычисление положения в строке
	ret

char_notfound:
	xor  rax, rax
	ret

