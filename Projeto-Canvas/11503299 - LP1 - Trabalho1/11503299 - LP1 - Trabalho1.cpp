/****
 *
 * Aluno: Rafael Maranhão Rêgo Praxedes
 *
 * Matrícula: 11503299
 *
 * Data de Criação:  02/04/2016
 * Última alteração: 10/04/2016
 *
 * Descrição Geral: Primeira parte do projeto da disciplina de LP1
 *
 ****/

#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string>
#include <string.h>
#include <vector>

#define PI 3.14
#define NUMERO_MAXIMO 100
#define TAM 11
#define REFERENCIA 999999

extern void LimpaBuffer (void);
extern int LeUmInteiro(void);

using namespace std;

/********** CLASSE POLIGONO **********/

 class Poligono
{
   int coordenadasCentro[2];
   int zIndex;
   string cor;

public:
   Poligono& setCor(string c);
   Poligono& setCoordenadasCentro (int* centro);
   Poligono& setZIndex(int z);
   int getZIndex(void);
   virtual string getTipo(void) = 0;
   virtual int Area(void) = 0;
   virtual int Perimetro(void) = 0;
   int* getCentroPoligono(void);
   string getCorPoligono(void);
};

Poligono& Poligono::setCor(string c)
{
   this->cor = c;

   return *this;
}

Poligono& Poligono::setZIndex(int z)
{
    this->zIndex = z;

    return *this;
}

Poligono& Poligono::setCoordenadasCentro(int* centro)
{
   for (int i = 0; i < 2; i++){
         this->coordenadasCentro[i] = centro[i];
   }

   return *this;
}

int Poligono::getZIndex(void)
{
    return zIndex;
}

string Poligono::getCorPoligono(void)
{
   return cor;
}

int* Poligono::getCentroPoligono(void)
{
   return coordenadasCentro;
}

/********** CLASSE RETANGULO **********/

class Retangulo: public Poligono
{
   int base;
   int altura;
   string tipo;

public:
    Retangulo& setBase(int b);
    Retangulo& setAltura(int a);
    string getTipo(void);
    int Area(void);
    int Perimetro(void);
};

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

string Retangulo::getTipo(void)
{
   return  tipo = "Retangulo";
}

int Retangulo::Area(void)
{
   return base*altura;
}

int Retangulo::Perimetro(void)
{
   return (2*base + 2*altura);
}

/********** CLASSE CIRCULO **********/

class Circulo: public Poligono
{
   int raio;
   string tipo;

public:
   Circulo& setRaio(int r);
   string getTipo(void);
   int Area(void);
   int Perimetro(void);
};

Circulo& Circulo::setRaio(int r)
{
   this->raio = r;

   return *this;
}

string Circulo::getTipo(void)
{
   return  tipo = "Circulo";
}

int Circulo::Area(void)
{
   int area = (int) PI*raio*raio;
   return area;
}

int Circulo::Perimetro(void)
{
   int perimetro = (int) 2*PI*raio;
   return perimetro;
}

/********** CLASSE PENTAGONO **********/

class Pentagono: public Poligono
{
   int lado;
   string tipo;

public:
   Pentagono& setLado(int l);
   string getTipo(void);
   int Area(void);
   int Perimetro(void);
};

Pentagono& Pentagono::setLado(int l)
{
    lado = l;

    return *this;
}

string Pentagono::getTipo(void)
{
   return  tipo = "Pentagono regular";
}

int Pentagono::Area(void)
{
   int a = (int) (5*lado*lado)/(4*sqrt(5 - 2*sqrt(5)));

   return a;
}

int Pentagono::Perimetro(void)
{
   int p = 5*lado;

   return p;
}

/********** CLASSE HEXAGONO **********/

class Hexagono: public Poligono
{
   int lado;
   string tipo;

public:
    Hexagono& setLado(int l);
    string getTipo(void);
    int Area(void);
    int Perimetro(void);
};

