#ifndef GAMECIRCLELEADERBOARD_H
#define GAMECIRCLELEADERBOARD_H

#include <QObject>
#include "LeaderboardsClientInterface.h"

class GameCircleLeaderboard : public QObject
{
    Q_OBJECT
public:
    explicit GameCircleLeaderboard(QObject *parent = 0);

signals:

public slots:
    void showLeaderBoard();

private:
    AmazonGames::LeaderboardsClientInterface m_interface;
};

#endif // GAMECIRCLELEADERBOARD_H
