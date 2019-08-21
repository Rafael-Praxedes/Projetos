#include "inserir_hexagono.h"
#include "ui_inserir_hexagono.h"
#include "poligonos.h"
#include "vector_telas.h"
#include "math.h"

InserirHexagono::InserirHexagono(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::InserirHexagono)
{
    ui->setupUi(this);

    //x
    ui->spinBox_x->setMaximum((largura_canvas - 35) - 10);
    ui->spinBox_x->setMinimum(35 + 10);

    //y
    ui->spinBox_y->setMaximum((altura_canvas - 50) - 10);
    ui->spinBox_y->setMinimum(50 + 10);

    //cor

    ui->comboBox_cor->addItem("vermelho");
    ui->comboBox_cor->addItem("azul");
    ui->comboBox_cor->addItem("amarelo");
    ui->comboBox_cor->addItem("verde");
    ui->comboBox_cor->addItem("preto");

}

InserirHexagono::~InserirHexagono()
{
    delete ui;
}

void InserirHexagono::on_Ok_clicked()
{
    Hexagono *hex = new Hexagono;

    this->close();

    if (apagador){

        delete poligonosDoCanvas[indice_global];
        poligonosDoCanvas.erase(poligonosDoCanvas.begin() + indice_global);

        apagador = false;
    }

    hex->setCoordenadasCentro(ui->spinBox_x->value(), ui->spinBox_y->value());
    hex->setLado(ui->spinBox_lado->value());
    hex->setCor(ui->comboBox_cor->currentText());

    if (indice_global == -1){

        poligonosDoCanvas.push_back(hex);
    }

    else{

        poligonosDoCanvas.insert(poligonosDoCanvas.begin() + indice_global, hex);
        indice_global = -1;
    }

    insere_hexagono = true;
}

void InserirHexagono::on_Cancel_clicked()
{
    this->close();
}

void InserirHexagono::on_spinBox_x_valueChanged(const QString &arg1)
{
    if ((largura_canvas - ui->spinBox_x->value()) < altura_canvas - ui->spinBox_y->value()){

        ui->spinBox_lado->setMaximum(2*largura_canvas - ui->spinBox_x->value());
        ui->spinBox_lado->setMinimum(ui->spinBox_x->minimum());
    }
}

void InserirHexagono::on_spinBox_y_valueChanged(const QString &arg1)
{
    if ((largura_canvas - ui->spinBox_x->value()) >= altura_canvas - ui->spinBox_y->value()){

        ui->spinBox_lado->setMaximum((2*sqrt(3)*(altura_canvas - ui->spinBox_y->value()))/3);
        ui->spinBox_lado->setMinimum(ui->spinBox_y->minimum() <= ui->spinBox_x->minimum() ? (ui->spinBox_y->minimum() - 10) : (ui->spinBox_x->minimum() - 10));
    }

}
