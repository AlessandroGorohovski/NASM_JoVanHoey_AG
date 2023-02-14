# makefile for transpose4x4.asm
transpose4x4: transpose4x4.o
	gcc -o transpose4x4  transpose4x4.o -no-pie

# Здесь ключи означают:
#  -no-pie -- не создавать перемещаемый в памяти код (т.е. структура,код программы простая)

transpose4x4.o: transpose4x4.asm
	nasm -f elf64 -g -F dwarf transpose4x4.asm -l transpose4x4.lst

# Здесь ключи означают:
#  -f -- формат вывода elf64
#  -g -- надо включить отладочную информацию в специальном формате отладки, определённом после ключа -F (dwarf)
#  -l -- генерирование файла листинга, для исследования рез-тов ассемблирования
