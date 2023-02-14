# makefile for fromc.c and *.asm
fromc: fromc.c rect.o circle.o sreverse.o adouble.o asum.o
	gcc -o fromc fromc.c rect.o circle.o sreverse.o \
	adouble.o asum.o -no-pie

# Здесь ключи означают:
#  -no-pie -- не создавать перемещаемый в памяти код (т.е. структура,код программы простая)

rect.o: rect.asm
	nasm -f elf64 -g -F dwarf rect.asm -l rect.lst
circle.o: circle.asm
	nasm -f elf64 -g -F dwarf circle.asm -l circle.lst
sreverse.o: sreverse.asm
	nasm -f elf64 -g -F dwarf sreverse.asm -l sreverse.lst
adouble.o: adouble.asm
	nasm -f elf64 -g -F dwarf adouble.asm -l adouble.lst
asum.o: asum.asm
	nasm -f elf64 -g -F dwarf asum.asm -l asum.lst

# Здесь ключи означают:
#  -f -- формат вывода elf64
#  -g -- надо включить отладочную информацию в специальном формате отладки, определённом после ключа -F (dwarf)
#  -l -- генерирование файла листинга, для исследования рез-тов ассемблирования
