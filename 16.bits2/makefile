# makefile for bits2.asm
bits2: bits2.o
	gcc -o bits2  bits2.o  -no-pie

# Здесь ключи означают:
#  -no-pie -- не создавать перемещаемый в памяти код (т.е. структура,код программы простая)

bits2.o: bits2.asm
	nasm -f elf64 -g -F dwarf bits2.asm -l bits2.lst

# Здесь ключи означают:
#  -f -- формат вывода elf64
#  -g -- надо включить отладочную информацию в специальном формате отладки, определённом после ключа -F (dwarf)
#  -l -- генерирование файла листинга, для исследования рез-тов ассемблирования
