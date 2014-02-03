#include "scoremodel.h"
#include <QDebug>
#include <QString>
#include <QStringList>
#include <QFile>
#include <QTextStream>
#include <QFileInfo>


ScoreModel::ScoreModel(QObject *parent) :
    QAbstractListModel(parent)
{
    loadScores();
}

QHash<int, QByteArray> ScoreModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[ScorePositionRole] = "scoreposition";
    roles[ScoreRole] = "score";
    roles[ScoreLevelIdRole] = "scorelevelid";
    roles[ScoreLevelNameRole] = "scorelevelname";
    roles[ScoreStageRole] = "scorestage";
    roles[ScoreCurrentLevelRole] = "scorecurrentlevel";
    roles[ScoreDateRole] = "scoredate";

    return roles;
}

QVariant ScoreModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < rowCount(index)) {
        Score score = m_scores[index.row()];
        if (role == ScorePositionRole)  {
            return index.row() + 1;
        } else if (role == ScoreRole)  {
            return score.score;
        } else if (role == ScoreLevelIdRole) {
            return score.levelId;
        } else if (role == ScoreLevelNameRole) {
            return score.levelName;
        } else if (role == ScoreStageRole) {
            return score.stage;
        } else if (role == ScoreCurrentLevelRole) {
            return score.level;
        } else if (role == ScoreDateRole) {
            return score.date;
        }
    }
    return QVariant();


}

int ScoreModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_scores.length();
}

bool ScoreModel::addScore(int score, const QString &levelId, const QString &levelName,  int stage, int currentlevel, const QString &date)
{
    qDebug() << "Adding Score" << score << levelId << levelName << stage << currentlevel << date;

    Score s;

    if (score > 0 && currentlevel > 0) {
        s.score = score;
        s.levelId = levelId;
        s.levelName = levelName;
        s.stage = stage;
        s.level = currentlevel;
        s.date = date;

        beginResetModel();
        m_scores.push_back(s);

        qSort(m_scores);

        endResetModel();
    }
    return true;
}

bool ScoreModel::loadScores()
{
#ifdef Q_OS_BLACKBERRY
    QFile file("data/galaxy-attack-hd-scores.db");
#else
    QFile file("galaxy-attack-hd-scores.db");
#endif
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return false;

    QTextStream in(&file);
    m_scores.clear();
    while (!in.atEnd()) {
        QString line = in.readLine();
        QStringList data = line.split(",");

        qDebug() << "Reading Score:" << data;

        if (data.length() == 6) {
            Score s;
            s.score = data[0].toInt();
            s.levelId = data[1];
            s.levelName = data[2];
            s.stage = data[3].toInt();
            s.level = data[4].toInt();
            s.date = data[5];

            if (s.score > 0 && s.level > 0) {
                m_scores.push_back(s);
            }
        }
        qSort(m_scores);
    }
    return true;
}

bool ScoreModel::saveScores()
{
#ifdef Q_OS_BLACKBERRY
    QFile file("data/galaxy-attack-hd-scores.db");
#else
    QFile file("galaxy-attack-hd-scores.db");
#endif
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qDebug() << "File open error:" << file.error() << QFileInfo(file).absolutePath();
        return false;
    }

    qDebug() << "Saving Scores";

    QTextStream out(&file);

    foreach(Score s, m_scores) {
        if (s.score > 0) {
            out << s.score << "," << s.levelId << "," << s.levelName << "," << s.stage << "," << s.level << "," << s.date << endl;
        }
    }

    return true;
}

int ScoreModel::bestScore()
{
    if (m_scores.length() > 0) {
        return (m_scores[0].score);
    }

    return 0;
}

int ScoreModel::bestLevel()
{
    if (m_scores.length() > 0) {
        return (m_scores[0].stage * 100 + m_scores[0].level);
    }

    return 0;
}
