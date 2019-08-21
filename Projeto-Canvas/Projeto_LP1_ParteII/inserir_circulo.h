#ifndef INSERIR_CIRCULO_H
#define INSERIR_CIRCULO_H

#include <QDialog>

namespace Ui {
class InserirCirculo;
}

class InserirCirculo : public QDialog
{
    Q_OBJECT

public:
    explicit InserirCirculo(QWidget *parent = 0);
    ~InserirCirculo();

private slots:
    void on_Ok_clicked();

    void on_Cancel_clicked();

    void on_spinBox_x_valueChanged(const QString &arg1);

    void on_spinBox_y_valueChanged(const QString &arg1);

private:
    Ui::InserirCirculo *ui;
};

#endif // INSERIR_CIRCULO_H
