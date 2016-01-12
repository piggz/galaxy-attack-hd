#include <QtGui/QGuiApplication>
#include <QtQml/QQmlEngine>
#include <QtQml/QQmlContext>
#include <QtQuick/QQuickView>
#include <QDebug>

#include "Bunker.h"
#include "Helper.h"
#include "scoremodel.h"
#include "pgz_platform.h"
#if defined(MER_EDITION_SAILFISH)
#include <QQmlApplicationEngine>
#else
#include "qtquick2applicationviewer.h"
#endif
#ifdef Q_OS_ANDROID
#include <androidaudio.h>
#include "androidiap.h"
#include "gamecircleleaderboard.h"
#endif

#ifdef Q_OS_PLAYBOOK
#include <bbaudio/blackberryaudio.h>
#endif

#ifdef Q_OS_BLACKBERRY
#define SC_HAS_INITDATA 1
#include <bps/navigator.h>
#include "bbaudio/blackberryaudio.h"
#include "scoreloop/scoreloop.h"
#include "gamepadcontroller.h"
#else
#include "nullgamecontroller.h"
#endif

#define VER1_(x) #x
#define VER_(x)	VER1_(x)
#define VER VER_(MYVERSION)

#ifdef AMAZON_DEVICE
const char* ANDROID_MARKET = "AMAZON";
#else
const char* ANDROID_MARKET = "GOOGLE";
#endif

#ifdef Q_OS_ANDROID
#include <jni.h>

static JavaVM* jvm;

static JNINativeMethod methods[] = {
    #ifndef AMAZON_DEVICE
    {"itemPurchased", "(Ljava/lang/String;I)V", (void *)itemPurchased},
    #endif
};

jint JNICALL JNI_OnLoad(JavaVM *vm, void *)
{
    JNIEnv *env;
    jvm = vm;
    if (vm->GetEnv(reinterpret_cast<void **>(&env), JNI_VERSION_1_4) != JNI_OK)
        return JNI_FALSE;

    jclass clazz = env->FindClass("uk/co/piggz/galaxy_attack_hd/GalaxyAttackHDActivity");
    if (env->RegisterNatives(clazz, methods, sizeof(methods) / sizeof(methods[0])) < 0)
        return JNI_FALSE;

    return JNI_VERSION_1_6;
}

#endif

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qDebug() << VER;

#if defined(MER_EDITION_SAILFISH)
    QQmlApplicationEngine viewer;
#else
    QtQuick2ApplicationViewer viewer;
#endif
    qmlRegisterType<Bunker>("harbour.pgz.galaxy.attack.hd", 1, 0, "Bunker");

    QCoreApplication::setOrganizationDomain("piggz.co.uk");
    //work around harbour rules for config files
    #if defined(MER_EDITION_SAILFISH)
        QCoreApplication::setOrganizationName("harbour-pgz-galaxy-attack-hd");
        QCoreApplication::setApplicationName("harbour-pgz-galaxy-attack-hd");
    #else
        QCoreApplication::setOrganizationName("PGZ");
        QCoreApplication::setApplicationName("galaxy-attack-hd");
    #endif


    pgzRegisterPlatform(viewer.rootContext());

    Helper *helper = new Helper();
    viewer.rootContext()->setContextProperty("Helper", helper);

    ScoreModel *scores = new ScoreModel(&viewer);
    viewer.rootContext()->setContextProperty("ScoreModel", scores);

    viewer.rootContext()->setContextProperty("Viewer", &viewer);
#if !defined(MER_EDITION_SAILFISH)
    viewer.setResizeMode(QQuickView::SizeRootObjectToView);
#endif
#ifdef Q_OS_ANDROID
    AndroidAudio *androidAudio = AndroidAudio::instance();
    viewer.rootContext()->setContextProperty("NativeAudio", androidAudio);

    NullGameController gameController;
    viewer.rootContext()->setContextProperty("GamepadController",  &gameController);

    AndroidIAP *iap = new AndroidIAP();
    viewer.rootContext()->setContextProperty("IAP", iap);

    GameCircleLeaderboard *gameCircle = new GameCircleLeaderboard();
    viewer.rootContext()->setContextProperty("GameCircle", gameCircle);

    viewer.rootContext()->setContextProperty("ANDROID_MARKET", ANDROID_MARKET);

    viewer.engine()->setBaseUrl(QUrl::fromLocalFile("/"));
    viewer.setSource(QUrl("assets:/qml/galaxy-attack-hd/main-android.qml"));

    viewer.showFullScreen();
#elif Q_OS_BLACKBERRY_TABLET
    qDebug() << "On a playbook!";
    
    Scoreloop *scoreloop = new Scoreloop();
    viewer.rootContext()->setContextProperty("ScoreLoop", scoreloop);
    
    BlackberryAudio *bbaudio = new BlackberryAudio(0);
    viewer.rootContext()->setContextProperty("NativeAudio",  bbaudio);

    viewer.setMainQmlFile(QLatin1String("qml/pgz-spaceinvaders/main-bb10.qml"));
    viewer.showExpanded();
#elif Q_OS_BLACKBERRY
    qDebug() << "On a blackberry!";

    Scoreloop *scoreloop = new Scoreloop();
    viewer.rootContext()->setContextProperty("ScoreLoop", scoreloop);

    BlackberryAudio *bbaudio = new BlackberryAudio(0);
    viewer.rootContext()->setContextProperty("NativeAudio",  bbaudio);

    GamepadController *gamePad = new GamepadController();
    viewer.rootContext()->setContextProperty("GamepadController",  gamePad);

    navigator_set_orientation_mode(NAVIGATOR_LANDSCAPE, 0);
    navigator_rotation_lock(true);

    qDebug() << "setting qml";
    viewer.setMainQmlFile(QLatin1String("qml/galaxy-attack-hd/main-bb10.qml"));

    qDebug() << "showing..";
    viewer.showExpanded();
#elif defined(MER_EDITION_SAILFISH)
#warning Doing a SFOS build :)
    NullGameController gameController;
    viewer.rootContext()->setContextProperty("GamepadController",  &gameController);
    viewer.load(QLatin1String("/usr/share/harbour-pgz-galaxy-attack-hd/qml/galaxy-attack-hd/main-sailfish.qml"));
#else
    //viewer.engine()->addImportPath(QString("/opt/qtm12/imports"));
    //viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockLandscape);
    NullGameController gameController;
    viewer.rootContext()->setContextProperty("GamepadController",  &gameController);

    viewer.setMainQmlFile(QLatin1String("qml/galaxy-attack-hd/main.qml"));
    viewer.setWidth(1280);
    viewer.setHeight(720);
    viewer.show();

#endif



    return app.exec();
}