Hexagono&Hexagono::setLado(int l)
{
   lado = l;

   return *this;
}

string Hexagono::getTipo(void)
{
   return  tipo = "Hexagono regular";
}

int Hexagono::Area(void)
{
   int a = (int) 6*(lado*lado*sqrt(3))/4;

   return a;
}

int Hexagono::Perimetro(void)
{
   int p = 6*lado;

   return p;
}

/********** CLASSE CANVAS **********/

class Canvas
{
   int tamanhoEmPixels[2];
   vector <Poligono*> poligonosDoCanvas;
public:
   Canvas (int c, int l);
   int* getTamanhoDoCanvas(void);
   void setPoligonosDoCanvas(Poligono* p);
   vector<Poligono*>& getPoligonosDoCanvas(void);
   void ExibePoligonosDoCanvas(void);
};

Canvas::Canvas(int c, int l)
{
   tamanhoEmPixels[0] = c;
   tamanhoEmPixels[1] = l;
}

void Canvas::setPoligonosDoCanvas(Poligono* p)
{
   poligonosDoCanvas.push_back(p);
}

int* Canvas::getTamanhoDoCanvas(void)
{
   return tamanhoEmPixels;
}

vector<Poligono*>& Canvas::getPoligonosDoCanvas(void)
{
   return poligonosDoCanvas;
}

void Canvas::ExibePoligonosDoCanvas(void)
{
   system("cls");

   cout << "\n\t>>> LISTA DE POLIGONOS <<<\n" << endl;

   if (!poligonosDoCanvas.size()){
      cout << "\n\aNao ha nada para exibir na tela!" << endl;
   }

   for(unsigned int i = 0; i < poligonosDoCanvas.size(); i++){

         cout << "\nTipo: " << poligonosDoCanvas[i]->getTipo() << endl;

         cout << "\nCentro: (" <<  poligonosDoCanvas[i]->getCentroPoligono()[0] << ", " << poligonosDoCanvas[i]->getCentroPoligono()[1] << ")" << endl;

         cout << "\nCor: " << poligonosDoCanvas[i]->getCorPoligono() << endl;

         cout << "\nArea: " << poligonosDoCanvas[i]->Area() << endl;

         cout << "\nPerimetro: " << poligonosDoCanvas[i]->Perimetro() << endl << endl;
   }
}

/********** FUNCAO ExibeMenu **********/

void ExibeMenu(void)
{
   printf ("\n\t>>> MENU DE OPERACOES <<<\n"
           "\n1 - Exibir informacoes da tela de desenho"
           "\n2 - Inserir Retangulo"
           "\n3 - Inserir Circulo"
           "\n4 - Inserir Pentagono regular"
           "\n5 - Inserir Hexagono regular"
           "\n6 - Exibir poligonos na tela"
           "\n7 - Eliminar poligono pelo indice de insercao"
           "\n8 - Salvar um arquivo de texto contendo todos os poligonos do Canvas"
           "\n9 - Sair\n");
}

/********** FUNCAO ExibeInformacoesDoCanvas **********/

void ExibeInformacoesDoCanvas(Canvas& c)
{
   system("cls");

   cout << "\n\t>>> INFORMACOES DA TELA DE DESENHO <<<\n" << endl;

   int *p = c.getTamanhoDoCanvas();

   cout << "\nResolucao da tela: " << p[0] << " x " << p[1] << " pixels" << endl;
   cout << "\nQuantidade de poligonos: " << (c.getPoligonosDoCanvas().size()) << endl;

}

/********** FUNCAO InsereRetangulo **********/

