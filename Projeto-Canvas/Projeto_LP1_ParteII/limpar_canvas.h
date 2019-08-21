#ifndef LIMPAR_CANVAS_H
#define LIMPAR_CANVAS_H

#include <QDialog>

namespace Ui {
class LimparCanvas;
}

class LimparCanvas : public QDialog
{
    Q_OBJECT

public:
    explicit LimparCanvas(QWidget *parent = 0);
    ~LimparCanvas();

private slots:
    void on_Sim_clicked();

    void on_Nao_clicked();

private:
    Ui::LimparCanvas *ui;
};

#endif // LIMPAR_CANVAS_H
