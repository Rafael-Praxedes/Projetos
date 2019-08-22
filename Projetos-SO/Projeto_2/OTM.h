#ifndef OTM_H
#define OTM_H

#include <iostream>
#include <vector>
#include <climits>

using namespace std;

extern int FindElement(vector<int> &vectorElements, int element);
extern int MaxElement(vector<int> &vectorElements);
extern int LastIndex(vector<int> &vectorPages, int element, int startIndex);
extern int OTM(vector<int> &vectorPages, vector<int> &vectorMemory);

#endif