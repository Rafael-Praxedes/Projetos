#ifndef VECTOR_TELAS_H
#define VECTOR_TELAS_H

#include <QVector>
#include <poligonos.h>

/***** CANVAS *****/

extern int largura_canvas;
extern int altura_canvas;

extern bool criador;
extern bool deletor;
extern bool limpar_canvas;
extern bool remover_poligono;

extern int indice_global;

extern bool apagador; //utilizado no arquivo de editar poligono

extern QVector<Poligono*> poligonosDoCanvas;

/***** POLIGONO *****/

extern int coord_x;
extern int coord_y;

/***** RETANGULO *****/

extern bool insere_retangulo;
extern bool edita_retangulo;

/***** CIRCULO *****/

extern bool insere_circulo;
extern bool edita_circulo;

/***** TRIANGULO *****/

extern bool insere_triangulo;
extern bool edita_triangulo;

/***** HEXAGONO *****/

extern bool insere_hexagono;
extern bool edita_hexagono;

#endif // VECTOR_TELAS_H