void InsereRetangulo(Canvas& c, vector<Retangulo*> &r, int i, vector<int> &zIndex, int &nVezes)
{
   int b, a;
   int centro[2];
   string cor;

   static Retangulo ret[NUMERO_MAXIMO];

   r.push_back(&ret[i]);

   system("cls");

   cout << "\n\t>>> Retangulo <<<\n";

   cout << "\nDigite um valor inteiro correspondente a coordenada x do centro: ";
   centro[0] = LeUmInteiro();

   cout << "\nDigite um valor inteiro correspondente a coordenada y do centro: ";
   centro[1] = LeUmInteiro();

   int* verificador = c.getTamanhoDoCanvas();

   while (centro[0] > verificador[1] || centro[1] > verificador[0]){

        system("cls");

        cout << "\n\aO limite da tela nao pode ser ultrapassado! Por favor, tente novamente!" << endl;

        cout << "\nDigite um valor inteiro correspondente a coordenada x do centro: ";
        centro[0] = LeUmInteiro();

        cout << "\nDigite um valor inteiro correspondente a coordenada y do centro: ";
        centro[1] = LeUmInteiro();
   }

   for (unsigned int j = 0; j < c.getPoligonosDoCanvas().size(); j++){

        if (c.getPoligonosDoCanvas()[j]->getCentroPoligono()[0] == centro[0] && c.getPoligonosDoCanvas()[j]->getCentroPoligono()[1] == centro[1]){

            int z;

            if (!nVezes){
                    cout << "\n\aAlgum poligono ja possui essas coordenadas como centro!" << endl;

                    cout << "\n\t>>> COORDENADA DE SOBREPOSICAO <<<\n" << endl;
                    cout << "\nObs.: Essa coordenada refere-se ao poligono ja existente!" << endl;
                    cout << "\nDigte um valor inteiro correspondente a uma coordenada de sobreposicao: ";
                    z = LeUmInteiro();

                    zIndex.push_back(z);

                    c.getPoligonosDoCanvas()[j]->setZIndex(zIndex[j]);
                    cout << "\nIndice inserido com sucesso!" << endl;

            }

            if (nVezes> 0 && j == c.getPoligonosDoCanvas().size() - 1){

                    cout << "\n\aAlguns poligonos ja possuem essas coordenadas como centro!" << endl;

                    cout << "\n\t>>> COORDENADA DE SOBREPOSICAO <<<\n" << endl;
                    cout << "\nObs.: Essa coordenada refere-se ao poligono ja existente!" << endl;
                    cout << "\nDigte um valor inteiro correspondente a uma coordenada de sobreposicao: ";
                    z = LeUmInteiro();

                    for (unsigned int k = 0; k < c.getPoligonosDoCanvas().size(); k++){

                        while (z == zIndex[k]){
                            cout << "\nEssa coordenada ja foi ocupada!" << endl;
                            cout << "\nDigte um valor inteiro correspondente a uma coordenada de sobreposicao: ";
                            z = LeUmInteiro();
                        }//while
                    }//for

                    zIndex.push_back(z);

                    c.getPoligonosDoCanvas()[j]->setZIndex(zIndex[j]);
                    cout << "\nIndice inserido com sucesso!" << endl;
                }//if
                nVezes++;
            }//if
        }//for

   r[i]->setCoordenadasCentro(centro);

   cout << "\nDigite a cor do retangulo: ";
   cin  >> cor;

   r[i]->setCor(cor);

   cout << "\nDigite um valor inteiro correspondente a base do retangulo: ";
   b = LeUmInteiro();

   r[i]->setBase(b);

   cout << "\nDigite um valor inteiro correspondente a altura do retangulo: ";
   a = LeUmInteiro();

   r[i]->setAltura(a);

   c.setPoligonosDoCanvas(r[i]);

   cout << "\nRetangulo inserido com sucesso!" << endl << endl;

}

/********** FUNCAO InsereCirculo **********/

