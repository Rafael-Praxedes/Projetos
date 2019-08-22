#include "OTM.h"

int FindElement(vector<int> &vectorElements, int element)
{
    for(int i = 0; i < vectorElements.size(); i++){
        if(vectorElements[i] == element)
            return i;
    }
    return -1;
}

int MaxElement(vector<int> &vectorElements)
{
    int max = 0;

    for(int i = 0; i < vectorElements.size(); i++){
        if(vectorElements[i] > max)
            max = vectorElements[i];
    }

    return max;
}

int LastIndex(vector<int> &vectorPages, int element, int startIndex)
{
    for(int i = startIndex; i < vectorPages.size(); i++){
        if(vectorPages[i] == element)
            return i;
    }
    return INT_MAX;
}

int OTM(vector<int> &vectorPages, vector<int> &vectorMemory)
{
    int missingPages = 0, index, lastIndex, indexAux;
    bool find = false;

    vector<int> lastIndexs;
    lastIndexs.resize(vectorMemory.size());
    
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
                lastIndexs[i] = LastIndex(vectorPages, vectorMemory[i], index);
            }

            indexAux = MaxElement(lastIndexs);

            if(indexAux != INT_MAX)                                              
                lastIndex = FindElement(vectorMemory, vectorPages[indexAux]);    
            else                                                                 /*Se o máximo for infinito, isso quer dizer que há uma pagina na memória que não será mais referenciada*/ 
                lastIndex = FindElement(lastIndexs, indexAux);                   /*Isso significa que ela poderá ser substituida pela página que está requisitando memória*/
            
            if(lastIndex >= 0){
                vectorMemory.erase(vectorMemory.begin() + lastIndex);
                vectorMemory.insert(vectorMemory.begin() + lastIndex, vectorPages[index]);
            }
        }
        else{
            find = false;
        }
        
        index++;
    }

    return missingPages;
}