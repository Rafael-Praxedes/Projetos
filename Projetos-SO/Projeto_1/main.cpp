/***********************************************/
/*                                             */  
/* Autor: Rafael Maranhão Rêgo Praxedes        */
/*                                             */
/* Matrícula: 11503299                         */
/*                                             */
/* Data de criação: 21/09/2017                 */
/*                                             */
/* Última modificação: 11/10/2017              */  
/*                                             */ 
/* e-mail: rafaelpraxedes10@hotmail.com        */
/*                                             */
/***********************************************/

#include <iostream>
#include <fstream>
#include <string>
#include <stdlib.h>
#include <vector> 
#include "Processo.h"
#include "Escalonador.h"

using namespace std;

int CountProcessos(char* fileName)
{
	ifstream file;

	file.open(fileName);

    int nProcessos = 0;

    string number_str;
	
	if(file.is_open()){

		while(!file.eof()){
			getline(file, number_str);
			nProcessos++;
		}
	}
    nProcessos--; //Exclui a linha referente ao fim do arquivo 

	file.close();

	return nProcessos;
}

bool ReadFileData(vector<Processo*> &ptrProcesso, char* fileName)
{
	ifstream file;

	int tempCheg, tempDur;

	file.open(fileName);

	if(file.is_open()){

		for(int i = 0; i < ptrProcesso.size(); i++){
			
			file >> tempCheg >> tempDur;

            ptrProcesso[i]->setPID(i);
			ptrProcesso[i]->setTempoChegada(tempCheg);
			ptrProcesso[i]->setDuracao(tempDur);
		}

		file.close();

		return true;
	}
	else{
		return false;
	}
}

void InitProcFila(vector<Processo*> &ptrProcesso)
{
	for (int i = 0; i < ptrProcesso.size(); ++i){
		ptrProcesso[i]->setPertenceFila(false);
		ptrProcesso[i]->setPrimeiraPosse(false);
		ptrProcesso[i]->setTempoPrimeiraPosse(0);
	}
}

void OutputFile(std::vector<tTempo*> vectorTempos, const char* nomeDoArquivo)
{
	ofstream OutputFile; 

	OutputFile.open(nomeDoArquivo);

	if(OutputFile.is_open()){

		OutputFile.precision(1);

    	OutputFile << "FCFS: " << fixed << vectorTempos[0]->tempoRetornoMedio << fixed << " " << vectorTempos[0]->tempoRespostaMedio << " " << fixed << vectorTempos[0]->tempoEsperaMedio << endl;

    	OutputFile << "SJF: " << fixed << vectorTempos[1]->tempoRetornoMedio << fixed << " " << vectorTempos[1]->tempoRespostaMedio << " " << fixed << vectorTempos[1]->tempoEsperaMedio << endl;

    	OutputFile << "RR: " << fixed << vectorTempos[2]->tempoRetornoMedio << fixed << " " << vectorTempos[2]->tempoRespostaMedio << " " << fixed << vectorTempos[2]->tempoEsperaMedio << endl;

    	OutputFile << endl;
	}
	OutputFile.close();
}

int main (int argc, char** argv)
{
	int nProcessos = CountProcessos(argv[1]);

	vector<Processo*> vetorProcessos;
	vector<tTempo*> vectorTempos;

	vetorProcessos.resize(nProcessos);

	tTempo *temposFCFS = new tTempo;
	tTempo *temposSJF = new tTempo;
	tTempo *temposRR = new tTempo;

	for(int i = 0; i < nProcessos; i++){
		vetorProcessos[i] = new Processo(0, 0, 0); 
	}

	ReadFileData(vetorProcessos, argv[1]);
		 
    InitProcFila(vetorProcessos);

    temposFCFS = FCFS(vetorProcessos);

    InitProcFila(vetorProcessos);

    temposSJF = SJF(vetorProcessos);

    InitProcFila(vetorProcessos);

    temposRR = RR(vetorProcessos, 2); 

    cout.precision(1);

    cout << "FCFS: " << fixed << temposFCFS->tempoRetornoMedio << fixed << " " << temposFCFS->tempoRespostaMedio << " " << fixed << temposFCFS->tempoEsperaMedio << endl;

    cout << "SJF: " << fixed << temposSJF->tempoRetornoMedio << fixed << " " << temposSJF->tempoRespostaMedio << " " << fixed << temposSJF->tempoEsperaMedio << endl;

    cout << "RR: " << fixed << temposRR->tempoRetornoMedio << fixed << " " << temposRR->tempoRespostaMedio << " " << fixed << temposRR->tempoEsperaMedio << endl; 
 
    vectorTempos.push_back(temposFCFS);
    vectorTempos.push_back(temposSJF);
    vectorTempos.push_back(temposRR);

    OutputFile(vectorTempos, "OutputFile.txt");

    delete temposFCFS;
    delete temposSJF;
    delete temposRR;

    for (int i = 0; i < vetorProcessos.size(); ++i){
    	delete vetorProcessos[i];
    }

	return 0;
}