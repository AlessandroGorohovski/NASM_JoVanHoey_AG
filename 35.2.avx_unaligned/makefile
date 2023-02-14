# makefile for avx_unaligned.asm
avx_unaligned: avx_unaligned.o
	gcc -o avx_unaligned  avx_unaligned.o -no-pie

# Здесь ключи означают:
#  -no-pie -- не создавать перемещаемый в памяти код (т.е. структура,код программы простая)

avx_unaligned.o: avx_unaligned.asm
	nasm -f elf64 -g -F dwarf avx_unaligned.asm -l avx_unaligned.lst

# Здесь ключи означают:
#  -f -- формат вывода elf64
#  -g -- надо включить отладочную информацию в специальном формате отладки, определённом после ключа -F (dwarf)
#  -l -- генерирование файла листинга, для исследования рез-тов ассемблирования
