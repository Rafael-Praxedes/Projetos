#include "inserir_retangulo.h"
#include "ui_inserir_retangulo.h"
#include "vector_telas.h"
#include "poligonos.h"

InserirRetangulo::InserirRetangulo(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::InserirRetangulo)
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

InserirRetangulo::~InserirRetangulo()
{
    delete ui;
}

void InserirRetangulo::on_Ok_clicked()
{
    Retangulo *ret = new Retangulo;

    this->close();

    if (apagador){

        delete poligonosDoCanvas[indice_global];
        poligonosDoCanvas.erase(poligonosDoCanvas.begin() + indice_global);

        apagador = false;
    }

    ret->setCoordenadasCentro(ui->spinBox_x->value(), ui->spinBox_y->value());
    ret->setBase(ui->spinBox_base->value());
    ret->setAltura(ui->spinBox_altura->value());
    ret->setCor(ui->comboBox_cor->currentText());

    if (indice_global == -1){

        poligonosDoCanvas.push_back(ret);
    }

    else{

        poligonosDoCanvas.insert(poligonosDoCanvas.begin() + indice_global, ret);
        indice_global = -1;
    }

    insere_retangulo = true;
}

void InserirRetangulo::on_Cancel_clicked()
{
    this->close();
}

void InserirRetangulo::on_spinBox_x_valueChanged(const QString &arg1)
{
    //base
    ui->spinBox_base->setMaximum(largura_canvas - ui->spinBox_x->value());
}

void InserirRetangulo::on_spinBox_y_valueChanged(const QString &arg1)
{
    //altura
    ui->spinBox_altura->setMaximum(altura_canvas - ui->spinBox_y->value());
}
