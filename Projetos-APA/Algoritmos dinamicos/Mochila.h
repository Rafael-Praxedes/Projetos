#ifndef MOCHILA_H
#define MOCHILA_H

#include <iostream>
#include <vector>

#include "Produto.h"

using namespace std;

extern int Knapsack(vector<Produto*> &vectorProdutos, vector<Produto*> &vectorSolution, int capacityBag);

#endif
