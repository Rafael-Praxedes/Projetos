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

#include "MatrixInput.h"

void BuildMatrixInput(vector< vector<int> > &matrix, char* fileName)
{
	ifstream file;

	file.open(fileName);

	string sizeMatrix;

	int size, indexAux;

	int aux;

	//----------------------------------//
	//----- Build Matrix from file -----//
	//----------------------------------//

	if(file.is_open()){

		getline(file, sizeMatrix);

		size = atoi(sizeMatrix.c_str());

		for(int i = 0; i < size; i++){
				
			vector<int> line;

			for(int j = 0; j < size; j++){

				//cout << "i: " << i << " j: " << j << endl;

				if(i == j || i > j){					
					line.push_back(0);
				}
				else{	
					file >> aux;
					line.push_back(aux);
				}
				//cout << "line[j]: " << line[j] << endl;
			}
			matrix.push_back(line);
		}
	}

	file.close();
	//----------------------------------//

	//----------------------------------//
	//------- Matrix's complement ------//
	//----------------------------------//
	
	for (int i = 0; i < matrix.size(); ++i){
		for (int j = 0; j < matrix[i].size(); ++j){
			if(i > j)
				matrix[i][j] = matrix[j][i];
		}
	}
	//----------------------------------//
}