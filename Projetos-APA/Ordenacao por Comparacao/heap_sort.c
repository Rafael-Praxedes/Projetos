/**********************************************************/
/*                                                        */  
/* Autor: Rafael Maranhão Rêgo Praxedes                   */
/*                                                        */
/* Matrícula: 11503299                                    */
/*                                                        */
/* Data de criação: 31/08/2017                            */
/*                                                        */
/* Última modificação: 31/08/2017                         */  
/*                                                        */ 
/* e-mail: rafaelpraxedes10@hotmail.com                   */
/*                                                        */
/* Fonte de estudo (ordenação): Programação descomplicada */
/*                                                        */
/**********************************************************/

#include "heap_sort.h"

void BuildHeap(int *vector, int first, int last)
{
	int aux = vector[first];
	int child = 2*first + 1;

	while(child <= last){

		if(child < last){
			if(vector[child] < vector[child + 1])
				child++;
		}
		if(aux < vector[child]){
			vector[first] = vector[child];
			first = child;
			child = 2*first + 1;
		}
		else
			child = last + 1;
	}
	vector[first] = aux;
}

void HeapSort(int *vector, int size)
{
	int i, aux;

	for (i = (size - 1)/2; i >= 0; --i){
		BuildHeap(vector, i, size - 1);
	}

	for (i = size - 1; i >= 1; --i){
		aux = vector[0];
		vector[0] = vector[i];
		vector[i] = aux;

		BuildHeap(vector, 0, i-1);
	}
}