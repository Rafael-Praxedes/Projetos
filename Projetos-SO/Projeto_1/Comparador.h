#ifndef COMPARADOR_H
#define COMPARADOR_H

#include <iostream>
#include <vector> 

#include "Processo.h"

using namespace std;

extern bool ComparadorTempChegada(Processo *p1, Processo *p2);
extern bool ComparadorDuracao(Processo *p1, Processo *p2);

#endif