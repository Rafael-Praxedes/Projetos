/**********************************************************/
/*                                                        */  
/* Autor: Rafael Maranhão Rêgo Praxedes                   */
/*                                                        */
/* Matrícula: 11503299                                    */
/*                                                        */
/* Data de criação: 14/09/2017                            */
/*                                                        */
/* Última modificação: 14/09/2017                         */  
/*                                                        */ 
/* e-mail: rafaelpraxedes10@hotmail.com                   */
/*                                                        */
/**********************************************************/

#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <stdlib.h>
#include <time.h>

#define NUMBER_FILE 1
#define TAM_DECIMAL 10
#define FATOR_DE_CONVERSAO 1000000.0

using namespace std;

void getVectorFromFile(vector<int> &v, char* name)
{
	ifstream file;

	string number_str;

	file.open(name);

	if(file.is_open()){

		while(!file.eof()){

			getline(file, number_str);

			v.push_back(atoi(number_str.c_str()));
		}
	}
	file.close();
}

int MaxElement(vector<int> &v)
{
	int max = v[0];

	for (int i = 0; i < v.size(); ++i){
		if(v[i] > max)
			max = v[i];
	}

	return max;
}

int NegElement(vector<int> &v)
{
	int min_neg = 0;

	for (int i = 0; i < v.size(); ++i){
		if(v[i] < min_neg)
			min_neg = v[i];
	}

	return min_neg;
}

void VectorPrint(vector<int> &v)
{
	for(int i = 0; i < v.size(); i++){
		cout << v[i] << " ";
	}
	cout << endl;
}

bool Shift(vector<int> &v, int shift)
{
	for (int i = 0; i < v.size(); ++i){
		v[i] += shift;
	}

	if(shift > 0)
		return true;
	else
		return false;
}

void RadixCountingSort(vector<int> &a, int exp)
{
	int length = a.size();

	int b[length];
	int c[TAM_DECIMAL];

	int shift_number;
	bool is_shift = false;
	int pivo_neg;

	pivo_neg = NegElement(a);

	if(pivo_neg < 0){
		is_shift = Shift(a, -pivo_neg);
	}

	for(int i = 0; i < TAM_DECIMAL; i++){
		c[i] = 0;
	}

	for(int i = 0; i < a.size(); i++){
		c[(a[i]/exp)%TAM_DECIMAL]++;
	}

	for(int i = 1; i < TAM_DECIMAL; i++){
		c[i] = c[i] + c[i-1]; 
	}

	for(int i = a.size() - 1; i >= 0; i--){
		 
		b[ c[(a[i]/exp)%TAM_DECIMAL] -1] = a[i];
		 
		c[(a[i]/exp)%TAM_DECIMAL]--;
	}

	for(int i = 0; i < a.size(); i++){
		a[i] = b[i];
	}

	if(is_shift == true){
		is_shift = Shift(a, pivo_neg);
	}
}

void RadixSort(vector<int> &a, int max_element)
{
	for (int exp = 1; max_element/exp > 0; exp *= 10){
		RadixCountingSort(a, exp);
	}
}

int main (int argc, char** argv)
{
	vector<int> my_vector;

	int max_element;

	getVectorFromFile(my_vector, argv[NUMBER_FILE]);
	
	max_element = MaxElement(my_vector);

	cout << "Max: " << max_element << endl;

	struct timespec start, finish;
	double time;

	cout << "Vetor desordenado: ";
	VectorPrint(my_vector);

    clock_gettime(CLOCK_MONOTONIC, &start); 
	RadixSort(my_vector, max_element);
	clock_gettime(CLOCK_MONOTONIC, &finish);

	cout << "Vetor ordenado: ";
	VectorPrint(my_vector);

    time = (finish.tv_nsec - start.tv_nsec)/FATOR_DE_CONVERSAO;
    cout << "Tempo de execução (RadixSort): " << time << " ms" << endl;

	cout << "Programming terminate!" << endl;

	return 0;
}
