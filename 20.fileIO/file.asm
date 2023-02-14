;asmsyntax=nasm
;file.asm

section .data
; Выражения, которые используем для условного ассемблирования
	CREATE    equ 1
	OVERWRITE equ 1
	APPEND    equ 1
	O_WRITE   equ 1
	READ      equ 1
	O_READ    equ 1
	DELETE    equ 0

; Символические имена системных вызовов
	NR_read   equ 0
	NR_write  equ 1
	NR_open   equ 2
	NR_close  equ 3
	NR_lseek  equ 8
	NR_create equ 85
	NR_unlink equ 87

; Флаги создания и состояния файлов
	O_CREAT   equ 00000100q	; ???
	O_APPEND  equ 00002000q

; Режимы доступа
	O_RDONLY  equ 000000q
	O_WRONLY  equ 000001q
	O_RDWR    equ 000002q

; Режимы при создании файла (права доступа)
	S_IRUSR   equ 00400q	; Права на ЧТЕНИЕ для владельца
	S_IWUSR   equ 00200q	; Права на ЗАПИСЬ для владельца

	NL        equ 0xa
	bufferlen equ 64
	fileName  db  "testfile.txt",0
	FD        dq  0	; Дескриптор файла

	text1 db "1. Hello...to everyone!",NL,0
	len1  equ $ - text1 - 1	; Длина без 0
	text2 db "2. Here I am!",NL,0
	len2  equ $ - text2 - 1	; Длина без 0
	text3 db "3. Alife and kicking!",NL,0
	len3  equ $ - text3 - 1	; Длина без 0
	text4 db "Adios !!!",NL,0
	len4  equ $ - text4 - 1	; Длина без 0

	error_Create db "error creating file",NL,0

	error_Close  db "error closing file",NL,0
	error_Write  db "error writing to file",NL,0
	error_Open   db "error opening file",NL,0
	error_Append db "error appending to file",NL,0
	error_Delete db "error deleting file",NL,0
	error_Read   db "error reading file",NL,0
	error_Print  db "error printing string",NL,0
	error_Position db "error positioning in file",NL,0

	success_Create db "File created and opened",NL,0
	success_Close  db "File closed",NL,NL,0
	success_Write  db "Written to file",NL,0
	success_Open   db "File opened for R/W",NL,0
	success_Append db "File opened for appending",NL,0
	success_Delete db "File deleted",NL,0
	success_Read   db "Reading file",NL,0
	success_Position db "Positioned in file",NL,0

section .bss
	buffer resb bufferlen

section .text
	global main
main:
	push rbp
	mov  rbp, rsp

%IF CREATE
; СОЗДАНИЕ и ОТКРЫТИЕ ФАЙЛА, ЗАТЕМ ЗАКРЫТИЕ ----------------
; Создание и открытие файла
	mov  rdi, fileName
	call createFile
	mov  qword [FD], rax	; Сохраняем дескриптор файла

; Запись в файл #1
	mov  rdi, qword [FD]
	mov  rsi, text1
;	mov  rdx, qword [len1]
	mov  rdx, len1
	call writeFile

; Закрытие файла
	mov  rdi, qword [FD]
	call closeFile
%ENDIF

%IF OVERWRITE
; ОТКРЫТИЕ И ПЕРЕЗАПИСЬ ФАЙЛА, ЗАТЕМ ЗАКРЫТИЕ ----------------
; Открытие файла
	mov  rdi, fileName

	call openFile
	mov  qword [FD], rax	; Сохраняем дескриптор файла

; Запись в файл #2 - ПЕРЕЗАПИСЬ (ЗАМЕЩЕНИЕ)!
	mov  rdi, qword [FD]
	mov  rsi, text2
;	mov  rdx, qword [len2]
	mov  rdx, len2
	call writeFile

; Закрытие файла
	mov  rdi, qword [FD]
	call closeFile
%ENDIF

%IF APPEND
; ОТКРЫТИЕ И ДОБАВЛЕНИЕ В ФАЙЛ, ЗАТЕМ ЗАКРЫТИЕ ----------------
; Открытие файла для добавления в него данных
	mov  rdi, fileName
	call appendFile
	mov  qword [FD], rax	; Сохраняем дескриптор файла

; Запись в файл #3 - ДОБАВЛЕНИЕ!
	mov  rdi, qword [FD]
	mov  rsi, text3
;	mov  rdx, qword [len3]
	mov  rdx, len3
	call writeFile

; Закрытие файла
	mov  rdi, qword [FD]
	call closeFile
%ENDIF

%IF O_WRITE
; ОТКРЫТИЕ И ПЕРЕЗАПИСЬ ПО ПОЗИЦИИ СМЕЩЕНИЯ В ФАЙЛЕ, ЗАТЕМ ЗАКРЫТИЕ ----------------
; Открытие файла для записи
	mov  rdi, fileName
	call openFile
	mov  qword [FD], rax	; Сохраняем дескриптор файла

; Позиция в файле, определяемая по смещению
	mov  rdi, qword [FD]
;	mov  rsi, qword [len2]	; Смещение в заданную позицию
	mov  rsi, len2	; Смещение в заданную позицию
	mov  rdx, 0
	call positionFile

; Запись в файл в позицию с заданным смещением
	mov  rdi, qword [FD]

	mov  rsi, text4
;	mov  rdx, qword [len4]
	mov  rdx, len4
	call writeFile

; Закрытие файла
	mov  rdi, qword [FD]
	call closeFile
%ENDIF

%IF READ
; ОТКРЫТИЕ И ЧТЕНИЕ ИЗ ФАЙЛА, ЗАТЕМ ЗАКРЫТИЕ ----------------
; Открытие файла для чтения
	mov  rdi, fileName
	call openFile
	mov  qword [FD], rax	; Сохраняем дескриптор файла

