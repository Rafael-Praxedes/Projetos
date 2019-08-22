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

#include "quick_sort.h"

int Partion(int *vector, int first, int last)
{
	int right, left, pivo, aux;

	left = first;
	right = last;

	pivo = vector[first];

	while(left < right){
		while(vector[left] <= pivo)
			left++;
		while(vector[right] > pivo)
			right--;

		if(left < right){
			aux = vector[left];
			vector[left] = vector[right];
			vector[right] = aux;
		}
	}
	vector[first] = vector[right];
	vector[right] = pivo;

	return right; 
}

void QuickSort(int *vector, int first, int last)
{
	int pivo;

	if (last > first){
		pivo = Partion(vector, first, last);

		QuickSort(vector, first, pivo-1);
		QuickSort(vector, pivo+1, last);
	}
}