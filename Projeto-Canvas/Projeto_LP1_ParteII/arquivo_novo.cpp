#include "arquivo_novo.h"
#include "ui_arquivo_novo.h"
#include "vector_telas.h"

ArquivoNovo::ArquivoNovo(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::ArquivoNovo)
{
    ui->setupUi(this);
}

ArquivoNovo::~ArquivoNovo()
{
    delete ui;
}

void ArquivoNovo::on_ok_clicked()
{
    this->close();

    altura_canvas  = ui->spinBox_altura->value();
    largura_canvas = ui->spinBox_largura->value();

    criador = true;

}

void ArquivoNovo::on_Cancel_clicked()
{
    this->close();

}
