#include "Escalonador.h"
#include "Comparador.h"

#include <algorithm>

using namespace std;

tTempo* FCFS(vector<Processo*> vectorProcessos)
{
	vector<Processo*> filaDeProntos;

	int tempoRetorno = 0, tempoEspera = 0, tempoResposta = 0;

	int tempoAtual = 0;

	int nProcessos = vectorProcessos.size();

    tTempo *tempoFCFS = new tTempo;

    sort(vectorProcessos.begin(), vectorProcessos.end(), ComparadorTempChegada);

	while(nProcessos > 0){

		for(int i = 0; i < vectorProcessos.size(); i++){
		
     	   if(vectorProcessos[i]->getPertenceFila() == false && vectorProcessos[i]->getTempoChegada() <= tempoAtual){
        		
        		vectorProcessos[i]->setPertenceFila(true);
        		filaDeProntos.push_back(vectorProcessos[i]);
        	}	
		}

		if(filaDeProntos.size()){

			Processo *ptrProcessoCPU = filaDeProntos.front();

			filaDeProntos.erase(filaDeProntos.begin());

			nProcessos--;

			tempoResposta += tempoAtual - ptrProcessoCPU->getTempoChegada();
			tempoEspera = tempoResposta;

			tempoAtual += ptrProcessoCPU->getDuracao();

			tempoRetorno += tempoAtual - ptrProcessoCPU->getTempoChegada();
		}
		else
			tempoAtual++;

	}

	tempoFCFS->tempoRetornoMedio =  ( (double) tempoRetorno) / ( (double) vectorProcessos.size());
	tempoFCFS->tempoRespostaMedio = ( (double) tempoResposta) / ( (double) vectorProcessos.size());
	tempoFCFS->tempoEsperaMedio = tempoFCFS->tempoRespostaMedio;

	return tempoFCFS;
}

tTempo* SJF(vector<Processo*> vectorProcessos)
{
    vector<Processo*> filaDeProntos;

    int tempoRetorno = 0, tempoEspera = 0, tempoResposta = 0;
    
    int tempoAtual = 0;

    int nProcessos = vectorProcessos.size();

    tTempo *tempoSJF = new tTempo;

    sort(vectorProcessos.begin(), vectorProcessos.end(), ComparadorTempChegada);

    while(nProcessos > 0){

        for (int i = 0; i < vectorProcessos.size(); ++i){

            if(vectorProcessos[i]->getPertenceFila() == false && vectorProcessos[i]->getTempoChegada() <= tempoAtual){
    
                vectorProcessos[i]->setPertenceFila(true);
                filaDeProntos.push_back(vectorProcessos[i]);
            }
        }

        if(filaDeProntos.size()){

        	sort(filaDeProntos.begin(), filaDeProntos.end(), ComparadorDuracao);

        	Processo *ptrProcessoCPU = filaDeProntos.front();

			filaDeProntos.erase(filaDeProntos.begin());

			nProcessos--;

        	//Tempo de Resposta
        	tempoResposta += tempoAtual - ptrProcessoCPU->getTempoChegada(); 

        	//Tempo de Espera
        	tempoEspera = tempoResposta;  
         
        	tempoAtual += ptrProcessoCPU->getDuracao();

        	//Tempo de Retorno
        	tempoRetorno += tempoAtual - ptrProcessoCPU->getTempoChegada();
        }
        else
        	tempoAtual++;
    }

    //Tempo de Retorno Médio
    tempoSJF->tempoRetornoMedio = ( (double) tempoRetorno) / ( (double) vectorProcessos.size());
   
    //Tempo de Resposta Médio
    tempoSJF->tempoRespostaMedio = ( (double) tempoResposta) / ( (double) vectorProcessos.size());
  
    //Tempo de Espera Médio 
    tempoSJF->tempoEsperaMedio = tempoSJF->tempoRespostaMedio; 
   
    return tempoSJF;
}

tTempo* RR(vector<Processo*> vectorProcessos, int quantum)
{
    vector<Processo*> filaDeProntos;

    int tempoRetorno = 0, tempoEspera = 0, tempoResposta = 0;
    
    int tempoAtual = 0;

    int nProcessos = vectorProcessos.size();

    tTempo *tempoRR = new tTempo;

    vector<int> tempoExecucao;
    vector<int> tempoVida;
    vector<int> v;

    tempoExecucao.resize(vectorProcessos.size());
    tempoVida.resize(vectorProcessos.size());

    Processo *ptrAux = NULL;

    sort(vectorProcessos.begin(), vectorProcessos.end(), ComparadorTempChegada);

    while(true){

        for (int i = 0; i < vectorProcessos.size(); ++i){

            if(vectorProcessos[i]->getPertenceFila() == false && vectorProcessos[i]->getTempoChegada() <= tempoAtual){

                vectorProcessos[i]->setPertenceFila(true);
                
                tempoExecucao[vectorProcessos[i]->getPID()] = 0;
                
                tempoVida[vectorProcessos[i]->getPID()] = 0;
                
                filaDeProntos.push_back(vectorProcessos[i]);
            }
        }

        if(ptrAux != NULL){

        	if(tempoExecucao[ptrAux->getPID()] < ptrAux->getDuracao()){
        		
        		filaDeProntos.push_back(ptrAux);
        		nProcessos++;

        		ptrAux = NULL;
        	}
        }

        if (!nProcessos)
        	break;

        if(filaDeProntos.size()){

        	Processo *ptrProcessoCPU = filaDeProntos.front();

			filaDeProntos.erase(filaDeProntos.begin());

			nProcessos--;

			if(ptrProcessoCPU->getPrimeiraPosse() == false){
				ptrProcessoCPU->setPrimeiraPosse(true);
				ptrProcessoCPU->setTempoPrimeiraPosse(tempoAtual);
			}

			tempoExecucao[ptrProcessoCPU->getPID()] += quantum;

			if(ptrProcessoCPU->getDuracao() < tempoExecucao[ptrProcessoCPU->getPID()])
				tempoAtual += min(quantum, abs(ptrProcessoCPU->getDuracao() - tempoExecucao[ptrProcessoCPU->getPID()]));
			else
				tempoAtual += quantum;

			ptrAux = ptrProcessoCPU;

			tempoVida[ptrProcessoCPU->getPID()] = tempoAtual;  
        }
        else
        	tempoAtual++;
    }

    for (int i = 0; i < vectorProcessos.size(); ++i){
    	tempoRetorno += tempoVida[i] - vectorProcessos[i]->getTempoChegada();
    	tempoResposta += (vectorProcessos[i]->getTempoPrimeiraPosse() - vectorProcessos[i]->getTempoChegada());
    	tempoEspera  += tempoVida[i] - (vectorProcessos[i]->getDuracao() + vectorProcessos[i]->getTempoChegada());
    }

    //Tempo de Retorno Médio
    tempoRR->tempoRetornoMedio = ( (double) tempoRetorno) / ( (double) vectorProcessos.size());
   
    //Tempo de Resposta Médio
    tempoRR->tempoRespostaMedio = ( (double) tempoResposta) / ( (double) vectorProcessos.size());
  
    //Tempo de Espera Médio 
    tempoRR->tempoEsperaMedio = ( (double) tempoEspera) / ( (double) vectorProcessos.size()); 
   
    return tempoRR;
}
