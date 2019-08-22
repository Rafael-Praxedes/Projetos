#Autor: Rafael Maranhão Rêgo Praxedes
#Matrícula: 11503299
#Disciplina: Análise e Projeto de Algoritmos

#Makefile

all:gulosos clean

gulosos:MinHeap.o MatrixInput.o Prim.o Dijkstra.o main.o 
	g++ MinHeap.o MatrixInput.o Prim.o Dijkstra.o main.o -o gulosos

MinHeap.o: MinHeap.cpp
	g++ -c MinHeap.cpp

MatrixInput.o: MatrixInput.cpp
	g++ -c MatrixInput.cpp

Prim.o: Prim.cpp
	g++ -c Prim.cpp

Dijkstra.o: Dijkstra.cpp
	g++ -c Dijkstra.cpp

main.o: main.cpp
	g++ -c main.cpp

.PHONY: clean
 
clean:
	rm -rf *.o MinHeap *~
	rm -rf *.o MatrixInput *~
	rm -rf *.o Prim *~
	rm -rf *.o Dijkstra *~
	rm -rf *.o main *~
	
