#include "gamecircleleaderboard.h"

GameCircleLeaderboard::GameCircleLeaderboard(QObject *parent) :
    QObject(parent)
{
}

void GameCircleLeaderboard::showLeaderBoard() {
    m_interface.showLeaderboardsOverlay();
}
