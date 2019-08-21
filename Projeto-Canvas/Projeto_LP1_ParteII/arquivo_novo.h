#ifndef ARQUIVO_NOVO_H
#define ARQUIVO_NOVO_H

#include <QDialog>

namespace Ui {
class ArquivoNovo;
}

class ArquivoNovo : public QDialog
{
    Q_OBJECT

public:
    explicit ArquivoNovo(QWidget *parent = 0);
    ~ArquivoNovo();

private slots:

    void on_ok_clicked();

    void on_Cancel_clicked();

private:
    Ui::ArquivoNovo *ui;
};

#endif // ARQUIVO_NOVO_H
