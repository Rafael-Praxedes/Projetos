#include "inserir_triangulo.h"
#include "ui_inserir_triangulo.h"
#include "poligonos.h"
#include "vector_telas.h"

InserirTriangulo::InserirTriangulo(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::InserirTriangulo)
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

InserirTriangulo::~InserirTriangulo()
{
    delete ui;
}

void InserirTriangulo::on_Ok_clicked()
{
    Triangulo *trian = new Triangulo;

    this->close();

    if (apagador){

        delete poligonosDoCanvas[indice_global];
        poligonosDoCanvas.erase(poligonosDoCanvas.begin() + indice_global);

        apagador = false;
    }

    trian->setCoordenadasCentro(ui->spinBox_x->value(), ui->spinBox_y->value());
    trian->setLado(ui->spinBox_lado->value());
    trian->setCor(ui->comboBox_cor->currentText());

    if (indice_global == -1){

        poligonosDoCanvas.push_back(trian);
    }

    else{

        poligonosDoCanvas.insert(poligonosDoCanvas.begin() + indice_global, trian);
        indice_global = -1;
    }

    insere_triangulo = true;
}

void InserirTriangulo::on_Cancel_clicked()
{
    this->close();
}

void InserirTriangulo::on_spinBox_x_valueChanged(const QString &arg1)
{
    //lado
    ui->spinBox_lado->setMaximum(largura_canvas - ui->spinBox_x->value());
    ui->spinBox_lado->setMinimum(20);
}
