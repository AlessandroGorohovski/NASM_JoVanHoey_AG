# makefile for sse_aligned.asm
sse_aligned: sse_aligned.o
	gcc -o sse_aligned  sse_aligned.o -no-pie

# Здесь ключи означают:
#  -no-pie -- не создавать перемещаемый в памяти код (т.е. структура,код программы простая)

sse_aligned.o: sse_aligned.asm
	nasm -f elf64 -g -F dwarf sse_aligned.asm  -l sse_aligned.lst

# Здесь ключи означают:
#  -f -- формат вывода elf64
#  -g -- надо включить отладочную информацию в специальном формате отладки, определённом после ключа -F (dwarf)
#  -l -- генерирование файла листинга, для исследования рез-тов ассемблирования
