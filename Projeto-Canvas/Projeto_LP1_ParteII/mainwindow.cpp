#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "arquivo_novo.h"
#include "inserir_retangulo.h"
#include "inserir_circulo.h"
#include "inserir_triangulo.h"
#include "inserir_hexagono.h"
#include "limpar_canvas.h"
#include "vector_telas.h"
#include "math.h"
#include "remover_poligono.h"
#include "editar_poligono.h"

#include <QPainter>
#include <QBrush>
#include <QRect>
#include <QtCore>
#include <QtXml/QDomDocument>
#include <QtXml/QDomElement>
#include <QFile>
#include <QTextStream>
#include <QFileDialog>
#include <QMessageBox>
#include <QDebug>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);

}

MainWindow::~MainWindow()
{
    delete ui;
}


void MainWindow::on_actionNovo_triggered()
{
    ArquivoNovo novoArquivo;

    novoArquivo.setModal(true);
    novoArquivo.exec();

}

void MainWindow::on_actionAbrir_triggered()
{
        if (!poligonosDoCanvas.empty()){

            for (int i = 0; i < poligonosDoCanvas.size(); i++){
                delete poligonosDoCanvas[i];

            }//for

            poligonosDoCanvas.clear();

            limpar_canvas = true;

            deletor = true;
        }//if

        auto filename = QFileDialog::getOpenFileName(this, "Abrir", QDir::rootPath(), "Arquivo XML (*.xml)");

        if (filename.isEmpty()){
            return;
        }

        QFile file(filename);

        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){
            QMessageBox::critical(this, "Erro", file.errorString());
            return;
        }

        QDomDocument doc;

        doc.setContent(&file);

        file.close();

        auto root = doc.firstChild().toElement();
        auto ix = root.firstChild().toElement();

        while (!ix.isNull()){

            if(ix.tagName() == "Canvas"){

                auto altura_string = ix.attribute("Altura");
                auto largura_string = ix.attribute("Largura");

                bool ok = true;

                altura_canvas = altura_string.toInt(&ok, 10);
                largura_canvas = largura_string.toInt(&ok, 10);

                criador = true;
            }

            if (ix.tagName() == "Retangulo"){

                auto base_string = ix.attribute("Base");
                auto altura_string = ix.attribute("Altura");

                auto x_string = ix.attribute("Coordenada_x");
                auto y_string = ix.attribute("Coordenada_y");

                auto cor = ix.attribute("Cor");

                bool ok = true;

                int x = x_string.toInt(&ok, 10);
                int y = y_string.toInt(&ok, 10);
                int base = base_string.toInt(&ok, 10);
                int altura = altura_string.toInt(&ok, 10);

                abrePoligonos("Retangulo", x, y, base, altura, cor);
                insere_retangulo = true;

            }//if

            if (ix.tagName() == "Circulo"){

                auto raio_string = ix.attribute("Raio");

                auto x_string = ix.attribute("Coordenada_x");
                auto y_string = ix.attribute("Coordenada_y");

                auto cor = ix.attribute("Cor");

                bool ok = true;

                int x = x_string.toInt(&ok, 10);
                int y = y_string.toInt(&ok, 10);
                int raio = raio_string.toInt(&ok, 10);

                abrePoligonos("Circulo", x, y, raio, raio, cor);
                insere_circulo = true;

            }//if

            if (ix.tagName() == "Triangulo"){

                auto lado_string = ix.attribute("Lado");

                auto x_string = ix.attribute("Coordenada_x");
                auto y_string = ix.attribute("Coordenada_y");

                auto cor = ix.attribute("Cor");

                bool ok = true;

                int x = x_string.toInt(&ok, 10);
                int y = y_string.toInt(&ok, 10);
                int lado = lado_string.toInt(&ok, 10);

                abrePoligonos("Triangulo", x, y, lado, lado, cor);
                insere_triangulo = true;

            }//if

            if (ix.tagName() == "Hexagono"){

                auto lado_string = ix.attribute("Lado");

                auto x_string = ix.attribute("Coordenada_x");
                auto y_string = ix.attribute("Coordenada_y");

                auto cor = ix.attribute("Cor");

                bool ok = true;

                int x = x_string.toInt(&ok, 10);
                int y = y_string.toInt(&ok, 10);
                int lado = lado_string.toInt(&ok, 10);

                abrePoligonos("Hexagono", x, y, lado, lado, cor);
                insere_hexagono = true;

            }//if

            ix = ix.nextSibling().toElement();

        }//while
}

