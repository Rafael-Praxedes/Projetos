#include "limpar_canvas.h"
#include "ui_limpar_canvas.h"
#include "vector_telas.h"

LimparCanvas::LimparCanvas(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::LimparCanvas)
{
    ui->setupUi(this);
}

LimparCanvas::~LimparCanvas()
{
    delete ui;
}

void LimparCanvas::on_Sim_clicked()
{
    this->close();

    for (int i = 0; i < poligonosDoCanvas.size(); i++){
        delete poligonosDoCanvas[i];
    }

    poligonosDoCanvas.clear();

    limpar_canvas = true;
}

void LimparCanvas::on_Nao_clicked()
{
    this->close();
}
