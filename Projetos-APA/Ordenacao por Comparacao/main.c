/**********************************************************/
/*                                                        */  
/* Autor: Rafael Maranhão Rêgo Praxedes                   */
/*                                                        */
/* Matrícula: 11503299                                    */
/*                                                        */
/* Data de criação: 16/08/2017                            */
/*                                                        */
/* Última modificação: 31/08/2017                         */  
/*                                                        */ 
/* e-mail: rafaelpraxedes10@hotmail.com                   */
/*                                                        */
/**********************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "insertion_sort.h"
#include "selection_sort.h"
#include "merge_sort.h"
#include "quick_sort.h"
#include "heap_sort.h"

#define NUMBER_FILE 1
#define RANGE 400
#define FATOR_DE_CONVERSAO 1000000.0

int CountLine(char *nameTxt){
	char caracter;
	char number[20];
	int numLine = 0;

	FILE *arq;
	
	arq = fopen(nameTxt, "r");

	if(arq == NULL)
		printf("Error open file!\n");

	while(!feof(arq)){
		caracter = fgetc(arq);
		if(caracter == '\n' || feof(arq))
			numLine++;
	}

	fclose(arq);
	
	return numLine;
}

void FillArray(int *A, char *nameTxt){

	FILE *arq;
	char number[20];
	int i = 0;

	arq = fopen(nameTxt, "r");

	if(arq == NULL)
		printf("Error open file!\n");
	
	while(!feof(arq)){
		fgets(number, 20, arq);
		A[i] = atoi(number);
		i++;
	}

	fclose(arq);
}


int main(int argc, char** argv)
{
   char *fileName = argv[NUMBER_FILE];
   int length = CountLine(fileName);	
   
   int *vector = malloc(length*sizeof(int));

   FillArray(vector, fileName);

   int i;

   struct timespec start_1, finish_1, start_2, finish_2, start_3, finish_3, start_4, finish_4, start_5, finish_5;
   double time;

   //srand(time(NULL)); //Alimentando o gerador de números aleatórios

   //----------------------------------------------------//
   //------------------ Insertion Sort ------------------//
   //----------------------------------------------------//

   printf("\n\t>>>>> Insertion Sort <<<<<\n"); 

   printf("\nVetor original: ");
	
   /*for(i = 0; i < SIZE_VECTOR; i++){	
    	vector[i] = rand()%RANGE + 1;  //Preenchendo o vetor com números inteiros pertencentes ao intervalo de 1 a 400
       	printf("%d ", vector[i]);    //Exibindo o vetor original
   }
   printf("\n");*/
   for (i = 0; i < length; ++i){
   	   printf("%d ", vector[i]);
   }
   printf("\n");

   printf("Vetor ordenado: ");

   clock_gettime(CLOCK_MONOTONIC, &start_1);
   InsertionSort(vector, length);
   clock_gettime(CLOCK_MONOTONIC, &finish_1);

   for(i = 0; i < length; i++){	
    	printf("%d ", vector[i]);      //Exibindo o vetor ordenado
   }
   printf("\n");

   time = (finish_1.tv_nsec - start_1.tv_nsec)/FATOR_DE_CONVERSAO;
   printf("Tempo de execução (InsertionSort): %f ms\n", time);
   //----------------------------------------------------//

   //----------------------------------------------------//
   //------------------ Selection Sort ------------------//
   //----------------------------------------------------//

   printf("\n\t>>>>> Selection Sort <<<<<\n"); 

   printf("\nVetor original: ");
	
   /*for(i = 0; i < SIZE_VECTOR; i++){	
    	vector[i] = rand()%RANGE + 1;  //Preenchendo o vetor com números inteiros pertencentes ao intervalo de 1 a 400
       	printf("%d ", vector[i]);    //Exibindo o vetor original
   }
   printf("\n");*/

   for (i = 0; i < length; ++i){
   	   printf("%d ", vector[i]);
   }
   printf("\n");

   printf("Vetor ordenado: ");

   clock_gettime(CLOCK_MONOTONIC, &start_2);
   SelectionSort(vector, length);
   clock_gettime(CLOCK_MONOTONIC, &finish_2);

   for(i = 0; i < length; i++){	
    	printf("%d ", vector[i]);      //Exibindo o vetor ordenado
   }
   printf("\n");

   time = (finish_2.tv_nsec - start_2.tv_nsec)/FATOR_DE_CONVERSAO;
   printf("Tempo de execução (SelectionSort): %f ms\n", time);
   //----------------------------------------------------//

   //----------------------------------------------------//
   //-------------------- Merge Sort --------------------//
   //----------------------------------------------------//

   printf("\n\t>>>>> Merge Sort <<<<<\n"); 

   printf("\nVetor original: ");
  
   /*for(i = 0; i < SIZE_VECTOR; i++){  
      vector[i] = rand()%RANGE + 1;  //Preenchendo o vetor com números inteiros pertencentes ao intervalo de 1 a 400
        printf("%d ", vector[i]);    //Exibindo o vetor original
   }
   printf("\n");*/

   for (i = 0; i < length; ++i){
   	   printf("%d ", vector[i]);
   }
   printf("\n");

   printf("Vetor ordenado: ");

   clock_gettime(CLOCK_MONOTONIC, &start_3);
   MergeSort(vector, 0, length-1);
   clock_gettime(CLOCK_MONOTONIC, &finish_3);

   for(i = 0; i < length; i++){  
      printf("%d ", vector[i]);      //Exibindo o vetor ordenado
   }
   printf("\n");

   time = (finish_3.tv_nsec - start_3.tv_nsec)/FATOR_DE_CONVERSAO;
   printf("Tempo de execução (MergeSort): %f ms\n", time);
   //----------------------------------------------------//

   //----------------------------------------------------//
   //-------------------- Quick Sort --------------------//
   //----------------------------------------------------//

   printf("\n\t>>>>> Quick Sort <<<<<\n"); 

   printf("\nVetor original: ");
  
   /*for(i = 0; i < SIZE_VECTOR; i++){  
      vector[i] = rand()%RANGE + 1;  //Preenchendo o vetor com números inteiros pertencentes ao intervalo de 1 a 400
        printf("%d ", vector[i]);    //Exibindo o vetor original
   }
   printf("\n");*/

   for (i = 0; i < length; ++i){
   	   printf("%d ", vector[i]);
   }
   printf("\n");

   printf("Vetor ordenado: ");

   clock_gettime(CLOCK_MONOTONIC, &start_4);
   QuickSort(vector, 0, length-1);
   clock_gettime(CLOCK_MONOTONIC, &finish_4);

   for(i = 0; i < length; i++){  
      printf("%d ", vector[i]);      //Exibindo o vetor ordenado
   }
   printf("\n");

   time = (finish_4.tv_nsec - start_4.tv_nsec)/FATOR_DE_CONVERSAO;
   printf("Tempo de execução (QuickSort): %f ms\n", time);
   //----------------------------------------------------//

   //----------------------------------------------------//
   //--------------------- Heap Sort --------------------//
   //----------------------------------------------------//

   printf("\n\t>>>>> Heap Sort <<<<<\n"); 

   printf("\nVetor original: ");
  
   /*for(i = 0; i < SIZE_VECTOR; i++){  
      vector[i] = rand()%RANGE + 1;  //Preenchendo o vetor com números inteiros pertencentes ao intervalo de 1 a 400
        printf("%d ", vector[i]);    //Exibindo o vetor original
   }
   printf("\n");*/

   for (i = 0; i < length; ++i){
   	   printf("%d ", vector[i]);
   }
   printf("\n");

   printf("Vetor ordenado: ");
  
   clock_gettime(CLOCK_MONOTONIC, &start_5); 
   HeapSort(vector, length);
   clock_gettime(CLOCK_MONOTONIC, &finish_5);

   for(i = 0; i < length; i++){  
      printf("%d ", vector[i]);      //Exibindo o vetor ordenado
   }
   printf("\n");

   time = (finish_5.tv_nsec - start_5.tv_nsec)/FATOR_DE_CONVERSAO;
   printf("Tempo de execução (HeapSort): %f ms\n", time);
   //----------------------------------------------------//
   
   printf("\nPrograma encerrado!\n");
    
   free(vector);
   vector = NULL;

   return 0;
}
