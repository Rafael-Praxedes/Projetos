#include "FIFO.h"

int FIFO(vector<int> &vectorPages, vector<int> &vectorMemory)
{
    int missingPages = 0, index;
    bool find = false;
    
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
            vectorMemory.erase(vectorMemory.begin());
            vectorMemory.push_back(vectorPages[index]);
        }
        else{
            find = false;
        }
        
        index++;
    }

    return missingPages;
}