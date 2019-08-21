#ifndef INSERIR_RETANGULO_H
#define INSERIR_RETANGULO_H

#include <QDialog>

namespace Ui {
class InserirRetangulo;
}

class InserirRetangulo : public QDialog
{
    Q_OBJECT

public:
    explicit InserirRetangulo(QWidget *parent = 0);
    ~InserirRetangulo();

private slots:

    void on_Ok_clicked();

    void on_Cancel_clicked();

    void on_spinBox_x_valueChanged(const QString &arg1);

    void on_spinBox_y_valueChanged(const QString &arg1);

private:
    Ui::InserirRetangulo *ui;
};

#endif // INSERIR_RETANGULO_H
