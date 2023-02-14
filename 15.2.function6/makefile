# makefile for function6.asm
function6: function6.o
	gcc -o function6  function6.o  -no-pie

# Здесь ключи означают:
#  -no-pie -- не создавать перемещаемый в памяти код (т.е. структура,код программы простая)

function6.o: function6.asm
	nasm -f elf64 -g -F dwarf function6.asm -l function6.lst

# Здесь ключи означают:
#  -f -- формат вывода elf64
#  -g -- надо включить отладочную информацию в специальном формате отладки, определённом после ключа -F (dwarf)
#  -l -- генерирование файла листинга, для исследования рез-тов ассемблирования
