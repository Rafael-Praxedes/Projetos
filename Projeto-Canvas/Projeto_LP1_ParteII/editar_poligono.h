#ifndef EDITAR_POLIGONO_H
#define EDITAR_POLIGONO_H

#include <QDialog>

namespace Ui {
class EditarPoligono;
}

class EditarPoligono : public QDialog
{
    Q_OBJECT

public:
    explicit EditarPoligono(QWidget *parent = 0);
    ~EditarPoligono();

private slots:
    void on_Ok_clicked();

    void on_Cancel_clicked();

private:
    Ui::EditarPoligono *ui;
};

#endif // EDITAR_POLIGONO_H
