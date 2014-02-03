#include "scoreloop.h"

//extern QString asQString(SC_String_h scString);

QVariantList Scoreloop::leaderboardData;
SC_ScoresController_h Scoreloop::mScoresController;

#ifdef Q_OS_ANDROID
#include <5.2.0/QtGui/qpa/qplatformnativeinterface.h>
#include <QApplication>
static void SC_EventNotifier(void *eventNotifierContext) { }
#endif

Scoreloop::Scoreloop(QObject *parent) :
    QAbstractListModel(parent) ,
    mRequestCompleted(false),
    mScoreAvailable(false),
    m_userController(0),
    mUser(0)
#ifdef Q_OS_ANDROID
    ,activity(0)
#endif
{
    SC_Error_t rc;
#if SC_HAS_INITDATA
    SC_InitData_Init(&mInitData);
    mInitData.runLoopType = SC_RUN_LOOP_TYPE_CUSTOM;

    rc = SC_Client_New(&mClient, &mInitData, "de4c3023-eb40-4271-a55c-b8ce7e318fd8",
                                  "Fkk4v1Y3t9H9Hmr4acYY05tqSSrrbGl0LsW013mCc5UI/f6mtbaFug==",
                                  "0.8", "KVH", "en");
#else
    SC_ClientConfig_New(&mClientConfig);
    SC_ClientConfig_SetRunLoopType(mClientConfig, SC_RUN_LOOP_TYPE_CUSTOM);

    // Required: pass a reference to the Android context.
    // When using NativeActivity, the clazz field contains a context.
    QPlatformNativeInterface *interface = QApplication::platformNativeInterface();
    activity = (jobject)interface->nativeResourceForIntegration("QtActivity");

    qDebug() <<"Activity:" << activity;
    rc = SC_ClientConfig_SetAndroidContext(mClientConfig, activity);
    if (rc != SC_OK) {
        qDebug() << "Could not set android context: " << SC_MapErrorToStr(rc);
        return;
    }

    // aGameId, aGameSecret and aCurrency are const char strings that you obtain from Scoreloop.
    // aGameVersion should be your current game version.
    rc = SC_ClientConfig_SetGameIdentifier(mClientConfig, "de4c3023-eb40-4271-a55c-b8ce7e318fd8");
    if (rc != SC_OK) {
        qDebug() << "Could not set game identifier: " << SC_MapErrorToStr(rc);
        return;
    }
    rc = SC_ClientConfig_SetGameSecret(mClientConfig, "Fkk4v1Y3t9H9Hmr4acYY05tqSSrrbGl0LsW013mCc5UI/f6mtbaFug==");
    if (rc != SC_OK) {
        qDebug() << "Could not set game secret " << SC_MapErrorToStr(rc);
        return;
    }
    rc = SC_ClientConfig_SetGameVersion(mClientConfig, "0.8");
    if (rc != SC_OK) {
        qDebug() << "Could not set game version" << SC_MapErrorToStr(rc);
        return;
    }
    rc = SC_ClientConfig_SetGameCurrency(mClientConfig, "KVH");
    if (rc != SC_OK) {
        qDebug() << "Could not set currency " << SC_MapErrorToStr(rc);
        return;
    }
    rc = SC_ClientConfig_SetLanguages(mClientConfig, "en");
    if (rc != SC_OK) {
        qDebug() << "Could not set language: " << SC_MapErrorToStr(rc);
        return;
    }

    rc = SC_Client_NewWithConfig(&mClient, mClientConfig);
    if (rc != SC_OK) {
        qDebug() << "Could not create client config " << SC_MapErrorToStr(rc);
        return;
    }
#endif

    if (rc != SC_OK) {
        qDebug() << "Could not initialize Scoreloop: " << SC_MapErrorToStr(rc);
        return;
    }

    rc = SC_Client_CreateScoresController(mClient, &mScoresController, LoadLeaderboardCompletionCallback, this);
    if (rc != SC_OK) {;
        qDebug() << "Could not load score";
        return;
    }

    requestScores();

    qDebug() << "Creating user controller";
    rc = SC_Client_CreateUserController(mClient, &m_userController, userControllerCallback, this);
    if (rc != SC_OK) {;
        qDebug() << "Could not create user controller";
    }
    
#ifdef Q_OS_BLACKBERRY_TABLET
    // mUser = SC_UserController_GetUser(m_userController);
    rc = SC_UserController_RequestUser(m_userController);
#else
    rc = SC_UserController_LoadUser(m_userController);
#endif
    if (rc != SC_OK) {;
        qDebug() << "Could not create user controller";
    }
    qDebug() << "Completed scoreloop init";
}