void MainWindow::abrePoligonos(QString tipo, int x, int y, int base, int altura, QString cor)
{
    if (tipo == "Retangulo"){

        Retangulo *ret = new Retangulo;

        ret->setCoordenadasCentro(x,y);
        ret->setBase(base);
        ret->setAltura(altura);
        ret->setCor(cor);

        poligonosDoCanvas.push_back(ret);

    }//if

    if (tipo == "Circulo"){

        Circulo *cir = new Circulo;

        cir->setCoordenadasCentro(x,y);
        cir->setRaio(base);
        cir->setCor(cor);

        poligonosDoCanvas.push_back(cir);

    }//if

    if (tipo == "Triangulo"){

        Triangulo *tri = new Triangulo;

        tri->setCoordenadasCentro(x,y);
        tri->setLado(base);
        tri->setCor(cor);

        poligonosDoCanvas.push_back(tri);

    }//if

    if (tipo == "Hexagono"){

        Hexagono *hex = new Hexagono;

        hex->setCoordenadasCentro(x,y);
        hex->setLado(base);
        hex->setCor(cor);

        poligonosDoCanvas.push_back(hex);

    }//if
}

void MainWindow::on_actionSalvar_triggered()
{
    if (criador){

        auto filename = QFileDialog::getSaveFileName(this, "Salvar", QDir::rootPath(),"Arquivo XML (*.xml)");

        if(filename.isEmpty()){

            return;
        }

        QDomDocument doc;

        auto root = doc.createElement("Poligonos");

        doc.appendChild(root);

        auto eCanvas = doc.createElement("Canvas");

        eCanvas.setAttribute("Altura", QString::number(altura_canvas));
        eCanvas.setAttribute("Largura", QString::number(largura_canvas));

        root.appendChild(eCanvas);

        for (int i = 0; i < poligonosDoCanvas.size(); i++){

            QString tipo = poligonosDoCanvas[i]->getTipo();

            if (tipo == "Retangulo"){

                Retangulo *retangulo = new Retangulo;

                retangulo->setCoordenadasCentro(poligonosDoCanvas[i]->getCentroPoligono_x(),
                                                poligonosDoCanvas[i]->getCentroPoligono_y());

                retangulo->setBase(poligonosDoCanvas[i]->getBase());
                retangulo->setAltura(poligonosDoCanvas[i]->getAltura());
                retangulo->setCor(poligonosDoCanvas[i]->getCorPoligono());

                auto eRetangulo = doc.createElement("Retangulo");

                eRetangulo.setAttribute("Coordenada_x", QString::number(retangulo->getCentroPoligono_x()));
                eRetangulo.setAttribute("Coordenada_y", QString::number(retangulo->getCentroPoligono_y()));
                eRetangulo.setAttribute("Base", QString::number(retangulo->getBase()));
                eRetangulo.setAttribute("Altura", QString::number(retangulo->getAltura()));
                eRetangulo.setAttribute("Cor", retangulo->getCorPoligono());

                root.appendChild(eRetangulo);

            }//if

            if (tipo == "Circulo"){

                Circulo *circulo = new Circulo;

                circulo->setCoordenadasCentro(poligonosDoCanvas[i]->getCentroPoligono_x(),
                                                poligonosDoCanvas[i]->getCentroPoligono_y());

                circulo->setRaio(poligonosDoCanvas[i]->getBase());
                circulo->setCor(poligonosDoCanvas[i]->getCorPoligono());

                auto eCirculo = doc.createElement("Circulo");

                eCirculo.setAttribute("Coordenada_x", QString::number(circulo->getCentroPoligono_x()));
                eCirculo.setAttribute("Coordenada_y", QString::number(circulo->getCentroPoligono_y()));
                eCirculo.setAttribute("Raio", QString::number(circulo->getBase()));
                eCirculo.setAttribute("Cor", circulo->getCorPoligono());

                root.appendChild(eCirculo);

            }//if

            if (tipo == "Triangulo"){

                Triangulo *triangulo = new Triangulo;

                triangulo->setCoordenadasCentro(poligonosDoCanvas[i]->getCentroPoligono_x(),
                                                poligonosDoCanvas[i]->getCentroPoligono_y());

                triangulo->setLado(poligonosDoCanvas[i]->getBase());
                triangulo->setCor(poligonosDoCanvas[i]->getCorPoligono());

                auto eTriangulo = doc.createElement("Triangulo");

                eTriangulo.setAttribute("Coordenada_x", QString::number(triangulo->getCentroPoligono_x()));
                eTriangulo.setAttribute("Coordenada_y", QString::number(triangulo->getCentroPoligono_y()));
                eTriangulo.setAttribute("Lado", QString::number(triangulo->getBase()));
                eTriangulo.setAttribute("Cor", triangulo->getCorPoligono());

                root.appendChild(eTriangulo);

            }//if

            if (tipo == "Hexagono"){

                Hexagono *hexagono = new Hexagono;

                hexagono->setCoordenadasCentro(poligonosDoCanvas[i]->getCentroPoligono_x(),
                                                poligonosDoCanvas[i]->getCentroPoligono_y());

                hexagono->setLado(poligonosDoCanvas[i]->getBase());
                hexagono->setCor(poligonosDoCanvas[i]->getCorPoligono());

                auto eHexagono = doc.createElement("Hexagono");

                eHexagono.setAttribute("Coordenada_x", QString::number(hexagono->getCentroPoligono_x()));
                eHexagono.setAttribute("Coordenada_y", QString::number(hexagono->getCentroPoligono_y()));
                eHexagono.setAttribute("Lado", QString::number(hexagono->getBase()));
                eHexagono.setAttribute("Cor", hexagono->getCorPoligono());

                root.appendChild(eHexagono);

            }//if

        }//for

        QFile file(filename);

        if (!file.open(QIODevice::WriteOnly | QIODevice::Text)){
            QMessageBox::critical(this, "Erro", file.errorString());
            return;
        }

        QTextStream xout(&file);

        xout << doc.toString();

        file.flush();

        file.close();

    }//if_criador
}