; Чтение из файла
	mov  rdi, qword [FD]
	mov  rsi, buffer
	mov  rdx, bufferlen	; Количество считываем символов
	call readFile
	mov  rdi, rax
	call printString

; Закрытие файла
	mov  rdi, qword [FD]
	call closeFile
%ENDIF

%IF O_READ
; ОТКРЫТИЕ И ЧТЕНИЕ В ПОЗИЦИИ, ЗАДАННОЙ СМЕЩЕНИЕМ В ФАЙЛЕ, ЗАТЕМ ЗАКРЫТИЕ ----------------
; Открытие файла для чтения
	mov  rdi, fileName
	call openFile
	mov  qword [FD], rax	; Сохраняем дескриптор файла

; Позиция в файле, определяемая по смещению
	mov  rdi, qword [FD]
;	mov  rsi, qword [len2]	; Смещение в заданную позицию / Пропустить первую строку
	mov  rsi, len2	; Смещение в заданную позицию / Пропустить первую строку
	mov  rdx, 0
	call positionFile

; Чтение из файла (в заданной позиции)
	mov  rdi, qword [FD]
	mov  rsi, buffer
	mov  rdx, 10	; Количество считываем символов. Почему бы не bufferlen ?
	call readFile
	mov  rdi, rax

	call printString

; Закрытие файла
	mov  rdi, qword [FD]
	call closeFile
%ENDIF

%IF DELETE
; УДАЛЕНИЕ ФАЙЛА -------------------------------------------
; Для использования убрать символы комментариев в следующих строках
	mov  rdi, fileName
	call deleteFile
%ENDIF

	leave
	ret

; ФУНКЦИИ ОБРАБОТКИ ФАЙЛА ----------------------------------
;-----------------------------------------------------------
global readFile
readFile:
	mov  rax, NR_read
	syscall	; в rax возвращается кол-во считанных символов,
	cmp  rax, 0	; или отрицательное значение, когда ошибка
	jl   readerror

	mov  byte [rsi+rax], 0	; Добавление завершающего 0
	mov  rax, rsi
	mov  rdi, success_Read
	push rax	; Сохраняем
	call printString
	pop  rax	; Восстанавливаем
	ret

readerror:
	mov  rdi, error_Read
	call printString
	ret
;-----------------------------------------------------------

global deleteFile
deleteFile:
	mov  rax, NR_unlink
	syscall
	cmp  rax, 0	; когда ошибка - отрицательное значение в rax
	jl   deleteerror

	mov  rdi, success_Delete
	call printString
	ret


deleteerror:
	mov  rdi, error_Delete
	call printString
	ret
;-----------------------------------------------------------

global appendFile
appendFile:
	mov  rax, NR_open
	mov  rsi, O_RDWR | O_APPEND
	syscall
	cmp  rax, 0	; когда ошибка - отрицательное значение в rax
	jl   appenderror

	mov  rdi, success_Append
	push rax
	call printString
	pop  rax
	ret

appenderror:
	mov  rdi, error_Append
	call printString
	ret
;-----------------------------------------------------------

global openFile
openFile:
	mov  rax, NR_open
	mov  rsi, O_RDWR
	syscall
	cmp  rax, 0	; когда ошибка - отрицательное значение в rax
	jl   openerror

	mov  rdi, success_Open
	push rax
	call printString
	pop  rax
	ret

openerror:
	mov  rdi, error_Open
	call printString
	ret
;-----------------------------------------------------------

global writeFile
writeFile:
	mov  rax, NR_write

	syscall
	cmp  rax, 0	; когда ошибка - отрицательное значение в rax
	jl   writeerror

	mov  rdi, success_Write
	call printString
	ret

writeerror:
	mov  rdi, error_Write
	call printString
	ret
;-----------------------------------------------------------

global positionFile
positionFile:
	mov  rax, NR_lseek
	syscall
	cmp  rax, 0	; когда ошибка - отрицательное значение в rax
	jl   positionerror

	mov  rdi, success_Position
	call printString
	ret

positionerror:
	mov  rdi, error_Position
	call printString
	ret
;-----------------------------------------------------------

global closeFile
closeFile:
	mov  rax, NR_close
	syscall
	cmp  rax, 0	; когда ошибка - отрицательное значение в rax
	jl   closeerror

	mov  rdi, success_Close
	call printString
	ret

closeerror:
	mov  rdi, error_Close
	call printString
	ret
;-----------------------------------------------------------

global createFile
createFile:

	mov  rax, NR_create
	mov  rsi, S_IRUSR | S_IWUSR
	syscall	; возвращает дескриптор файла в rax
	cmp  rax, 0	; когда ошибка - в rax отрицательное значение
	jl   closeerror

	mov  rdi, success_Create
	push rax
	call printString
	pop  rax
	ret

createerror:
	mov  rdi, error_Create
	call printString
	ret
;-----------------------------------------------------------

; ВЫВОД ИНФЫ О ФАЙЛОВЫХ ОПЕРАЦИЯХ
global printString

printString:
; Счётчик символов
	mov  r12, rdi	; адрес выводимой строки
	xor  rdx, rdx	; Длина строки вывода
strLoop:
	cmp  byte [r12], 0
	je   strDone

	inc  rdx
	inc  r12
	jmp  strLoop

strDone:
	cmp  rdx, 0
	je   prtDone

	mov  rsi, rdi	; адрес выводимой строки
	xor  rax, rax
	inc  rax	; 1 = запись
	mov  rdi, rax	; 1 = в поток стандартного вывода (stdout)
	syscall

prtDone:
	ret


