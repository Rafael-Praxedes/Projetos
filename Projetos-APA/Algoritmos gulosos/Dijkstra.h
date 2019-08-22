#ifndef DIJKSTRA_H
#define DIJKSTRA_H

#include <iostream>
#include <vector>
#include <limits.h> 
#include "Vertex.h"
#include "MinHeap.h"

using namespace std;

//Functions 
extern void Dijkstra(vector<vector<int> > originalMatrix, vector<tVertex> &vectorVertex, int origin, int destiny);

#endif