void MainWindow::on_actionInserir_Retangulo_triggered()
{
    if (criador){

        InserirRetangulo janelaRetangulo;

        janelaRetangulo.setModal(true);
        janelaRetangulo.exec();
    }
}

void MainWindow::on_actionInserir_Circulo_triggered()
{
    if (criador){

        InserirCirculo janelaCirculo;

        janelaCirculo.setModal(true);
        janelaCirculo.exec();
    }
}

void MainWindow::on_actionInserir_Triangulo_triggered()
{
    if (criador){

        InserirTriangulo janelaTriangulo;

        janelaTriangulo.setModal(true);
        janelaTriangulo.exec();
    }
}

void MainWindow::on_actionInserir_Hexagono_triggered()
{
    if (criador){

        InserirHexagono janelaHexagono;

        janelaHexagono.setModal(true);
        janelaHexagono.exec();
    }
}

void MainWindow::on_actionLimpar_Tela_de_Desenho_triggered()
{
    if(criador){
        if(insere_retangulo || insere_circulo || insere_triangulo || insere_hexagono){

            LimparCanvas janelaLimpar;

            janelaLimpar.setModal(true);
            janelaLimpar.exec();
        }
    }

}

void MainWindow::on_actionRemover_Poligono_triggered()
{
    if(criador){
        if(insere_retangulo || insere_circulo || insere_triangulo || insere_hexagono){

            RemoverPoligono janelaRemover;

            janelaRemover.setModal(true);
            janelaRemover.exec();
        }
    }

}

