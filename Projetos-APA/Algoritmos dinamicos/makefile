#Autor: Rafael Maranhão Rêgo Praxedes
#Matrícula: 11503299
#Disciplina: Análise e Projeto de Algoritmos 

#Makefile

all:mochila clean

mochila:Mochila.o Produto.o main.o 
	g++ Mochila.o Produto.o main.o -o mochila

Mochila.o: Mochila.cpp
	g++ -c Mochila.cpp

Produto.o: Produto.cpp
	g++ -c Produto.cpp

main.o: main.cpp
	g++ -c main.cpp

.PHONY: clean
 
clean:
	rm -rf *.o Mochila *~
	rm -rf *.o Produto *~
	rm -rf *.o main *~
	
