/**********************************************************/
/*                                                        */  
/* Autor: Rafael Maranhão Rêgo Praxedes                   */
/*                                                        */
/* Matrícula: 11503299                                    */
/*                                                        */
/* Data de criação: 13/09/2017                            */
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

void CountingSort(vector<int> &a, vector<int> &b, int max_element)
{
	int range = max_element + 1;
	
	int index;

	int shift_number;
	bool is_shift = false;
	int pivo_neg;

	pivo_neg = NegElement(a);

	if(pivo_neg < 0){
		is_shift = Shift(a, -pivo_neg);
		range += (-pivo_neg);
	}

	int c[range];

	for(int i = 0; i < range; i++){
		c[i] = 0;
	}

	for(int i = 0; i < a.size(); i++){
		c[a[i]]++;
	}

	for(int i = 1; i < range; i++){
		c[i] = c[i] + c[i-1]; 
	}

	for(int i = 0; i < a.size(); i++){
		
		index = c[a[i]] - 1;
	 
		b[index] = a[i];
		 
		c[a[i]]--;
	}

	if(is_shift == true){
		is_shift = Shift(b, pivo_neg);
	}
}

int main (int argc, char** argv)
{
	vector<int> messy_vector;

	int max_element;

	getVectorFromFile(messy_vector, argv[NUMBER_FILE]);

	vector<int> ordered_vector(messy_vector.size());

	max_element = MaxElement(messy_vector);

	struct timespec start, finish;
	double time;

	cout << "Vetor desordenado: ";
	VectorPrint(messy_vector);

    clock_gettime(CLOCK_MONOTONIC, &start); 
	CountingSort(messy_vector, ordered_vector, max_element);
	clock_gettime(CLOCK_MONOTONIC, &finish);

	cout << "Vetor ordenado: ";
	VectorPrint(ordered_vector);

    time = (finish.tv_nsec - start.tv_nsec)/FATOR_DE_CONVERSAO;
    cout << "Tempo de execução (CountingSort): " << time << " ms" << endl;

	cout << "Programming terminate!" << endl;

	return 0;
}