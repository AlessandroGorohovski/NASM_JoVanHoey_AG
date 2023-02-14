# makefile for bits1.asm and printb.c
bits1: bits1.o printb.o
	gcc -o bits1  bits1.o printb.o -no-pie

# Здесь ключи означают:
#  -no-pie -- не создавать перемещаемый в памяти код (т.е. структура,код программы простая)

bits1.o: bits1.asm
	nasm -f elf64 -g -F dwarf bits1.asm -l bits1.lst
printb.o: printb.c
	gcc -c printb.c

# Здесь ключи означают:
#  -f -- формат вывода elf64
#  -g -- надо включить отладочную информацию в специальном формате отладки, определённом после ключа -F (dwarf)
#  -l -- генерирование файла листинга, для исследования рез-тов ассемблирования
