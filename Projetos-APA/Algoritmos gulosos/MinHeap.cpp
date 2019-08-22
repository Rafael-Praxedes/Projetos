/**********************************************************/
/*                                                        */  
/* Autor: Rafael Maranhão Rêgo Praxedes                   */
/*                                                        */
/* Matrícula: 11503299                                    */
/*                                                        */
/* Data de criação: 28/09/2017                            */
/*                                                        */
/* Última modificação: 28/09/2017                         */  
/*                                                        */ 
/* e-mail: rafaelpraxedes10@hotmail.com                   */
/*                                                        */
/**********************************************************/

#include "MinHeap.h"

int Dad(int index)
{	
	if(index == 0)
		return index;

	if(index && !index%2)
		return (index/2 - 1);
	else
		return index/2;
}

int LeftChild(int index)
{
	return (2*index + 1);
}

int RightChild(int index)
{
	return (2*index + 2);
}

void MinHeapify(vector<tVertex> &vector, int index)
{
	int leftIndex = LeftChild(index);
	int rightIndex = RightChild(index);

	int smallast;

	tVertex aux; 

	if(leftIndex < vector.size() && vector[leftIndex].key < vector[index].key)
		smallast = leftIndex;
	else
		smallast = index;

	if(rightIndex < vector.size() && vector[rightIndex].key < vector[smallast].key)
		smallast = rightIndex;

	if(smallast != index){
		
		aux = vector[index];
		vector[index] = vector[smallast];
		vector[smallast] = aux;
           
        MinHeapify(vector, smallast);
	}
}

void BuildMinHeap(vector<tVertex> &vector)
{
	for (int i = ((vector.size())/2 - 1); i >= 0; --i){
		MinHeapify(vector, i);
	}
}

tVertex HeapMinimum(vector<tVertex> &vector)
{
	return vector[FIRST_ELEMENT_INDEX];
}

tVertex HeapExtractMinimum(vector<tVertex> &vector)
{
	tVertex min;

	if(vector.size() < 1){
		
		cout << "Heap Underflow!" << endl;
        min.idVertex = -1;
	}
	else{

		min = vector[FIRST_ELEMENT_INDEX];
	
		vector[FIRST_ELEMENT_INDEX] = vector[vector.size() - 1];

		vector.pop_back();
	
		MinHeapify(vector, FIRST_ELEMENT_INDEX);
	}

	return min;
}

void HeapDecreaseKey(vector<int> &vector, int index, int key)
{	
	if(key > vector[index])
		return;

	int aux;

	vector[index] = key;

	while(index > FIRST_ELEMENT_INDEX && vector[Dad(index)] > vector[index]){

		aux = vector[Dad(index)];
		vector[Dad(index)] = vector[index];
		vector[index] = aux; 

		index = Dad(index);
	}
}

void MinHeapInsert(vector<int> &vector, int key)
{
	vector.push_back(INT_MAX);
    HeapDecreaseKey(vector, vector.size() - 1, key);
}
