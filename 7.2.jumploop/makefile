# makefile for jumploop.asm

jumploop: jumploop.o
	gcc -o jumploop  jumploop.o  -no-pie

# Здесь ключи означают:
#  -no-pie -- не создавать перемещаемый в памяти код (т.е. структура, код программы простая)

jumploop.o: jumploop.asm
	nasm -f elf64 -g -F dwarf jumploop.asm -l jumploop.lst

# Здесь ключи означают:
#  -f -- формат вывода elf64
#  -g -- надо включить отладочную информацию в специальном формате отладки, определённом после ключа -F (dwarf)
#  -l -- генерирование файла листинга, для исследования рез-тов ассемблирования

