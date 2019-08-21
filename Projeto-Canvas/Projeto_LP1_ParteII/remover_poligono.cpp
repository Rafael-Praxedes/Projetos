#include "remover_poligono.h"
#include "ui_remover_poligono.h"
#include "vector_telas.h"
#include <sstream>
#include <iostream>

using namespace std;

RemoverPoligono::RemoverPoligono(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::RemoverPoligono)
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

RemoverPoligono::~RemoverPoligono()
{
    delete ui;
}

void RemoverPoligono::on_Ok_clicked()
{
    this->close();

    int indice;

    indice = ui->comboBox_poligono->currentIndex();

    delete poligonosDoCanvas[indice];

    poligonosDoCanvas.erase(poligonosDoCanvas.begin() + indice);

    remover_poligono = true;
}

void RemoverPoligono::on_Cancel_clicked()
{
    this->close();
}
