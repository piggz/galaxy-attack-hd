#ifndef BUNKER_H
#define BUNKER_H

#include <QtQuick/QQuickPaintedItem>

const int bunkerWidth = 30;
const int bunkerHeight = 30;

const QString bunkerPattern = \
"          xxxxxxxxxx          "\
"        xxx..xxxxxxxxx        "\
"      xxx..xxxxxxxxxxxxx      "\
"    xxx..xxxxxxxxxxxxxxxxx    "\
"   xxx..xxxxxxxxxxxxxxxxxxx   "\
"  xxx..xxxxxxxxxxxxxxxxxxxxx  "\
"  xxx..xxxxxxxxxxxxxxxxxxxxx  "\
" xxx..xxxxxxxxxxxxxxxxxxxxxxx "\
" xxx..xxxxxxxxxxxxxxxxxxxxxxx "\
"xxx..xxxxxxxxxxxxxxxxxxxxxxxxx"\
"xx..xxxxxxxxxxxxxxxxxxxxxxxxxx"\
"xx..xxxxxxxxxxxxxxxxxx..xxxxxx"\
"xx..xxxxxx          xx..xxxxxx"\
"xx..xxxxxx          xx..xxxxxx"\
"xx..xxxxxx          xx..xxxxxx"\
"xx..xxxxxx          xx..xxxxxx"\
"xx..xxxxxx          xx..xxxxxx"\
"xx..xxxxxx          xx..xxxxxx"\
"xx..xxxxxx          xx..xxxxxx"\
"xx..xxxxxx          xx..xxxxxx"\
"xx..xxxxxx          xx..xxxxxx"\
"xx..xxxxxx          xx..xxxxxx"\
"xx..xxxxxx          xx..xxxxxx"\
"xx..xxxxxx          xx..xxxxxx"\
"xx..xxxxxx          xx..xxxxxx"\
"xx..xxxxxx          xx..xxxxxx"\
"xx..xxxxxxxxxxxxxxxxxxxxxxxxxx"\
"xx..xxxxxxxxxxxxxxxxxxxxxxxxxx"\
"xx..xxxxxxxxxxxxxxxxxxxxxxxxxx"\
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";


class Bunker : public QQuickPaintedItem
{
    Q_OBJECT
public:
    explicit Bunker(QQuickItem *parent = 0);

    virtual void paint(QPainter *painter);

signals:

public slots:
    void build();
    void demolish();
    bool checkCollision(int object_x, int object_y, int object_w, int object_h, bool alien = false);
    bool checkCollisionRev(int object_x, int object_y, int object_w, int object_h);

private:
    void damageBunkerBomb(int);
    void damageBunkerLaser(int);
    void damageBunkerReal(int);

    QString m_bunkerMap;
};

#endif // BUNKER_H
