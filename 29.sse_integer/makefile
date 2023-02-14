# makefile for sse_integer.asm
sse_integer: sse_integer.o
	gcc -o sse_integer  sse_integer.o -no-pie

# Здесь ключи означают:
#  -no-pie -- не создавать перемещаемый в памяти код (т.е. структура,код программы простая)

sse_integer.o: sse_integer.asm
	nasm -f elf64 -g -F dwarf sse_integer.asm  -l sse_integer.lst

# Здесь ключи означают:
#  -f -- формат вывода elf64
#  -g -- надо включить отладочную информацию в специальном формате отладки, определённом после ключа -F (dwarf)
#  -l -- генерирование файла листинга, для исследования рез-тов ассемблирования
