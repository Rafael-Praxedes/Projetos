#include "inserir_circulo.h"
#include "ui_inserir_circulo.h"
#include "poligonos.h"
#include "vector_telas.h"

InserirCirculo::InserirCirculo(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::InserirCirculo)
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

InserirCirculo::~InserirCirculo()
{
    delete ui;
}

void InserirCirculo::on_Ok_clicked()
{
    Circulo *cir = new Circulo;

    this->close();

    if (apagador){

        delete poligonosDoCanvas[indice_global];
        poligonosDoCanvas.erase(poligonosDoCanvas.begin() + indice_global);

        apagador = false;
    }

    cir->setCoordenadasCentro(ui->spinBox_x->value(), ui->spinBox_y->value());
    cir->setRaio(ui->spinBox_raio->value());
    cir->setCor(ui->comboBox_cor->currentText());

    if (indice_global == -1){

        poligonosDoCanvas.push_back(cir);
    }

    else{

        poligonosDoCanvas.insert(poligonosDoCanvas.begin() + indice_global, cir);
        indice_global = -1;
    }

    insere_circulo = true;
}

void InserirCirculo::on_Cancel_clicked()
{
    this->close();
}

void InserirCirculo::on_spinBox_x_valueChanged(const QString &arg1)
{
    //raio
    if (largura_canvas - ui->spinBox_x->value() <= altura_canvas - ui->spinBox_y->value()){

        ui->spinBox_raio->setMaximum((largura_canvas - ui->spinBox_x->value())/2);

    }
}

void InserirCirculo::on_spinBox_y_valueChanged(const QString &arg1)
{
    //raio
    if (altura_canvas - ui->spinBox_y->value() <= largura_canvas - ui->spinBox_x->value()){

        ui->spinBox_raio->setMaximum((altura_canvas - ui->spinBox_x->value())/2);

    }
}
