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

#include "insertion_sort.h"

void InsertionSort(int *v, int length)
{
	int aux, i, j;

	for (i = 1; i < length; i++){
		aux = v[i];

		for(j = i; (j > 0) && (aux < v[j-1]); j--)
			v[j] = v[j-1];

		v[j] = aux;
	}
}