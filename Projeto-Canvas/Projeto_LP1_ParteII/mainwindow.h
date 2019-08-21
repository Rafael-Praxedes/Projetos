#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

protected:
    void paintEvent(QPaintEvent *e);
    void abrePoligonos(QString tipo = "", int x = 0, int y = 0, int base = 0, int altura = 0, QString cor = "");

private slots:
    void on_actionNovo_triggered();

    void on_actionAbrir_triggered();

    void on_actionSalvar_triggered();

    void on_actionInserir_Retangulo_triggered();

    void on_actionInserir_Circulo_triggered();

    void on_actionInserir_Triangulo_triggered();

    void on_actionInserir_Hexagono_triggered();

    void on_actionLimpar_Tela_de_Desenho_triggered();

    void on_actionRemover_Poligono_triggered();

    void on_actionEditar_Poligono_triggered();

private:
    Ui::MainWindow *ui;
};

#endif // MAINWINDOW_H
