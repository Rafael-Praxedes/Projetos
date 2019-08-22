#Autor: Rafael Maranhão Rêgo Praxedes
#Matrícula: 11503299
#Disciplina: Análise e Projeto de Algorítmos

#Makefile

all:sort

sort:insertion_sort.o selection_sort.o merge_sort.o quick_sort.o heap_sort.o main.o 
	gcc insertion_sort.o selection_sort.o merge_sort.o quick_sort.o heap_sort.o main.o -o sort_algorithm

insertion_sort.o: insertion_sort.c
	gcc -c insertion_sort.c

selection_sort.o: selection_sort.c
	gcc -c selection_sort.c

merge_sort.o: merge_sort.c
	gcc -c merge_sort.c

quick_sort.o: quick_sort.c
	gcc -c quick_sort.c

heap_sort.o: heap_sort.c
	gcc -c heap_sort.c

main.o: main.c
	gcc -c main.c

clean:
	rm -f *.o insertion_sort *~
	rm -f *.o selection_sort *~
	rm -f *.o merge_sort *~
	rm -f *.o quick_sort *~
	rm -f *.o heap_sort *~
	rm -f *.o main *~
