#include "Bunker.h"
#include <QPainter>

Bunker::Bunker(QQuickItem *parent) :
    QQuickPaintedItem(parent)
{
    setFlag(QQuickItem::ItemHasContents, true);
}

void Bunker::build()
{
    m_bunkerMap = bunkerPattern;
    update();
}

void Bunker::demolish()
{
    m_bunkerMap.replace("x", " ");
    m_bunkerMap.replace(".", " ");
    update();
}

void Bunker::paint(QPainter *painter)
{  
    int blockWidth = width() / bunkerWidth;
    int blockHeight = height() / bunkerHeight;


    painter->setPen(Qt::NoPen);
    QBrush xbrush(QColor(100,100,100));
    QBrush dotbrush(QColor(150,150,150));

    painter->setRenderHints(QPainter::Antialiasing, false);

    for (int i = 0; i < m_bunkerMap.length(); ++i) {
        QString c = m_bunkerMap.mid(i, 1);
        if (c == "x" || c == ".") {
            if (c == "x") {
                painter->setBrush(xbrush);
            } else {
                painter->setBrush(dotbrush);
            }

            int py = i/bunkerWidth;
            int px = i - (py*bunkerWidth);

            py *= blockHeight;
            px *= blockWidth;

            painter->drawRect(px, py, blockWidth, blockHeight);
        }
    }
}

bool Bunker::checkCollision(int object_x, int object_y, int object_w, int object_h, bool alien)
{
    int blockWidth = width() / bunkerWidth;
    int blockHeight = height() / bunkerHeight;

    bool collided = false;
    for (int i = 0; i < m_bunkerMap.size(); ++ i) {
        if (m_bunkerMap.mid(i, 1) == "x") {
            int py = i/bunkerWidth;
            int px = i - (py*bunkerWidth);

            py *= blockHeight;
            px *= blockWidth;

            px += x();
            py += y();

            if (px >= object_x && px <= object_x + object_w ) {
                if (py >= object_y && py <= object_y + object_h ) {
                    if (alien){
                        damageBunkerReal(i);
                    } else {
                        damageBunkerBomb(i);
                        return true;
                    }
                    collided = true;
                }
            }
        }
    }
    return collided;
}

bool Bunker::checkCollisionRev(int object_x, int object_y, int object_w, int object_h)
{
    int blockWidth = width() / bunkerWidth;
    int blockHeight = height() / bunkerHeight;

    for (int i = m_bunkerMap.size() - 1; i >= 0; --i) {
        if (m_bunkerMap.mid(i, 1) == "x") {
            int py = i/bunkerWidth;
            int px = i - (py*bunkerWidth);

            py *= blockHeight;
            px *= blockWidth;

            px += x();
            py += y();

            if (px >= object_x && px <= object_x + object_w ) {
                if (py >= object_y && py <= object_y + object_h ) {
                    damageBunkerLaser(i);
                    return true;
                }
            }
        }
    }
    return false;
}


void Bunker::damageBunkerBomb(int offset)
{
    damageBunkerReal(offset);
    damageBunkerReal(offset + 1);
    damageBunkerReal(offset + 2);
    damageBunkerReal(offset + 3);
    damageBunkerReal(offset - 1);
    damageBunkerReal(offset - 2);
    damageBunkerReal(offset - 3);
    damageBunkerReal(offset + 14);
    damageBunkerReal(offset + 15);
    damageBunkerReal(offset + 16);
    damageBunkerReal(offset + 30);
    damageBunkerReal(offset - 14);
    damageBunkerReal(offset - 15);
    damageBunkerReal(offset - 16);
    damageBunkerReal(offset - 30);
    update();
}

void Bunker::damageBunkerLaser(int offset)
{
    damageBunkerReal(offset);
    damageBunkerReal(offset + 15);
    damageBunkerReal(offset - 15);
    update();
}

void Bunker::damageBunkerReal(int offset)
{
    m_bunkerMap.replace(offset, 1, " ");
}
