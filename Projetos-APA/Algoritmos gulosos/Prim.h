#ifndef PRIM_H
#define PRIM_H

#include <iostream>
#include <vector>
#include <limits.h> 
#include "Vertex.h"
#include "MinHeap.h"

using namespace std;

//Functions 
extern void Prim(vector<vector<int> > originalMatrix, vector<tVertex> &vectorVertex, int root);

#endif