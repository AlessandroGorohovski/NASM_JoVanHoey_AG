# makefile for sse_string3_exp.asm
sse_string3_exp: sse_string3_exp.o
	gcc -o sse_string3_exp  sse_string3_exp.o -no-pie
sse_string3_exp.o: sse_string3_exp.asm
	nasm -f elf64 -g -F dwarf sse_string3_exp.asm -l sse_string3_exp.lst
