# makefile for sse_unaligned.asm
sse_unaligned: sse_unaligned.o
	gcc -o sse_unaligned  sse_unaligned.o -no-pie

# Здесь ключи означают:
#  -no-pie -- не создавать перемещаемый в памяти код (т.е. структура,код программы простая)

sse_unaligned.o: sse_unaligned.asm
	nasm -f elf64 -g -F dwarf sse_unaligned.asm  -l sse_unaligned.lst

# Здесь ключи означают:
#  -f -- формат вывода elf64
#  -g -- надо включить отладочную информацию в специальном формате отладки, определённом после ключа -F (dwarf)
#  -l -- генерирование файла листинга, для исследования рез-тов ассемблирования
