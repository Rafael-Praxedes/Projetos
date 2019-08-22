/***********************************************/
/*                                             */  
/* Autor: Rafael Maranhão Rêgo Praxedes        */
/*                                             */
/* Matrícula: 11503299                         */
/*                                             */
/* Data de criação: 27/10/2017                 */
/*                                             */
/* Última modificação: 27/10/2017              */  
/*                                             */ 
/* e-mail: rafaelpraxedes10@hotmail.com        */
/*                                             */
/***********************************************/

#include <iostream>
#include <fstream>
#include <string>
#include <stdlib.h>
#include <vector> 

#include "FIFO.h"
#include "OTM.h"
#include "LRU.h"

using namespace std;

int CountPages(const char* fileName)
{
	ifstream file;

	file.open(fileName);

    int nPages = 0;

    string number_str;
	
	if(file.is_open()){

		while(!file.eof()){
			getline(file, number_str);
			nPages++;
		}
	}
    nPages -= 2; //Exclui a linha referente ao fim do arquivo e a primeira linha, referente ao número de quadros na memória  

	file.close();

	return nPages;
}

bool ReadFileData(vector<int> &ptrPages, const char* fileName, int &memorySize)
{
	ifstream file;

	int referencePage;

	file.open(fileName);

	if(file.is_open()){

        file >> memorySize;

		for(int i = 0; i < ptrPages.size(); i++){
			
			file >> referencePage;

            ptrPages[i] = referencePage;
		}

		file.close();

		return true;
	}
	else{
		return false;
	}
}

int main(int argc, char** argv)
{
    vector<int> vectorPages;
    vector<int> memory;

    int nPages, memorySize, missingPages;

    nPages = CountPages(argv[1]);

    vectorPages.resize(nPages);

    ReadFileData(vectorPages, argv[1], memorySize);

	memory.resize(memorySize);
		
	missingPages = FIFO(vectorPages, memory);
	cout << "FIFO " << missingPages << endl;

	missingPages = OTM(vectorPages, memory);
	cout << "OTM " << missingPages << endl;
	
	missingPages = LRU(vectorPages, memory);
	cout << "LRU " << missingPages << endl;

    return 0;
}