void MainWindow::on_actionEditar_Poligono_triggered()
{
    if(criador){
        if(insere_retangulo || insere_circulo || insere_triangulo || insere_hexagono){

            EditarPoligono janelaEditar;

            janelaEditar.setModal(true);
            janelaEditar.exec();
        }
    }
}


void MainWindow::paintEvent(QPaintEvent *e)
{
    QPainter painter(this);
    QPixmap imagem("C:/Users/Marcelo/Desktop/Rafael Praxedes/Arquivos - Qt/Background.jpg");

    //resize(imagem.size());
    MainWindow::showMaximized();
    painter.drawPixmap(0,0, imagem);

    QPolygon telaDeDesenho;

    if (criador){
        QRect canvas(35, 50, largura_canvas, altura_canvas);
        QBrush cor(Qt::white);

        painter.fillRect(canvas, cor);
        painter.drawRect(canvas);

        telaDeDesenho = canvas;

        MainWindow::update();
    }

    if (deletor){

        telaDeDesenho.clear();

        MainWindow::update();
    }

    if (insere_retangulo){

        int x, y, base, altura;

        for (int i = 0; i < poligonosDoCanvas.size(); i++){
           if (poligonosDoCanvas[i]->getTipo() == "Retangulo"){

                x = poligonosDoCanvas[i]->getCentroPoligono_x();
                y = poligonosDoCanvas[i]->getCentroPoligono_y();

                base = poligonosDoCanvas[i]->getBase();
                altura = poligonosDoCanvas[i]->getAltura();

                QRect retangulo(x, y, base, altura);

                if (poligonosDoCanvas[i]->getCorPoligono() == "vermelho"){

                    QBrush cor(Qt::red);
                    painter.setBrush(cor);
                    painter.fillRect(retangulo, cor);
                }

                if (poligonosDoCanvas[i]->getCorPoligono() == "azul"){

                    QBrush cor(Qt::blue);
                    painter.setBrush(cor);
                    painter.fillRect(retangulo, cor);
                }

                if (poligonosDoCanvas[i]->getCorPoligono() == "amarelo"){

                    QBrush cor(Qt::yellow);
                    painter.setBrush(cor);
                    painter.fillRect(retangulo, cor);
                }

                if (poligonosDoCanvas[i]->getCorPoligono() == "verde"){

                    QBrush cor(Qt::green);
                    painter.setBrush(cor);
                    painter.fillRect(retangulo, cor);
                }

                if (poligonosDoCanvas[i]->getCorPoligono() == "preto"){

                    QBrush cor(Qt::black);
                    painter.setBrush(cor);
                    painter.fillRect(retangulo, cor);
                }

                painter.drawRect(retangulo);

                MainWindow::update();

            }//if
       }//for

    }//if

    if (insere_circulo){

        int x, y, raio;

        for (int i = 0; i < poligonosDoCanvas.size(); i++){
            if (poligonosDoCanvas[i]->getTipo() == "Circulo"){

                x = poligonosDoCanvas[i]->getCentroPoligono_x();
                y = poligonosDoCanvas[i]->getCentroPoligono_y();

                raio = poligonosDoCanvas[i]->getBase();

                if (poligonosDoCanvas[i]->getCorPoligono() == "vermelho"){

                    QBrush cor(Qt::red);
                    painter.setBrush(cor);
                }

                if (poligonosDoCanvas[i]->getCorPoligono() == "azul"){

                    QBrush cor(Qt::blue);
                    painter.setBrush(cor);
                }

                if (poligonosDoCanvas[i]->getCorPoligono() == "amarelo"){

                    QBrush cor(Qt::yellow);
                    painter.setBrush(cor);
                }

                if (poligonosDoCanvas[i]->getCorPoligono() == "verde"){

                    QBrush cor(Qt::green);
                    painter.setBrush(cor);
                }

                if (poligonosDoCanvas[i]->getCorPoligono() == "preto"){

                    QBrush cor(Qt::black);
                    painter.setBrush(cor);
                }

                painter.drawEllipse(x, y, raio, raio);

                MainWindow::update();

            }//if
        }//for
    }//if

    if (insere_triangulo){

        int x, y, lado;

        for (int i = 0; i < poligonosDoCanvas.size(); i++){
            if (poligonosDoCanvas[i]->getTipo() == "Triangulo"){

                x = poligonosDoCanvas[i]->getCentroPoligono_x();
                y = poligonosDoCanvas[i]->getCentroPoligono_y();

                lado = poligonosDoCanvas[i]->getBase();

                if (poligonosDoCanvas[i]->getCorPoligono() == "vermelho"){

                    QBrush cor(Qt::red);
                    painter.setBrush(cor);
                }

                if (poligonosDoCanvas[i]->getCorPoligono() == "azul"){

                    QBrush cor(Qt::blue);
                    painter.setBrush(cor);
                }

                if (poligonosDoCanvas[i]->getCorPoligono() == "amarelo"){

                    QBrush cor(Qt::yellow);
                    painter.setBrush(cor);
                }

                if (poligonosDoCanvas[i]->getCorPoligono() == "verde"){

                    QBrush cor(Qt::green);
                    painter.setBrush(cor);
                }

                if (poligonosDoCanvas[i]->getCorPoligono() == "preto"){

                    QBrush cor(Qt::black);
                    painter.setBrush(cor);
                }

                int aux = (lado*sqrt(3)/2);

                QPolygon triangulo;

                triangulo << QPoint(x, y);
                triangulo << QPoint(x - (lado/2), y + aux);
                triangulo << QPoint(x + (lado/2), y + aux);

                painter.drawPolygon(triangulo);

                MainWindow::update();

            }//if
        }//for
    }//if

    if (insere_hexagono){

        int x, y, lado;

        for (int i = 0; i < poligonosDoCanvas.size(); i++){
            if (poligonosDoCanvas[i]->getTipo() == "Hexagono"){

                x = poligonosDoCanvas[i]->getCentroPoligono_x();
                y = poligonosDoCanvas[i]->getCentroPoligono_y();

                lado = poligonosDoCanvas[i]->getBase();

                if (poligonosDoCanvas[i]->getCorPoligono() == "vermelho"){

                    QBrush cor(Qt::red);
                    painter.setBrush(cor);
                }

                if (poligonosDoCanvas[i]->getCorPoligono() == "azul"){

                    QBrush cor(Qt::blue);
                    painter.setBrush(cor);
                }

                if (poligonosDoCanvas[i]->getCorPoligono() == "amarelo"){

                    QBrush cor(Qt::yellow);
                    painter.setBrush(cor);
                }

                if (poligonosDoCanvas[i]->getCorPoligono() == "verde"){

                    QBrush cor(Qt::green);
                    painter.setBrush(cor);
                }

                if (poligonosDoCanvas[i]->getCorPoligono() == "preto"){

                    QBrush cor(Qt::black);
                    painter.setBrush(cor);
                }

                int aux = (lado*sqrt(3)/2);

                QPolygon hexagono;

                hexagono << QPoint(x, y);
                hexagono << QPoint(x + lado, y);
                hexagono << QPoint(x + (3*lado/2), y + aux);
                hexagono << QPoint(x + lado, y + 2*aux);
                hexagono << QPoint(x, y + 2*aux);
                hexagono << QPoint(x - (lado/2), y + aux);

                painter.drawPolygon(hexagono);

                MainWindow::update();

            }//if
        }//for
    }//if

    if (limpar_canvas){

         MainWindow::update();
    }

    if (remover_poligono){

         MainWindow::update();
    }

    if (edita_retangulo){

         edita_retangulo = false;
         MainWindow::on_actionInserir_Retangulo_triggered();
    }

    if (edita_circulo){

        edita_circulo = false;
        MainWindow::on_actionInserir_Circulo_triggered();
    }

    if (edita_triangulo){

        edita_triangulo = false;
        MainWindow::on_actionInserir_Triangulo_triggered();
    }

    if (edita_hexagono){

        edita_hexagono = false;
        MainWindow::on_actionInserir_Hexagono_triggered();
    }

    QMainWindow::paintEvent(e);
}


