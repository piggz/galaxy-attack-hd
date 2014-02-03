#ifndef SCORELOOP_H
#define SCORELOOP_H

#include <QObject>
#include <scoreloop/sc_client.h>
#include <scoreloop/scoreloopcore.h>
#include <scoreloop/sc_score_list.h>
#include <scoreloop/sc_score.h>
#include <scoreloop/sc_client.h>

#ifdef Q_OS_ANDROID
#include <scoreloop/sc_client_config.h>
#include <scoreloop/sc_client_config_platform.h>
#endif

#include <QDebug>
#include <QStringList>
#include <QModelIndex>

#define HAS_SC_CLIENTCONFIG 1
#define HAS_SC_TERMS_OF_SERVICE 1

class Scoreloop : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QString userName READ userName NOTIFY userNameChanged);
    Q_PROPERTY(bool scoreAvailable READ scoreAvailable NOTIFY scoreAvailableChanged);
public:
    explicit Scoreloop(QObject *parent = 0);
    ~Scoreloop();

    enum Roles {
        Score = Qt::UserRole + 1,
        User, Rank, Stage
    };

    virtual QHash<int, QByteArray> roleNames() const;

signals:
    void userNameChanged();
    void scoreAvailableChanged();
    
public slots:
    void submitNewScore(int score, int level);
    void requestScores();
    QString userName() const;
    bool scoreAvailable() const;
    void processEvents();

public:
    static void LoadLeaderboardCompletionCallback(void *userData, SC_Error_t completionStatus);
    static void ScoreCompletionCallback(void *userData, SC_Error_t completionStatus);
    static void userControllerCallback(void* cookie, SC_Error_t status);
    void requestCompleted();


    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

private:
    bool mRequestCompleted;
    bool mScoreAvailable;
    QStringList allScores;

    SC_Client_h mClient;
    static SC_ScoresController_h mScoresController;
    SC_UserController_h m_userController;
    SC_User_h mUser;

#if SC_HAS_INITDATA
    SC_InitData_t mInitData;
#else
    SC_ClientConfig_h mClientConfig;
    jobject activity;
#endif

protected:
    static QVariantList leaderboardData;
};

#endif // SCORELOOP_H
