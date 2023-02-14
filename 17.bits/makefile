# makefile for bits3.asm and printb.c
bits3: bits3.o printb.o
	gcc -o bits3  bits3.o printb.o -no-pie

# Здесь ключи означают:
#  -no-pie -- не создавать перемещаемый в памяти код (т.е. структура,код программы простая)

bits3.o: bits3.asm
	nasm -f elf64 -g -F dwarf bits3.asm -l bits3.lst
printb.o: printb.c
	gcc -c printb.c

# Здесь ключи означают:
#  -f -- формат вывода elf64
#  -g -- надо включить отладочную информацию в специальном формате отладки, определённом после ключа -F (dwarf)
#  -l -- генерирование файла листинга, для исследования рез-тов ассемблирования
