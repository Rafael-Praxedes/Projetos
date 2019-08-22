#ifndef ESCALONADOR_H
#define ESCALONADOR_H

#include "Processo.h"

typedef struct 
{
	double tempoRetornoMedio;
	double tempoRespostaMedio;
	double tempoEsperaMedio;
	
} tTempo;

extern tTempo* FCFS(vector<Processo*> vectorProcessos);
extern tTempo* SJF(vector<Processo*> vectorProcessos);
extern tTempo* RR(vector<Processo*> vectorProcessos, int quantum);

#endif