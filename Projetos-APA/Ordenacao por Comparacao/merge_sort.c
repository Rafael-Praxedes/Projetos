/**********************************************************/
/*                                                        */  
/* Autor: Rafael Maranhão Rêgo Praxedes                   */
/*                                                        */
/* Matrícula: 11503299                                    */
/*                                                        */
/* Data de criação: 30/08/2017                            */
/*                                                        */
/* Última modificação: 30/08/2017                         */  
/*                                                        */ 
/* e-mail: rafaelpraxedes10@hotmail.com                   */
/*                                                        */
/* Fonte de estudo (ordenação): Programação descomplicada */
/*                                                        */
/**********************************************************/

#include "merge_sort.h"

void Merge(int *vector, int first, int midle, int last)
{
	int *aux;
	int p1, p2, size, i, j, k, last1 = 0, last2 = 0;

	size = (last - first) + 1;

	p1 = first;
	p2 = midle + 1;

	aux = (int*) malloc(sizeof(int)*size);

	if (aux != NULL){
		for(i = 0; i < size; i++){

			if (!last1 && !last2){

				if(vector[p1] < vector[p2])
					aux[i] = vector[p1++];
				else
					aux[i] = vector[p2++];

				if(p1>midle) {last1 = 1;}
				if(p2>last) {last2 = 1;}
			}//if
			else{
				if(!last1) {aux[i] = vector[p1++];}
				else{aux[i] = vector[p2++];}
			} 
		}//for
		for (j = 0, k = first; j < size; j++, k++)
			vector[k] = aux[j]; 
	}//if
	free(aux);
}

void MergeSort(int *vector, int first, int last)
{
	int midle;

	if (first < last){
		midle = (first + last)/2;

		MergeSort(vector, first, midle);
		MergeSort(vector, midle + 1, last);
		Merge(vector, first, midle, last);
	}
}