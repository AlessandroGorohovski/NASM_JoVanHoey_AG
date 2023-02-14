# makefile for move_strings.asm
move_strings: move_strings.o
	gcc -o move_strings  move_strings.o -no-pie

# Здесь ключи означают:
#  -no-pie -- не создавать перемещаемый в памяти код (т.е. структура,код программы простая)

move_strings.o: move_strings.asm
	nasm -f elf64 -g -F dwarf move_strings.asm -l move_strings.lst

# Здесь ключи означают:
#  -f -- формат вывода elf64
#  -g -- надо включить отладочную информацию в специальном формате отладки, определённом после ключа -F (dwarf)
#  -l -- генерирование файла листинга, для исследования рез-тов ассемблирования
