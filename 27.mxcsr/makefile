# makefile for mxcsr.asm
mxcsr: mxcsr.o print_mxcsr.o print_hex.o
	gcc -o mxcsr  mxcsr.o print_mxcsr.o print_hex.o -no-pie
mxcsr.o: mxcsr.asm
	nasm -f elf64 -g -F dwarf mxcsr.asm  -l mxcsr.lst
print_mxcsr: print_mxcsr.c
	gcc -c print_mxcsr.c
print_hex: print_hex.c
	gcc -c print_hex.c

# Здесь ключи означают:
#  -no-pie -- не создавать перемещаемый в памяти код (т.е. структура,код программы простая)

#  -f -- формат вывода elf64
#  -g -- надо включить отладочную информацию в специальном формате отладки, определённом после ключа -F (dwarf)
#  -l -- генерирование файла листинга, для исследования рез-тов ассемблирования
