/**********************************************************/
/*                                                        */  
/* Autor: Rafael Maranhão Rêgo Praxedes                   */
/*                                                        */
/* Matrícula: 11503299                                    */
/*                                                        */
/* Data de criação: 30/09/2017                            */
/*                                                        */
/* Última modificação: 01/10/2017                         */  
/*                                                        */ 
/* e-mail: rafaelpraxedes10@hotmail.com                   */
/*                                                        */
/**********************************************************/

#include "Dijkstra.h"

void Dijkstra(vector<vector<int> > originalMatrix, vector<tVertex> &vectorVertex, int origin, int destiny)
{
	vector<tVertex> vectorVertexAux; 

	vectorVertex.resize(originalMatrix.size());

	tVertex vertexMin;

	int root;

	root = origin;

	for (int i = 0; i < vectorVertex.size(); ++i){
		if(i != root){
			vectorVertex[i].idVertex = i;
			vectorVertex[i].key = INT_MAX;
			vectorVertex[i].belong = false;
			vectorVertex[i].path = -1; 
		}
	}
	vectorVertex[root].idVertex = root;
	vectorVertex[root].key = 0;
	vectorVertex[root].path = -1;
	vectorVertex[root].belong = false; 

	while(vectorVertex[destiny].belong == false){

		vectorVertex[root].belong = true;

		for (int i = 0; i < originalMatrix[root].size(); ++i){
		
			if(originalMatrix[root][i] && vectorVertex[i].belong == false){

				if(vectorVertex[i].key > (originalMatrix[root][i] + vectorVertex[root].key)){
				
					vectorVertex[i].key = originalMatrix[root][i] + vectorVertex[root].key;
					vectorVertex[i].path = root;
				}
			}//if 
		}//for

		for(int i = 0; i < vectorVertex.size(); i++){
			
			if(vectorVertex[i].belong == false)
				vectorVertexAux.push_back(vectorVertex[i]);
		}

		BuildMinHeap(vectorVertexAux);
		
		vertexMin = HeapMinimum(vectorVertexAux);

		root = vertexMin.idVertex;

		for (int i = vectorVertexAux.size(); i > 0; --i){
		 	vectorVertexAux.pop_back();
		}
	}//while
}