void InsereCirculo(Canvas& c, vector<Circulo*> &cir, int i, vector<int> &zIndex, int &nVezes)
{
   int r;
   int centro[2];
   string cor;

   static Circulo circul[NUMERO_MAXIMO];

   cir.push_back(&circul[i]);

   system("cls");

   cout << "\n\t>>> Circulo <<<\n";

   cout << "\nDigite um valor inteiro correspondente a coordenada x do centro: ";
   centro[0] = LeUmInteiro();

   cout << "\nDigite um valor inteiro correspondente a coordenada y do centro: ";
   centro[1] = LeUmInteiro();

   int* verificador = c.getTamanhoDoCanvas();

   while (centro[0] > verificador[1] || centro[1] > verificador[0]){

        system("cls");

        cout << "\n\aO limite da tela nao pode ser ultrapassado! Por favor, tente novamente!" << endl;

        cout << "\nDigite um valor inteiro correspondente a coordenada x do centro: ";
        centro[0] = LeUmInteiro();

        cout << "\nDigite um valor inteiro correspondente a coordenada y do centro: ";
        centro[1] = LeUmInteiro();
   }

   for (unsigned int j = 0; j < c.getPoligonosDoCanvas().size(); j++){

        if (c.getPoligonosDoCanvas()[j]->getCentroPoligono()[0] == centro[0] && c.getPoligonosDoCanvas()[j]->getCentroPoligono()[1] == centro[1]){

            int z;

            if (!nVezes){
                    cout << "\n\aAlgum poligono ja possui essas coordenadas como centro!" << endl;

                    cout << "\n\t>>> COORDENADA DE SOBREPOSICAO <<<\n" << endl;
                    cout << "\nObs.: Essa coordenada refere-se ao poligono ja existente!" << endl;
                    cout << "\nDigte um valor inteiro correspondente a uma coordenada de sobreposicao: ";
                    z = LeUmInteiro();

                    zIndex.push_back(z);

                    c.getPoligonosDoCanvas()[j]->setZIndex(zIndex[j]);
                    cout << "\nIndice inserido com sucesso!" << endl;

            }

            if (nVezes> 0 && j == c.getPoligonosDoCanvas().size() - 1){

                    cout << "\n\aAlguns poligonos ja possuem essas coordenadas como centro!" << endl;

                    cout << "\n\t>>> COORDENADA DE SOBREPOSICAO <<<\n" << endl;
                    cout << "\nObs.: Essa coordenada refere-se ao poligono ja existente!" << endl;
                    cout << "\nDigte um valor inteiro correspondente a uma coordenada de sobreposicao: ";
                    z = LeUmInteiro();

                    for (unsigned int k = 0; k < c.getPoligonosDoCanvas().size(); k++){

                        while (z == zIndex[k]){
                            cout << "\nEssa coordenada ja foi ocupada!" << endl;
                            cout << "\nDigte um valor inteiro correspondente a uma coordenada de sobreposicao: ";
                            z = LeUmInteiro();
                        }//while
                    }//for

                    zIndex.push_back(z);

                    c.getPoligonosDoCanvas()[j]->setZIndex(zIndex[j]);
                    cout << "\nIndice inserido com sucesso!" << endl;
                }//if
                nVezes++;
            }//if
        }//for

   cir[i]->setCoordenadasCentro(centro);

   cout << "\nDigite a cor do circulo: ";
   cin  >> cor;

   cir[i]->setCor(cor);

   cout << "\nDigite um valor inteiro correspondente ao raio do circulo: ";
   r = LeUmInteiro();

   cir[i]->setRaio(r);

   c.setPoligonosDoCanvas(cir[i]);

   cout << "\nCirculo inserido com sucesso!" << endl << endl;

}

/********** FUNCAO InserePentagono **********/

