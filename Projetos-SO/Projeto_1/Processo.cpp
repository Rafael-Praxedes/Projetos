#include "Processo.h"

Processo::Processo(int pid, int tempCheg, int tempDur)
{
	this->pid = pid;
	this->tempoChegada = tempCheg;
	this->tempoDuracao = tempDur;
}

void Processo::setPID(int valorPID)
{
	this->pid = valorPID;
}

void Processo::setTempoChegada(int tempCheg)
{
	this->tempoChegada = tempCheg;
}

void Processo::setDuracao(int tempDur)
{
	this->tempoDuracao = tempDur;
}

void Processo::setPertenceFila(bool naFila)
{
	this->pertenceFila = naFila;
}

void Processo::setPrimeiraPosse(bool posse)
{
	this->primeiraPosse = posse;
}

void Processo::setTempoPrimeiraPosse(int tempo)
{
	this->tempoPrimeiraPosse = tempo;
}

int Processo::getPID(void)
{
	return this->pid;
}

int Processo::getTempoChegada(void)
{
	return this->tempoChegada;
}

int Processo::getDuracao(void)
{
	return this->tempoDuracao;
}

bool Processo::getPertenceFila(void)
{
	return this->pertenceFila;
}

bool Processo::getPrimeiraPosse(void)
{
	return this->primeiraPosse;
}

int Processo::getTempoPrimeiraPosse(void)
{
	return this->tempoPrimeiraPosse;
}