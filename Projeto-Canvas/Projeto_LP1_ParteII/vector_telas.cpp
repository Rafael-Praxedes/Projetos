#include "vector_telas.h"

/***** CANVAS *****/

int altura_canvas;
int largura_canvas;

int indice_global = -1;

bool limpar_canvas = false;
bool remover_poligono = false;

bool apagador = false;

bool criador;
bool deletor;
QVector<Poligono*> poligonosDoCanvas;

/***** POLIGONO *****/

int coord_x;
int coord_y;

/***** RETANGULO *****/

bool insere_retangulo = false;
bool edita_retangulo = false;

/***** CIRCULO *****/

bool insere_circulo = false;
bool edita_circulo = false;

/***** TRIANGULO *****/

bool insere_triangulo = false;
bool edita_triangulo = false;

/***** HEXAGONO *****/

bool insere_hexagono = false;
bool edita_hexagono = false;