void InserePentagono(Canvas& c, vector<Pentagono*> &p, int i, vector<int> &zIndex, int nVezes)
{
   int l;
   int centro[2];
   string cor;

   static Pentagono pent[NUMERO_MAXIMO];

   p.push_back(&pent[i]);

   system("cls");

   cout << "\n\t>>> Pentagono Regular <<<\n";

   cout << "\nDigite um valor inteiro correspondente a coordenada x do centro: ";
   centro[0] = LeUmInteiro();

   cout << "\nDigite um valor inteiro correspondente a coordenada y do centro: ";
   centro[1] = LeUmInteiro();

   int* verificador = c.getTamanhoDoCanvas();

   while (centro[0] > verificador[1] || centro[1] > verificador[0]){

        system("cls");

        cout << "\n\aO limite da tela nao pode ser ultrapassado! Por favor, tente novamente!" << endl;

        cout << "\nDigite um valor inteiro correspondente a coordenada x do centro: ";
        centro[0] = LeUmInteiro();

        cout << "\nDigite um valor inteiro correspondente a coordenada y do centro: ";
        centro[1] = LeUmInteiro();
   }

   for (unsigned int j = 0; j < c.getPoligonosDoCanvas().size(); j++){

        if (c.getPoligonosDoCanvas()[j]->getCentroPoligono()[0] == centro[0] && c.getPoligonosDoCanvas()[j]->getCentroPoligono()[1] == centro[1]){

            int z;

            if (!nVezes){
                    cout << "\n\aAlgum poligono ja possui essas coordenadas como centro!" << endl;

                    cout << "\n\t>>> COORDENADA DE SOBREPOSICAO <<<\n" << endl;
                    cout << "\nObs.: Essa coordenada refere-se ao poligono ja existente!" << endl;
                    cout << "\nDigte um valor inteiro correspondente a uma coordenada de sobreposicao: ";
                    z = LeUmInteiro();

                    zIndex.push_back(z);

                    c.getPoligonosDoCanvas()[j]->setZIndex(zIndex[j]);
                    cout << "\nIndice inserido com sucesso!" << endl;

            }

            if (nVezes> 0 && j == c.getPoligonosDoCanvas().size() - 1){

                    cout << "\n\aAlguns poligonos ja possuem essas coordenadas como centro!" << endl;

                    cout << "\n\t>>> COORDENADA DE SOBREPOSICAO <<<\n" << endl;
                    cout << "\nObs.: Essa coordenada refere-se ao poligono ja existente!" << endl;
                    cout << "\nDigte um valor inteiro correspondente a uma coordenada de sobreposicao: ";
                    z = LeUmInteiro();

                    for (unsigned int k = 0; k < c.getPoligonosDoCanvas().size(); k++){

                        while (z == zIndex[k]){
                            cout << "\nEssa coordenada ja foi ocupada!" << endl;
                            cout << "\nDigte um valor inteiro correspondente a uma coordenada de sobreposicao: ";
                            z = LeUmInteiro();
                        }//while
                    }//for

                    zIndex.push_back(z);

                    c.getPoligonosDoCanvas()[j]->setZIndex(zIndex[j]);
                    cout << "\nIndice inserido com sucesso!" << endl;
                }//if
                nVezes++;
            }//if
        }//for

   p[i]->setCoordenadasCentro(centro);

   cout << "\nDigite a cor do pentagono regular: ";
   cin  >> cor;

   p[i]->setCor(cor);

   cout << "\nDigite um valor inteiro correspondente ao lado do pentagono regular: ";
   l = LeUmInteiro();

   p[i]->setLado(l);

   c.setPoligonosDoCanvas(p[i]);

   cout << "\nPentagono regular inserido com sucesso!" << endl << endl;

}

/********** FUNCAO InsereHexagono **********/

