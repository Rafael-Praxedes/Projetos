/***********************************************/
/*                                             */  
/* Autor: Rafael Maranhão Rêgo Praxedes        */
/*                                             */
/* Matrícula: 11503299                         */
/*                                             */
/* Data de criação: 11/10/2017                 */
/*                                             */
/* Última modificação: 12/10/2017              */  
/*                                             */ 
/* e-mail: rafaelpraxedes10@hotmail.com        */
/*                                             */
/***********************************************/

#include <iostream>
#include <fstream>
#include <vector>
#include "Produto.h"
#include "Mochila.h"

using namespace std;

void InitProdutos(vector<Produto*> &vectorProdutos)
{
    for(int i = 0; i < vectorProdutos.size(); i++){
        vectorProdutos[i] = new Produto;
    }
}

bool ReadInputFile(vector<Produto*> &vectorProdutos, int &capacityBag, char* fileName)
{
    ifstream file;

    int size, id, weigth, value;
    
    file.open(fileName);

    if(file.is_open()){

        file >> size;
        
        vectorProdutos.resize(size);
        
        InitProdutos(vectorProdutos);
        
        file >> capacityBag;
    
        for(int i = 0; i < vectorProdutos.size(); i++){
            
            id = i + 1;
            file >> weigth >> value;
            
            vectorProdutos[i]->setId(id);
            vectorProdutos[i]->setWeigth(weigth);
            vectorProdutos[i]->setValue(value);
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
    vector<Produto*> produtos;
    vector<Produto*> solucao;

    int capacityBag, maxValue;

    ReadInputFile(produtos, capacityBag, argv[1]);

    cout << "\n\t>>>>> Produtos Disponiveis <<<<<\n" << endl;

    for(int i = 0; i < produtos.size(); i++){
        cout << "Produto[" << produtos[i]->getId() << "]: " << endl;
        cout << "\t>>>Weigth: " << produtos[i]->getWeigth() << endl;
        cout << "\t>>>Value: " << produtos[i]->getValue() << endl;
    }

    cout << "\nCapacidade da mochila: " << capacityBag << endl;

    maxValue = Knapsack(produtos, solucao, capacityBag);

    cout << "\n\t>>>>> Produtos Solucao <<<<<\n" << endl;

    for(int i = solucao.size() - 1; i >= 0; i--){
        cout << "Produto[" << solucao[i]->getId() << "]: " << endl;
        cout << "\t>>>Weigth: " << solucao[i]->getWeigth() << endl;
        cout << "\t>>>Value: " << solucao[i]->getValue() << endl;
    }

    for(int i = 0; i < produtos.size(); i++){
        delete produtos[i];
    }

    cout << "\nValor maximo da mochila: " << maxValue << endl;

    cout << "\nPrograma encerrado!" << endl;

    return 0;
}