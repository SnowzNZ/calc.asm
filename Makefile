.PHONY:	all run clean

all:	calc

calc.o:	calc.asm
	nasm -f elf64 calc.asm -o calc.o

calc:	calc.o
	ld calc.o -o calc

run:	all
	./calc

clean:
	rm -f calc.o calc
