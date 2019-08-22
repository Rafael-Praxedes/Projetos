#Autor: Rafael Maranhão Rêgo Praxedes
#Matrícula: 11503299
#Disciplina: Sistemas Operacionais I

#Makefile

all:escalonador clean

escalonador:Escalonador.o Processo.o Comparador.o main.o 
	g++ Escalonador.o Processo.o Comparador.o main.o -o projeto1

Escalonador.o: Escalonador.cpp
	g++ -c Escalonador.cpp

Processo.o: Processo.cpp
	g++ -c Processo.cpp

Comparador.o: Comparador.cpp
	g++ -c Comparador.cpp

main.o: main.cpp
	g++ -c main.cpp

.PHONY: clean
 
clean:
	rm -rf *.o Escalonador *~
	rm -rf *.o Processo *~
	rm -rf *.o Comparador *~
	rm -rf *.o main *~
	
