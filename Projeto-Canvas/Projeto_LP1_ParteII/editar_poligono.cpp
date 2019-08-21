#include "editar_poligono.h"
#include "ui_editar_poligono.h"
#include "vector_telas.h"
#include <sstream>
#include <iostream>

using namespace std;

EditarPoligono::EditarPoligono(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::EditarPoligono)
{
    ui->setupUi(this);

    for(int i = 0; i < poligonosDoCanvas.size(); i++){

        stringstream buffer;

        buffer << "[" << i + 1 << "]" << "- " << (((poligonosDoCanvas[i])->getTipo()).toStdString());
        QString texto = QString::fromStdString(buffer.str());

        ui->comboBox_poligono->addItem(texto);
    }

    QDialog::update();
}

EditarPoligono::~EditarPoligono()
{
    delete ui;
}

void EditarPoligono::on_Ok_clicked()
{
    this->close();

    int indice;

    indice = ui->comboBox_poligono->currentIndex();

    indice_global = indice;

    QString tipo = poligonosDoCanvas[indice]->getTipo();

    //delete poligonosDoCanvas[indice];

    //poligonosDoCanvas.erase(poligonosDoCanvas.begin() + indice);

    if (tipo == "Retangulo"){
        edita_retangulo = true;
    }

    if (tipo == "Circulo"){
        edita_circulo = true;
    }

    if (tipo == "Triangulo"){
        edita_triangulo = true;
    }

    if (tipo == "Hexagono"){
        edita_hexagono = true;
    }

    apagador = true;
}

void EditarPoligono::on_Cancel_clicked()
{
    this->close();
}
