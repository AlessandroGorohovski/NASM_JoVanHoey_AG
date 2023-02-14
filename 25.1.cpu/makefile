# makefile for cpu.asm
cpu: cpu.o
	gcc -o cpu cpu.o -no-pie
cpu.o: cpu.asm
	nasm -f elf64 -g -F dwarf cpu.asm -l cpu.lst

