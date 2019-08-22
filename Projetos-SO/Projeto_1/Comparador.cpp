#include "Comparador.h"

bool ComparadorTempChegada(Processo *p1, Processo *p2)
{
	return (p1->getTempoChegada() < p2->getTempoChegada());
}

bool ComparadorDuracao(Processo *p1, Processo *p2)
{
	return (p1->getDuracao() < p2->getDuracao());
}