#include "LRU.h"

int MinElement(vector<int> &vectorElements)
{
    int min = INT_MAX;

    for(int i = 0; i < vectorElements.size(); i++){
        if(vectorElements[i] < min)
            min = vectorElements[i];
    }
    return min;
}

int FirstIndex(vector<int> &vectorPages, int element, int startIndex)
{
    for(int i = startIndex; i >= 0; i--){
        if(vectorPages[i] == element)
            return i;
    }
    return 0;
}

int LRU(vector<int> &vectorPages, vector<int> &vectorMemory)
{
    int missingPages = 0, index, firstIndex;
    bool find = false;

    vector<int> firstIndexs;
    firstIndexs.resize(vectorMemory.size());
    
    for(index = 0; index < vectorMemory.size(); index++){
        vectorMemory[index] = vectorPages[index];
        missingPages++;
    }
    
    while(index < vectorPages.size()){
        for(int j = 0; j < vectorMemory.size(); j++){
            if(vectorPages[index] == vectorMemory[j]){
                find = true;
                break;
            }
        }

        if(find == false){
            missingPages++;
            
            for(int i = 0; i < vectorMemory.size(); i++){
                firstIndexs[i] = FirstIndex(vectorPages, vectorMemory[i], index); 
            }
                
            firstIndex = FindElement(vectorMemory, vectorPages[MinElement(firstIndexs)]);

            if(firstIndex >= 0){
                vectorMemory.erase(vectorMemory.begin() + firstIndex);
                vectorMemory.insert(vectorMemory.begin() + firstIndex, vectorPages[index]);
            }
        }
        else{
            find = false;
        }
        
        index++;
    }

    return missingPages;
}