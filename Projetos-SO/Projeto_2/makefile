#Autor: Rafael Maranhão Rêgo Praxedes
#Matrícula: 11503299
#Disciplina: Sistemas Operacionais I

#Makefile

all:paginador clean

paginador:FIFO.o OTM.o LRU.o main.o 
	g++ FIFO.o OTM.o LRU.o main.o -o projeto2

FIFO.o: FIFO.cpp
	g++ -c FIFO.cpp

OTM.o: OTM.cpp
	g++ -c OTM.cpp

LRU.o: LRU.cpp
	g++ -c LRU.cpp

main.o: main.cpp
	g++ -c main.cpp

.PHONY: clean
 
clean:
	rm -rf *.o FIFO *~
	rm -rf *.o OTM *~
	rm -rf *.o LRU *~
	rm -rf *.o main *~
	