void InsereHexagono(Canvas& c, vector<Hexagono*> &h, int i, vector<int> &zIndex, int nVezes)
{
   int l;
   int centro[2];
   string cor;

   static Hexagono hex[NUMERO_MAXIMO];

   h.push_back(&hex[i]);

   system("cls");

   cout << "\n\t>>> Hexagono Regular <<<\n";

   cout << "\nDigite um valor inteiro correspondente a coordenada x do centro: ";
   centro[0] = LeUmInteiro();

   cout << "\nDigite um valor inteiro correspondente a coordenada y do centro: ";
   centro[1] = LeUmInteiro();

   int* verificador = c.getTamanhoDoCanvas();

   while (centro[0] > verificador[1] || centro[1] > verificador[0]){

        system("cls");

        cout << "\n\aO limite da tela nao pode ser ultrapassado! Por favor, tente novamente!" << endl;

        cout << "\nDigite um valor inteiro correspondente a coordenada x do centro: ";
        centro[0] = LeUmInteiro();

        cout << "\nDigite um valor inteiro correspondente a coordenada y do centro: ";
        centro[1] = LeUmInteiro();
   }

   for (unsigned int j = 0; j < c.getPoligonosDoCanvas().size(); j++){

        if (c.getPoligonosDoCanvas()[j]->getCentroPoligono()[0] == centro[0] && c.getPoligonosDoCanvas()[j]->getCentroPoligono()[1] == centro[1]){

            int z;

            if (!nVezes){
                    cout << "\n\aAlgum poligono ja possui essas coordenadas como centro!" << endl;

                    cout << "\n\t>>> COORDENADA DE SOBREPOSICAO <<<\n" << endl;
                    cout << "\nObs.: Essa coordenada refere-se ao poligono ja existente!" << endl;
                    cout << "\nDigte um valor inteiro correspondente a uma coordenada de sobreposicao: ";
                    z = LeUmInteiro();

                    zIndex.push_back(z);

                    c.getPoligonosDoCanvas()[j]->setZIndex(zIndex[j]);
                    cout << "\nIndice inserido com sucesso!" << endl;

            }

            if (nVezes> 0 && j == c.getPoligonosDoCanvas().size() - 1){

                    cout << "\n\aAlguns poligonos ja possuem essas coordenadas como centro!" << endl;

                    cout << "\n\t>>> COORDENADA DE SOBREPOSICAO <<<\n" << endl;
                    cout << "\nObs.: Essa coordenada refere-se ao poligono ja existente!" << endl;
                    cout << "\nDigte um valor inteiro correspondente a uma coordenada de sobreposicao: ";
                    z = LeUmInteiro();

                    for (unsigned int k = 0; k < c.getPoligonosDoCanvas().size(); k++){

                        while (z == zIndex[k]){
                            cout << "\nEssa coordenada ja foi ocupada!" << endl;
                            cout << "\nDigte um valor inteiro correspondente a uma coordenada de sobreposicao: ";
                            z = LeUmInteiro();
                        }//while
                    }//for

                    zIndex.push_back(z);

                    c.getPoligonosDoCanvas()[j]->setZIndex(zIndex[j]);
                    cout << "\nIndice inserido com sucesso!" << endl;
                }//if
                nVezes++;
            }//if
        }//for

   h[i]->setCoordenadasCentro(centro);

   cout << "\nDigite a cor do hexagono regular: ";
   cin  >> cor;

   h[i]->setCor(cor);

   cout << "\nDigite um valor inteiro correspondente ao lado do hexagono regular: ";
   l = LeUmInteiro();

   h[i]->setLado(l);

   c.setPoligonosDoCanvas(h[i]);

   cout << "\nHexagono regular inserido com sucesso!" << endl << endl;

}

/********** FUNCAO EliminaPoligono **********/

void EliminaPoligono(Canvas& c, int i)
{
    vector<Poligono*>::iterator it;

    it = c.getPoligonosDoCanvas().begin();

    c.getPoligonosDoCanvas().erase(it + i);

    cout << "\nPoligono excluido com sucesso!" << endl;
}

/********** FUNCAO GeraArquivoDeTexto **********/

