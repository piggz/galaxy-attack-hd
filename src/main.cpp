#include <QtGui/QGuiApplication>
#include <QtQml/QQmlEngine>
#include <QtQml/QQmlContext>
#include <QtQuick/QQuickView>
#include <QDebug>

#include "Bunker.h"
#include "Helper.h"
#include "scoremodel.h"
#include "pgz_platform.h"
#include "qtquick2applicationviewer.h"

#ifdef Q_OS_ANDROID
#define SC_HAS_INITDATA 0
#include <androidaudio.h>
#include "scoreloop/scoreloop.h"
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

#ifdef Q_OS_ANDROID

#include <jni.h>

static JavaVM* jvm;


jint JNI_OnLoad(JavaVM* vm, void* reserved)

{

    jvm = vm;

    return JNI_VERSION_1_6;

}

#endif

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qDebug() << VER;

    QtQuick2ApplicationViewer viewer;

    qmlRegisterType<Bunker>("SpaceInvaders", 1, 0, "Bunker");
    QCoreApplication::setOrganizationName("PGZ");
    QCoreApplication::setOrganizationDomain("piggz.co.uk");
    QCoreApplication::setApplicationName("galaxy-attack-hd");

    pgzRegisterPlatform(viewer.rootContext());

    Helper *helper = new Helper();
    viewer.rootContext()->setContextProperty("Helper", helper);

    ScoreModel *scores = new ScoreModel(&viewer);
    viewer.rootContext()->setContextProperty("ScoreModel", scores);

    viewer.rootContext()->setContextProperty("Viewer", &viewer);
    viewer.setResizeMode(QQuickView::SizeRootObjectToView);

#ifdef Q_OS_ANDROID

    JNIEnv* env;
    jvm->AttachCurrentThread(&env, NULL);


    AndroidAudio *androidAudio = AndroidAudio::instance();
    viewer.rootContext()->setContextProperty("NativeAudio", androidAudio);

    NullGameController gameController;
    viewer.rootContext()->setContextProperty("GamepadController",  &gameController);

    Scoreloop *scoreloop = new Scoreloop();
    viewer.rootContext()->setContextProperty("ScoreLoop", scoreloop);

    viewer.engine()->setBaseUrl(QUrl::fromLocalFile("/"));
    viewer.setSource(QUrl("assets:/qml/pgz-spaceinvaders/main-android.qml"));

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
#else
    //viewer.engine()->addImportPath(QString("/opt/qtm12/imports"));
    //viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockLandscape);
    NullGameController gameController;
    viewer.rootContext()->setContextProperty("GamepadController",  &gameController);

    viewer.setMainQmlFile(QLatin1String("qml/galaxy-attack-hd/main.qml"));
    viewer.setWidth(800);
    viewer.setHeight(480);
    viewer.showExpanded();
#endif



    return app.exec();
}
