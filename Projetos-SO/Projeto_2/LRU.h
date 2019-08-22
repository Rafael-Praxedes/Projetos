#ifndef LRU_H
#define LRU_H

#include <iostream>
#include <vector>
#include <climits> 

#include "OTM.h"

using namespace std;

extern int MinElement(vector<int> &vectorElements);
extern int FirstIndex(vector<int> &vectorPages, int element, int startIndex);
extern int LRU(vector<int> &vectorPages, vector<int> &vectorMemory);

#endif