int GeraArquivoDeTexto(Poligono *p, int nVezes)
{
    if (nVezes > 0){
        return 1;
    }

    char strTipo[NUMERO_MAXIMO];
    char strCor[NUMERO_MAXIMO];
    char strCentro[NUMERO_MAXIMO];
    char strArea[NUMERO_MAXIMO];
    char strPerimetro[NUMERO_MAXIMO];

    strcpy(strTipo, "Tipo: ");
    strcpy(strCor, "Cor: ");
    strcpy(strCentro, "Centro:(");
    strcpy(strArea, "Area: ");
    strcpy(strPerimetro, "Perimetro: ");

    char centroX[TAM], centroY[TAM];
    char area[TAM], perimetro[TAM];

    FILE *file;
    file = fopen("ListaDePoligonos.txt", "a+");

    fprintf(file, "\n\n");

    fprintf(file, strcat(strTipo, p->getTipo().c_str()));
    fprintf(file, "\n");

    sprintf(centroX, "%d", p->getCentroPoligono()[0]); //convertendo inteiro em string
    sprintf(centroY, "%d", p->getCentroPoligono()[1]); //convertendo inteiro em string

    strcat(strCentro, centroX);
    strcat(strCentro, ", ");
    strcat(strCentro, centroY);
    strcat(strCentro, ")");

    fprintf(file, strCentro);
    fprintf(file, "\n");
    fprintf(file, strcat(strCor, p->getCorPoligono().c_str()));
    fprintf(file, "\n");

    sprintf(area, "%d", p->Area());
    strcat(strArea, area);

    fprintf(file, strArea);
    fprintf(file, "\n");

    sprintf(perimetro, "%d", p->Perimetro());
    strcat(strPerimetro, perimetro);

    fprintf(file, strPerimetro);
    fprintf(file, "\n");

    fclose(file);

    return 0;
}

/********** FUNCAO LimpaBuffer **********/

void LimpaBuffer(void)
{
    int c;

    do{
        c = getchar();
    }while(c != '\n' && c != EOF);
}

/********** FUNCAO LeUmInteiro **********/

int LeUmInteiro(void)
{
    int num, nValoresLidos;

    inicio:
        nValoresLidos = scanf("%d", &num);

    while (!nValoresLidos){

            LimpaBuffer();

            printf ("\n\aO valor digitado nao eh um inteiro! Tente Novamente!\n");
            printf ("\nDigite um valor inteiro: ");
            goto inicio;
    }

    LimpaBuffer();

    return num;
}

/********** FUNCAO main **********/

