#include "Produto.h"

void Produto::setId(int id)
{
    this->id = id;
}

void Produto::setWeigth(int weigth)
{
    this->weigth = weigth;
}

void Produto::setValue(int value)
{
    this->value = value;
}

int Produto::getId(void)
{
    return this->id;
}

int Produto::getWeigth(void)
{
    return this->weigth;
}

int Produto::getValue(void)
{
    return this->value;
}