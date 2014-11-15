#include "gamecircleleaderboard.h"
#include <QDebug>

GameCircleLeaderboard::GameCircleLeaderboard(QObject *parent) :
    QObject(parent)
{
}

void GameCircleLeaderboard::showLeaderBoard(const QByteArray &leaderboard) {
    m_interface.showLeaderboardOverlay(leaderboard.data());
}

void GameCircleLeaderboard::showLeaderBoards() {
    m_interface.showLeaderboardsOverlay();
}

void GameCircleLeaderboard::submitScore(const QByteArray &leaderboard, long long score) {
    m_interface.submitScore(leaderboard.data(), score, this);
}

void GameCircleLeaderboard::onSubmitScoreCb(ErrorCode errorCode, const SubmitScoreResponse *submitScoreResponse, int developerTag) {
    qDebug() << "Submit score error code:" << errorCode;
}

void GameCircleLeaderboard::showGameCircle() {
    m_gameCircle.showGameCircle(this);
}

void GameCircleLeaderboard::onShowGameCircleCb(ErrorCode errorCode, int developerTag) {
    qDebug() << "Show gamecircle error code:" << errorCode;

}
