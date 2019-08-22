#ifndef PROCESSO_H
#define PROCESSO_H

#include <iostream>
#include <vector> 

using namespace std;

class Processo
{
public:
	Processo(int pid, int tempCheg, int tempDur);
	void setPID(int valorPID);
	void setTempoChegada(int tempCheg);
	void setDuracao(int tempDur);
	void setPertenceFila(bool naFila);
	void setPrimeiraPosse(bool posse);
	void setTempoPrimeiraPosse(int tempo);
	int getTempoChegada(void);
	int getDuracao(void);
	int getPID(void);
	bool getPertenceFila(void);
	bool getPrimeiraPosse(void);
	int getTempoPrimeiraPosse(void);
	
private:
	int tempoChegada;
	int tempoDuracao;
	int pid;
	bool pertenceFila;
	bool primeiraPosse;
	int tempoPrimeiraPosse;
};

#endif