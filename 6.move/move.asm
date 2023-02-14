; move.asm
section	.data
      	bNum  	db 123
      	wNum  	dw 12345
      	dNum  	dd 1234567890
      	qNum1 	dq 1234567890123456789
      	qNum2 	dq 123456
      	qNum3 	dq 3.14
section	.bss
section	.text
      	global main
main:
	push rbp
	mov  rbp, rsp

	mov  rax, -1	; Заполнение регистра rax единицами
	mov  al, byte [bNum]	; Верхние (старшие) биты регистра rax НЕ очищаются
	xor  rax, rax	; Очистка регистра rax
	mov  al, byte [bNum]	; Теперь rax содержит корректное значение

	mov  rax, -1	; Заполнение регистра rax единицами
	mov  ax, word [wNum]	; Верхние (старшие) биты регистра rax НЕ очищаются
	xor  rax, rax	; Очистка регистра rax
	mov  ax, word [wNum]	; Теперь rax содержит корректное значение

	mov  rax, -1	; Заполнение регистра rax единицами
	mov  eax, dword [dNum]	; Верхние (старшие) биты регистра rax очищаются

	mov  rax, -1	; Заполнение регистра rax единицами
	mov  rax, qword [qNum1]	; Верхние (старшие) биты регистра rax очищаются

	mov  qword [qNum2], rax	; Один операнд всегда должен быть регистром
	mov  rax, 123456	; Операнд-источник -- константа
	movq xmm0, [qNum3]	; Инструкция для числа с плавающей точкой

	mov  rsp, rbp
	pop  rbp

	ret	; Выход
