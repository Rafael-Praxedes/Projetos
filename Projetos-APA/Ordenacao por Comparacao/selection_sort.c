/**********************************************************/
/*                                                        */  
/* Autor: Rafael Maranhão Rêgo Praxedes                   */
/*                                                        */
/* Matrícula: 11503299                                    */
/*                                                        */
/* Data de criação: 16/08/2017                            */
/*                                                        */
/* Última modificação: 16/08/2017                         */  
/*                                                        */ 
/* e-mail: rafaelpraxedes10@hotmail.com                   */
/*                                                        */
/* Fonte de estudo (ordenação): Programação descomplicada */
/*                                                        */
/**********************************************************/

#include "selection_sort.h"

void SelectionSort(int *v, int length)
{
	int i, j, small, swap;

	for (i = 0; i < length-1; i++){
		small = i;

		for(j = i+1; j < length; j++){
			if (v[j] < v[small])
				small = j;
		}

		if(i != small){
			swap = v[i];
			v[i] = v[small];
			v[small] = swap;
		}
	}
}