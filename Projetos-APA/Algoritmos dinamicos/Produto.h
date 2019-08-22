#ifndef PRODUTO_H
#define PRODUTO_H

class Produto
{
public:
    void setId(int id);
    void setWeigth(int weigth);
    void setValue(int value);
    int getId(void);
    int getWeigth(void);
    int getValue(void);
    
private:
    int id;
    int weigth;
    int value;
};

#endif