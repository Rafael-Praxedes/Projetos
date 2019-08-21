#ifndef INSERIR_HEXAGONO_H
#define INSERIR_HEXAGONO_H

#include <QDialog>

namespace Ui {
class InserirHexagono;
}

class InserirHexagono : public QDialog
{
    Q_OBJECT

public:
    explicit InserirHexagono(QWidget *parent = 0);
    ~InserirHexagono();

private slots:
    void on_Ok_clicked();

    void on_Cancel_clicked();

    void on_spinBox_x_valueChanged(const QString &arg1);

    void on_spinBox_y_valueChanged(const QString &arg1);

private:
    Ui::InserirHexagono *ui;
};

#endif // INSERIR_HEXAGONO_H
