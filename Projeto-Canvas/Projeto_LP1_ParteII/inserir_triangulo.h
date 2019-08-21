#ifndef INSERIR_TRIANGULO_H
#define INSERIR_TRIANGULO_H

#include <QDialog>

namespace Ui {
class InserirTriangulo;
}

class InserirTriangulo : public QDialog
{
    Q_OBJECT

public:
    explicit InserirTriangulo(QWidget *parent = 0);
    ~InserirTriangulo();

private slots:

    void on_Ok_clicked();

    void on_Cancel_clicked();

    void on_spinBox_x_valueChanged(const QString &arg1);

private:
    Ui::InserirTriangulo *ui;
};

#endif // INSERIR_TRIANGULO_H
