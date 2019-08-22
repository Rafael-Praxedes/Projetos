/**********************************************************/
/*                                                        */  
/* Autor: Rafael Maranhão Rêgo Praxedes                   */
/*                                                        */
/* Matrícula: 11503299                                    */
/*                                                        */
/* Data de criação: 27/09/2017                            */
/*                                                        */
/* Última modificação: 03/10/2017                         */  
/*                                                        */ 
/* e-mail: rafaelpraxedes10@hotmail.com                   */
/*                                                        */
/**********************************************************/

#include <iostream>
#include <fstream>
#include "MinHeap.h"
#include "MatrixInput.h"
#include "Prim.h"
#include "Dijkstra.h"
#include "Vertex.h"
#include <string.h>

#define ORIGIN 0

using namespace std;

void PrintVector(vector<int>& v)
{
	for (int i = 0; i < v.size(); ++i){
		cout << v[i] << " ";
	}
	cout << endl;
}

void PrintMatrix(vector<vector<int> >& matrix)
{
	for (int i = 0; i < matrix.size(); ++i){
		for (int j = 0; j < matrix[i].size(); ++j){
			cout << matrix[i][j] << " ";
		}
		cout << endl;
	}
}

void PrintMST(vector<tVertex>& vectorVertex)
{
	int soma = 0;
	
	for (int i = 0; i < vectorVertex.size(); ++i){
		cout << "Vertex[" << vectorVertex[i].idVertex << "]:" << endl;
		cout << "\t>>> Path: " << vectorVertex[i].path << endl;
		cout << "\t>>> Value edge: " << vectorVertex[i].key << endl;

		soma = soma + vectorVertex[i].key; 
	}

    cout << "\n-----------------" << endl;
	cout << "Value MST: " << soma << endl;
	cout << "-----------------" << endl;
}

void PrintSmallestPath(vector<tVertex>& vectorVertex, int origin, int destiny)
{
	int nodesPath = destiny;

	vector<tVertex> smallestPath;
	
	while(vectorVertex[nodesPath].path != -1){

		smallestPath.push_back(vectorVertex[nodesPath]);

		nodesPath = vectorVertex[nodesPath].path; 
	}

	smallestPath.push_back(vectorVertex[origin]);

	for (int i = smallestPath.size() - 1; i >= 0; --i){

		cout << "Vertex[" << smallestPath[i].idVertex << "]:" << endl;
		cout << "\t>>> Path: " << smallestPath[i].path << endl;
		cout << "\t>>> Value edge: " << smallestPath[i].key << endl;
	}

	cout << "\n---------------------" << endl;
	cout << "Value Dijkstra: " << smallestPath[0].key << endl;
	cout << "---------------------" << endl;
}

void FileMST(fstream &file, const char* fileName, vector<tVertex>& vectorVertex)
{
	int soma = 0;

	file << "\n>>> Prim <<<\n" << endl;
	
	for (int i = 0; i < vectorVertex.size(); ++i){
		file << "Vertex[" << vectorVertex[i].idVertex << "]:" << endl;
		file << "\t>>> Path: " << vectorVertex[i].path << endl;
		file << "\t>>> Value edge: " << vectorVertex[i].key << endl;

		soma = soma + vectorVertex[i].key; 
	}

    file << "\n-----------------" << endl;
	file << "Value MST: " << soma << endl;
	file << "-----------------" << endl;
}

void FileSmallestPath(fstream &file, const char* fileName, vector<tVertex>& vectorVertex, int origin, int destiny)
{
	int nodesPath = destiny;

	vector<tVertex> smallestPath;

	if(file.is_open()){

		while(vectorVertex[nodesPath].path != -1){

			smallestPath.push_back(vectorVertex[nodesPath]);

			nodesPath = vectorVertex[nodesPath].path; 
		}

		smallestPath.push_back(vectorVertex[origin]);

		file << "\n>>> Dijkstra <<<\n" << endl;

		for (int i = smallestPath.size() - 1; i >= 0; --i){

			file << "Vertex[" << smallestPath[i].idVertex << "]:" << endl;
			file << "\t>>> Path: " << smallestPath[i].path << endl;
			file << "\t>>> Value edge: " << smallestPath[i].key << endl;
		}

		file << "\n---------------------" << endl;
		file << "Value Dijkstra: " << smallestPath[0].key << endl;
		file << "---------------------" << endl;
	}
	else{
		cout << "Error on file smallest path!" << endl;
	}
}

void OutputFile(fstream &file, const char* fileName, const char* fileInName, vector<tVertex>& vectorVertexPrim, vector<tVertex>& vectorVertexDijkstra, int origin, int destiny)
{
	file.open(fileName, fstream::out | fstream::app);

	if(file.is_open()){

        file << "Autor: Rafael Maranhão Rêgo Praxedes" << endl;
		file << "Matrícula: 11503299" << endl;
		file << "Disciplina: Análise e Projeto de Algoritmos" << endl;

		file << "\n\t\t >>>>> Algoritmos Gulosos <<<<<" << endl;

		file << "\nInput file name: " << fileInName << endl;

		FileMST(file, fileName, vectorVertexPrim);

		FileSmallestPath(file, fileName, vectorVertexDijkstra, origin, destiny);

		file.close();
	}
	else{
		cout << "Error on open file!" << endl;
	}
}

const char* OutputFileName(const char* string)
{
    if(!strcmp(string, "dij10.txt"))
    	return "dij10_output.txt";

    else if(!strcmp(string, "dij20.txt"))
    	return "dij20_output.txt";

    else if(!strcmp(string, "dij40.txt"))
    	return "dij40_output.txt";

    else if(!strcmp(string, "dij50.txt"))
    	return "dij50_output.txt";

    else
    	return "outputFile.txt";
}

int main(int argc, char **argv)
{
	vector<vector<int> >matrix;
	vector<tVertex> vectorVertexPrim;
	vector<tVertex> vectorVertexDijkstra;

	fstream outputFile;

	cout << "\n>>> Matrix Input <<<\n" << endl;

	BuildMatrixInput(matrix, argv[1]);

	PrintMatrix(matrix);

	cout << "\n>>> Prim <<<\n" << endl;

	Prim(matrix, vectorVertexPrim, 0);

	PrintMST(vectorVertexPrim);

	cout << "\n>>> Dijkstra <<<\n" << endl;

	Dijkstra(matrix, vectorVertexDijkstra, 2, matrix.size() - 1); 

	PrintSmallestPath(vectorVertexDijkstra, 2, matrix.size() - 1);

	OutputFile(outputFile, OutputFileName(argv[1]), argv[1], vectorVertexPrim, vectorVertexDijkstra, ORIGIN, matrix.size() - 1);

	cout << "\nPrograma encerrado!" << endl;

	return 0;
}