int main (void)
{
  int comprimento, largura, opcao;

  static int indiceRetangulo = 0;
  static int indiceCirculo = 0;
  static int indicePentagono = 0;
  static int indiceHexagono = 0;
  static int nExecucoes = 0;
  static int nVezes = 0;

  vector <Retangulo*> retangulos;
  vector <Circulo*> circulos;
  vector <Pentagono*> pentagonos;
  vector <Hexagono*> hexagonos;
  vector <int> zIndices;

  cout << "\n\t>>>>> Editor grafico de poligonos <<<<<\n" << endl;

  cout << "\n\t>>> Tela de Desenho <<<\n" << endl;

  cout << "\nDigite um valor correspondente ao comprimento da tela(Max: 6 digitos): ";
  comprimento = LeUmInteiro();

  while (comprimento > REFERENCIA || !comprimento){

        cout << "\n\aOpcao Invalida! Tente Novamente!" << endl;
        cout << "\nDigite um valor correspondente ao comprimento da tela (Max: 6 digitos): ";
        comprimento = LeUmInteiro();
  }

  cout << "\nDigite um valor correspondente a largura da tela (Max: 6 digitos): ";
  largura = LeUmInteiro();

  while (largura > REFERENCIA || !largura){

        cout << "\n\aOpcao Invalida! Tente Novamente!" << endl;
        cout << "\nDigite um valor correspondente a largura da tela(Max: 6 digitos): ";
        largura = LeUmInteiro();
  }

 Canvas tela(comprimento, largura);

 while (1){

      ExibeMenu();

      inicio:
         cout << "\nDigite o numero correspondente a operacao que voce deseja: ";
         opcao = LeUmInteiro();

         if (opcao == 9){
               system("cls");
               cout << "\nPrograma Encerrado!" << endl;
               break;
         }

         switch (opcao){

         case 1:
            ExibeInformacoesDoCanvas(tela);
            break;

         case 2:
            InsereRetangulo(tela, retangulos, indiceRetangulo, zIndices, nVezes);
            indiceRetangulo++;

            if(nExecucoes > 0){
                nExecucoes--;
            }

            if (!nExecucoes){
                remove("ListaDePoligonos.txt");
            }

            break;

         case 3:
           InsereCirculo(tela, circulos, indiceCirculo, zIndices, nVezes);
           indiceCirculo++;

           if(nExecucoes > 0){
                nExecucoes--;
           }

           if (!nExecucoes){
                remove("ListaDePoligonos.txt");
           }

           break;

         case 4:
           InserePentagono(tela, pentagonos, indicePentagono, zIndices, nVezes);
           indicePentagono++;

           if(nExecucoes > 0){
                nExecucoes--;
           }

           if (!nExecucoes){
                remove("ListaDePoligonos.txt");
           }

           break;

         case 5:
           InsereHexagono(tela, hexagonos, indiceHexagono, zIndices, nVezes);
           indiceHexagono++;

           if(nExecucoes > 0){
                nExecucoes--;
           }

           if (!nExecucoes){
                remove("ListaDePoligonos.txt");
           }

           break;

         case 6:
            tela.ExibePoligonosDoCanvas();
            break;

         case 7:
             unsigned int indice;

             system("cls");

             if (tela.getPoligonosDoCanvas().size() == 0){
                    cout << "\n\aNao ha nada para eliminar!" << endl;
                    break;
             }

             cout << "\nDigite um valor inteiro equivalente ao indice do poligono que sera excluido: ";
             indice = LeUmInteiro();

             while (indice > tela.getPoligonosDoCanvas().size() || !indice){
                    cout << "\n\aErro! Nao se pode acessar um elemento alem do tamanhdo do conjunto" << endl;
                    cout << "\nDigite um valor inteiro equivalente ao indice do poligono que sera excluido: ";
                    indice = LeUmInteiro();
             }

             if (tela.getPoligonosDoCanvas()[indice-1]->getTipo() == "Retangulo"){
                    indiceRetangulo--;
             }

             if (tela.getPoligonosDoCanvas()[indice-1]->getTipo() == "Circulo"){
                    indiceCirculo--;
             }

             if (tela.getPoligonosDoCanvas()[indice-1]->getTipo() == "Pentagono regular"){
                    indicePentagono--;
             }

             if (tela.getPoligonosDoCanvas()[indice-1]->getTipo() == "Hexagono regular"){
                    indiceHexagono--;
             }

             EliminaPoligono(tela, indice - 1);

             if(nExecucoes > 0){
                    nExecucoes--;
             }

             if (!nExecucoes){
                    remove("ListaDePoligonos.txt");
             }

             break;

         case 8:

             int verificador;

             if (!tela.getPoligonosDoCanvas().size()){
                    system("cls");
                    cout << "\n\aO arquivo nao foi gerado, por falta de informacoes!" << endl;
                    break;
             }

             for (unsigned int i = 0; i < tela.getPoligonosDoCanvas().size(); i++){
                verificador = GeraArquivoDeTexto(tela.getPoligonosDoCanvas()[i], nExecucoes);
             }

             system("cls");

             if (verificador == 1){
                    cout << "\nO arquivo ja foi gerado!" << endl;
                    break;
             }

             if (!verificador){
                    cout << "\nArquivo gerado com sucesso!" << endl;
                    nExecucoes++;
                    break;
             }

             break;

         default:
            cout << "\nOpcao Invalida! Tente Novamente!" << endl;
            ExibeMenu();
            goto inicio;
            break;
         }//switch
  }//while

  return 0;
}
