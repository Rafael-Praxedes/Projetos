#ifndef MINHEAP_H
#define MINHEAP_H

#include <iostream>
#include <vector> 
#include <limits.h>
#include "Vertex.h"

#define FIRST_ELEMENT_INDEX 0

using namespace std;

//Functions
extern int Dad(int index);
extern int LeftChild(int index);
extern int RightChild(int index);
extern void MinHeapify(vector<tVertex> &vector, int index);
extern void BuildMinHeap(vector<tVertex> &vector);
extern tVertex HeapMinimum(vector<tVertex> &vector);
extern tVertex HeapExtractMinimum(vector<tVertex> &vector);
extern void HeapDecreaseKey(vector<int> &vector, int index, int key);
extern void MinHeapInsert(vector<int> &vector, int key);

#endif 
