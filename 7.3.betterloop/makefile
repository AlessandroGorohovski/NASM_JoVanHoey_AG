# makefile for betterloop.asm

betterloop: betterloop.o
	gcc -o betterloop  betterloop.o  -no-pie

# Здесь ключи означают:
#  -no-pie -- не создавать перемещаемый в памяти код (т.е. структура, код программы простая)

betterloop.o: betterloop.asm
	nasm -f elf64 -g -F dwarf betterloop.asm  -l betterloop.lst

# Здесь ключи означают:
#  -f -- формат вывода elf64
#  -g -- надо включить отладочную информацию в специальном формате отладки, определённом после ключа -F (dwarf)
#  -l -- генерирование файла листинга, для исследования рез-тов ассемблирования
