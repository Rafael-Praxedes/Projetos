#ifndef POLIGONOS_H
#define POLIGONOS_H

#include <QString>

/********** CLASSE POLIGONO **********/

 class Poligono
{
   int coordenada_x;
   int coordenada_y;
   int zIndex;
   QString cor;

public:
   Poligono& setCor(QString c);
   Poligono& setCoordenadasCentro (int x, int y);
   Poligono& setZIndex(int z);
   int getZIndex(void);
   virtual QString getTipo(void) = 0;
   virtual int getBase(void) = 0;
   virtual int getAltura(void) = 0;
   int getCentroPoligono_x(void);
   int getCentroPoligono_y(void);
   QString getCorPoligono(void);
};

 /********** CLASSE RETANGULO **********/

 class Retangulo: public Poligono
 {
    int base;
    int altura;
    QString tipo;

 public:
     Retangulo& setBase(int b);
     Retangulo& setAltura(int a);
     QString getTipo(void);
     int getBase(void);
     int getAltura(void);
 };

 /********** CLASSE CIRCULO **********/

 class Circulo: public Poligono
 {
    int raio;
    QString tipo;

 public:
    Circulo& setRaio(int r);
    QString getTipo(void);
    int getBase(void);
    int getAltura(void);
 };

 /********** CLASSE TRIANGULO **********/

 class Triangulo: public Poligono
 {
    int lado;
    QString tipo;

 public:
    Triangulo& setLado(int l);
    QString getTipo(void);
    int getBase(void);
    int getAltura(void);
 };

 /********** CLASSE HEXAGONO **********/

 class Hexagono: public Poligono
 {
    int lado;
    QString tipo;

 public:
     Hexagono& setLado(int l);
     QString getTipo(void);
     int getBase(void);
     int getAltura(void);
 };



#endif // POLIGONOS_H





