#-------------------------------------------------
#
# Project created by QtCreator 2016-06-03T12:45:44
#
#-------------------------------------------------

QT       += core gui
QT       += xml

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = Projeto_LP1_ParteII
TEMPLATE = app


SOURCES += main.cpp\
        mainwindow.cpp \
    arquivo_novo.cpp \
    inserir_retangulo.cpp \
    inserir_circulo.cpp \
    inserir_hexagono.cpp \
    vector_telas.cpp \
    poligonos.cpp \
    inserir_triangulo.cpp \
    limpar_canvas.cpp \
    remover_poligono.cpp \
    editar_poligono.cpp

HEADERS  += mainwindow.h \
    arquivo_novo.h \
    inserir_retangulo.h \
    inserir_circulo.h \
    inserir_hexagono.h \
    vector_telas.h \
    poligonos.h \
    inserir_triangulo.h \
    limpar_canvas.h \
    remover_poligono.h \
    editar_poligono.h

FORMS    += mainwindow.ui \
    arquivo_novo.ui \
    inserir_retangulo.ui \
    inserir_circulo.ui \
    inserir_hexagono.ui \
    inserir_triangulo.ui \
    limpar_canvas.ui \
    remover_poligono.ui \
    editar_poligono.ui

QMAKE_CXXFLAGS += -std=gnu++14
