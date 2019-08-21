#ifndef REMOVER_POLIGONO_H
#define REMOVER_POLIGONO_H

#include <QDialog>

namespace Ui {
class RemoverPoligono;
}

class RemoverPoligono : public QDialog
{
    Q_OBJECT

public:
    explicit RemoverPoligono(QWidget *parent = 0);
    ~RemoverPoligono();

private slots:
    void on_Ok_clicked();

    void on_Cancel_clicked();

private:
    Ui::RemoverPoligono *ui;
};

#endif // REMOVER_POLIGONO_H