Scoreloop::~Scoreloop()
{
    SC_Client_Release(mClient);
}

void Scoreloop::LoadLeaderboardCompletionCallback(void *userData, SC_Error_t completionStatus)
{
    qDebug() << "LoadLeaderboardCompletionCallback";
    if (completionStatus != SC_OK) {
        qDebug() << "Error in LoadLeaderboardCompletionCallback" << SC_MapErrorToStr(completionStatus);
        return;
    }
    Scoreloop *currentObject = (Scoreloop*)(userData);
    if (!currentObject)
        return;
    
#ifdef Q_OS_BLACKBERRY_TABLET
    SC_ScoreFormatter_h scoreFormatter;
    SC_Error_t errCode = SC_Client_GetScoreFormatter(currentObject->mClient, &scoreFormatter);
    if (errCode != SC_OK) {
        qDebug() << "Could not get score formatter: " << SC_MapErrorToStr(errCode);
    }
    
#else
    SC_ScoreFormatter_h scoreFormatter = SC_Client_GetScoreFormatter(currentObject->mClient);
#endif
    SC_ScoreList_h scoreList = SC_ScoresController_GetScores(currentObject->mScoresController);
#ifdef Q_OS_BLACKBERRY_TABLET
    unsigned int i, numScores = SC_ScoreList_GetScoresCount(scoreList);
#else
    unsigned int i, numScores = SC_ScoreList_GetCount(scoreList);
#endif
    currentObject->beginResetModel();
    leaderboardData.clear();
    
    qDebug() << "Scores count" << numScores;
    for (i = 0; i < numScores; ++i) {
#ifdef Q_OS_BLACKBERRY_TABLET
        SC_Score_h score = SC_ScoreList_GetScore(scoreList, i);
#else
        SC_Score_h score = SC_ScoreList_GetAt(scoreList, i);
#endif
        SC_User_h user = SC_Score_GetUser(score);
        SC_String_h login = user ? SC_User_GetLogin(user) : NULL;
        SC_String_h formattedScore;
        qDebug() << "Mode:" << SC_Score_GetMode(score);

        /* Format the score - we take ownership of string */
        int rc = SC_ScoreFormatter_FormatScore(scoreFormatter, score, SC_SCORE_FORMAT_DEFAULT, &formattedScore);
        if (rc != SC_OK) {
            qWarning() << "cannot format scores";
            return;
        }
        qDebug() << " Rank: " << SC_Score_GetRank(score) << ", Result: " << SC_String_GetData(formattedScore) << ", User: " << (login ? SC_String_GetData(login) : "<unknown>");

        QVariantMap scoreData;
        scoreData["rank"] = SC_Score_GetRank(score);
        scoreData["score"] = SC_Score_GetResult(score);
        scoreData["stage"] = SC_Score_GetLevel(score);
        scoreData["username"] = login ? SC_String_GetData(login) : "<unknown>";

        currentObject->beginResetModel();
        leaderboardData.append(scoreData);

        /* Release the string */
        SC_String_Release(formattedScore);
    }
    currentObject->endResetModel();
    qDebug() << "Scores changed";
    currentObject->mScoreAvailable = true;
    emit currentObject->scoreAvailableChanged();
}

