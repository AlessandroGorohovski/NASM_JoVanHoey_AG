# makefile for sse_string2_jmp.asm
sse_string2_jmp: sse_string2_jmp.o
	gcc -o sse_string2_jmp  sse_string2_jmp.o -no-pie
sse_string2_jmp.o: sse_string2_jmp.asm
	nasm -f elf64 -g -F dwarf sse_string2_jmp.asm -l sse_string2_jmp.lst
