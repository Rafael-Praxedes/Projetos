#include "poligonos.h"

/********** CLASSE POLIGONO **********/

Poligono& Poligono::setCor(QString c)
{
   this->cor = c;

   return *this;
}

Poligono& Poligono::setZIndex(int z)
{
    this->zIndex = z;

    return *this;
}

Poligono& Poligono::setCoordenadasCentro(int x, int y)
{
   this->coordenada_x = x;
   this->coordenada_y = y;

   return *this;
}

int Poligono::getZIndex(void)
{
    return zIndex;
}

QString Poligono::getCorPoligono(void)
{
   return cor;
}

int Poligono::getCentroPoligono_x(void)
{
   return coordenada_x;
}

int Poligono::getCentroPoligono_y(void)
{
   return coordenada_y;
}

/********** CLASSE RETANGULO **********/

Retangulo& Retangulo::setBase(int b)
{
   this->base = b;

   return *this;
}

Retangulo& Retangulo::setAltura(int a)
{
   this->altura = a;

   return *this;
}

QString Retangulo::getTipo(void)
{
   return  tipo = "Retangulo";
}

int Retangulo::getBase()
{
    return base;
}

int Retangulo::getAltura()
{
    return altura;
}

/********** CLASSE CIRCULO **********/

Circulo& Circulo::setRaio(int r)
{
   this->raio = r;

   return *this;
}

QString Circulo::getTipo(void)
{
   return tipo = "Circulo";
}

int Circulo::getBase(void)
{
   return raio;
}

int Circulo::getAltura(void)
{
   return raio;
}

/********** CLASSE TRIANGULO **********/

Triangulo& Triangulo::setLado(int l)
{
    lado = l;

    return *this;
}

QString Triangulo::getTipo(void)
{
   return  tipo = "Triangulo";
}

int Triangulo::getBase(void)
{
   return lado;
}

int Triangulo::getAltura(void)
{
   return lado;
}

/********** CLASSE HEXAGONO **********/

Hexagono&Hexagono::setLado(int l)
{
   lado = l;

   return *this;
}

QString Hexagono::getTipo(void)
{
   return  tipo = "Hexagono";
}

int Hexagono::getBase(void)
{
   return lado;
}

int Hexagono::getAltura(void)
{
   return lado;
}