void Scoreloop::ScoreCompletionCallback(void *userData, SC_Error_t completionStatus)
{
    Q_UNUSED(userData)
    Q_UNUSED(completionStatus)
    qDebug() << "Score submit completed" << SC_MapErrorToStr(completionStatus);
}

void Scoreloop::userControllerCallback(void* userData, SC_Error_t status)
{
    qDebug() << "userControllerCallback";
    if (status == SC_OK) {
        Scoreloop *currentObject = (Scoreloop*)userData;
        if (!currentObject)
            return;
        currentObject->mUser = SC_UserController_GetUser(currentObject->m_userController);
        emit currentObject->userNameChanged();
    } else {
        qDebug() << "Error in user callback" << SC_MapErrorToStr(status);
    }
}

void Scoreloop::requestCompleted()
{
    mRequestCompleted = true;
    qDebug() << "Request completed";
}

void Scoreloop::submitNewScore(int newscore, int newlevel)
{
    qDebug() << "Submitting new score" << newscore << newlevel;

    SC_Score_h score;
    SC_Client_CreateScore(mClient, &score);
    SC_Score_SetLevel(score, newlevel);
    SC_Score_SetResult(score, newscore);
    SC_ScoreController_h score_controller;
    SC_Error_t rc = SC_Client_CreateScoreController (mClient, &score_controller, ScoreCompletionCallback, this);
    if (rc != SC_OK) {
        qWarning() << "cannot create score controller" << SC_MapErrorToStr(rc);;
        return;
    }
    rc  = SC_ScoreController_SubmitScore(score_controller, score);
    if (rc != SC_OK) {
        qWarning() << "cannot submit scores" << SC_MapErrorToStr(rc);;
        return;
    }
}

int Scoreloop::rowCount(const QModelIndex & parent)const
{
    Q_UNUSED(parent)
    return leaderboardData.count();
}

QVariant Scoreloop::data(const QModelIndex & index, int role)const
{
    int row = index.row();
    switch (role) {
    case User:
        return leaderboardData.at(row).toMap().value("username");
    case Rank:
        return leaderboardData.at(row).toMap().value("rank");
    case Score:
        return  leaderboardData.at(row).toMap().value("score");
    case Stage:
        return  leaderboardData.at(row).toMap().value("stage");
    default:
        break;
    }
    return QVariant();
}

void Scoreloop::requestScores()
{
    qDebug() << "requestScores";
    SC_Error_t completionStatus;
    mScoreAvailable = false;
    emit scoreAvailableChanged();
    setProperty("scoreAvailable", false);
#ifdef Q_OS_BLACKBERRY_TABLET
    unsigned int aRangeStart = 0;
    unsigned int aRangeLength = 100;
    completionStatus = SC_ScoresController_LoadRange(mScoresController, aRangeStart, aRangeLength);
#else
    SC_Range_t range;
    range.offset = 0;
    range.length = 100;
    completionStatus = SC_ScoresController_LoadScores(mScoresController, range);
#endif
    qDebug() << "Request Scores: " << SC_MapErrorToStr(completionStatus);
}

QString Scoreloop::userName() const
{
    qDebug() << "userName";
    if (mUser) {
        return QString(SC_String_GetData(SC_User_GetLogin(mUser)));
    }

    return QString();
}

bool Scoreloop::scoreAvailable() const
{
    return mScoreAvailable;
}

QHash<int, QByteArray> Scoreloop::roleNames() const
{
    QHash<int, QByteArray> roleNames;
    roleNames[User] = "user";
    roleNames[Rank] = "rank";
    roleNames[Score] = "score";
    roleNames[Stage] = "stage";
    return roleNames;
}

void Scoreloop::processEvents()
{
#if SC_HAS_INITDATA
    SC_HandleCustomEvent(&mInitData, SC_FALSE);
#else
    SC_HandleCustomEvents(mClientConfig);
#endif
}
