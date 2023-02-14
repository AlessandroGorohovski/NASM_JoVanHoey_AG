;asmsyntax=nasm
;function6.asm

extern printf

section .data
	first   db	"A"
	second  db	"B"
	third   db	"C"
	fourth  db	"D"
	fifth   db	"E"
	sixth   db	"F"
	seventh db	"G"
	eighth  db	"H"
	ninth   db	"I"
	tenth   db	"J"
	fmt     db	"The string is: %s",10,0

section .bss
	flist   resb 11	; Длина строки + завершающий 0

section .text
	global main
main:
	push rbp
	mov  rbp, rsp

	mov  rdi, flist	; Длина
	mov  rsi, first	; Заполнение регистров
	mov  rdx, second
	mov  rcx, third
	mov  r8, fourth
	mov  r9, fifth
	push tenth	; Теперь начинается запись в стек
	push ninth	;  в обратном порядке
	push eighth
	push seventh
	push sixth

	call lfunc	; Вызов функции

; Вывод результата
	mov  rdi, fmt
	mov  rsi, flist
	xor  rax, rax
	call printf

leave
ret

;---------------------------------------
lfunc:
	push rbp
	mov  rbp, rsp

;	xor  rax, rax	; Очистка (особенно старшие биты)

; Формируем целевую строку, записывая символы
; в зарезервированную (динамическую) память
	mov  al, byte[rsi]
	mov  [rdi], al
	mov  al, byte[rdx]
	mov  [rdi+1], al
	mov  al, byte[rcx]
	mov  [rdi+2], al
	mov  al, byte[r8]
	mov  [rdi+3], al
	mov  al, byte[r9]
	mov  [rdi+4], al
; Теперь извлечение аргументов из стека
	push rbx	; Сохраняемый вызываемой функцией
;	xor  rbx, rbx

	mov  rax, qword[rbp+16]	; Первое значение: началный указатель стека(ранее сохранён в rbp) + rip + rbp
	mov  bl, byte[rax]	; Извлечение символа "F"
	mov  [rdi+5], bl	; Продолжаем сохранять симолы

	mov  rax, qword[rbp+24]
	mov  bl, byte[rax]	; "G"
	mov  [rdi+6], bl

	mov  rax, qword[rbp+32]
	mov  bl, byte[rax]	; "H"
	mov  [rdi+7], bl


	mov  rax, qword[rbp+40]
	mov  bl, byte[rax]	; "I"
	mov  [rdi+8], bl

	mov  rax, qword[rbp+48]
	mov  bl, byte[rax]	; "J"
	mov  [rdi+9], bl

	mov  bl, 0
	mov  [rdi+10], bl

	pop  rbx	; Восстанавливаем
	mov  rsp, rbp
	pop  rbp
	ret


