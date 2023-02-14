# makefile for function5.asm
function5: function5.o
	gcc -o function5  function5.o  -no-pie

# Здесь ключи означают:
#  -no-pie -- не создавать перемещаемый в памяти код (т.е. структура,код программы простая)

function5.o: function5.asm
	nasm -f elf64 -g -F dwarf function5.asm -l function5.lst

# Здесь ключи означают:
#  -f -- формат вывода elf64
#  -g -- надо включить отладочную информацию в специальном формате отладки, определённом после ключа -F (dwarf)
#  -l -- генерирование файла листинга, для исследования рез-тов ассемблирования
