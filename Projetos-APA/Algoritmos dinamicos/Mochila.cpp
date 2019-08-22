#include "Mochila.h"

int Knapsack(vector<Produto*> &vectorProdutos, vector<Produto*> &vectorSolution, int capacityBag)
{
    vector<vector<int> > matrix;
    int capacitySolution;

    matrix.resize(vectorProdutos.size() + 1);

    //Define matrix's size
    for(int i = 0; i < vectorProdutos.size() + 1; i++){
        matrix[i].resize(capacityBag + 1);
    }

    for (int j = 0; j <= capacityBag; j++){
        matrix[0][j] = 0;                    //init first line with 0
    }
    for(int i = 0; i <= vectorProdutos.size(); i++){
        matrix[i][0] = 0;                    //init first column with 0
    }

    for(int i = 1; i <= vectorProdutos.size(); i++){

        for(int j = 1; j <= capacityBag; j++){

            if(vectorProdutos[i - 1]->getWeigth() <= j){

                if((vectorProdutos[i - 1]->getValue() + matrix[i - 1][j - vectorProdutos[i - 1]->getWeigth()]) > matrix[i - 1][j])
                    matrix[i][j] = vectorProdutos[i - 1]->getValue() + matrix[i - 1][j - vectorProdutos[i - 1]->getWeigth()];
                else
                    matrix[i][j] = matrix[i - 1][j];
            }//if
            else
                matrix[i][j] = matrix[i - 1][j];
        }//for
    }//for

    capacitySolution = capacityBag;

    for(int i = vectorProdutos.size(); i >= 1; i--){
        if(matrix[i][capacitySolution] != matrix[i - 1][capacitySolution]){
            
            vectorSolution.push_back(vectorProdutos[i - 1]);

            capacitySolution = capacitySolution - vectorProdutos[i - 1]->getWeigth();
        }
    }
    
    return matrix[vectorProdutos.size()][capacityBag];
}