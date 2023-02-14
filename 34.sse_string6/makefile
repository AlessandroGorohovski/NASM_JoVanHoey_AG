# makefile for sse_string6.asm
sse_string6: sse_string6.o print16b.o
	gcc -o sse_string6  sse_string6.o print16b.o -no-pie

# Здесь ключи означают:
#  -no-pie -- не создавать перемещаемый в памяти код (т.е. структура,код программы простая)

sse_string6.o: sse_string6.asm
	nasm -f elf64 -g -F dwarf sse_string6.asm -l sse_string6.lst
print16b: print16b.c
	gcc -c print16b.c

# Здесь ключи означают:
#  -f -- формат вывода elf64
#  -g -- надо включить отладочную информацию в специальном формате отладки, определённом после ключа -F (dwarf)
#  -l -- генерирование файла листинга, для исследования рез-тов ассемблирования
