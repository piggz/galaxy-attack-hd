TARGET = harbour-pgz-galaxy-attack-hd


# Add more folders to ship with the application, here
folder_01.source = qml/galaxy-attack-hd
folder_01.target = qml

DEPLOYMENTFOLDERS = folder_01

VERSION = 1.0.8
DEFINES+="MYVERSION=$${VERSION}"

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

QT += xml \
      network \
      xmlpatterns \
      gui \
      network \
      core \
      qml \
      svg \
      sensors

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

SOURCES += src/main.cpp \
    src/Bunker.cpp \
    src/Helper.cpp \
    src/BunkerFactory.cpp \
    src/scoremodel.cpp

HEADERS += \
    src/Bunker.h \
    src/Helper.h \
    src/BunkerFactory.h \
    src/scoremodel.h \
    src/pgz_platform.h

exists("/usr/lib/qt5/qml/Sailfish/Silica/SilicaGridView.qml"): {

    target.path = /usr/bin
    message(SailfishOS build)
    DEFINES += MER_EDITION_SAILFISH
    #Tablet
    DEFINES += MER_PPI=330
    #Phone
    #DEFINES += MER_PPI=245

    MER_EDITION = sailfish

    # QML files and folders
    #qml.files = *.qml pages cover main.qml
    folder_01.target = ../share/harbour-pgz-galaxy-attack-hd/qml
    folder_01.path = /usr/share/harbour-pgz-galaxy-attack-hd

    # The .desktop file
    desktop.files = harbour-pgz-galaxy-attack-hd.desktop

    # Please do not modify the following line.
    #include(../sailfishapplication/sailfishapplication.pri)
 }

android {
    TARGET=galaxy-attack-hd
    DEFINES += AMAZON_DEVICE

    #Include the android audio library
    include(src/androidaudio/androidaudio.pri)
    INCLUDEPATH += android/jni/includes/
    LIBS += -L$$PWD/android/jni/libs/ -lAmazonGamesJni

    QT += multimedia \
          androidextras

    SOURCES += src/androidiap.cpp \
    src/gamecircleleaderboard.cpp

    HEADERS += src/androidiap.h \
    android/jni/includes/AchievementsClientInterface.h \
    android/jni/includes/AGSClientCommonInterface.h \
    android/jni/includes/GameCircleClientInterface.h \
    android/jni/includes/LeaderboardsClientInterface.h \
    android/jni/includes/PlayerClientInterface.h \
    android/jni/includes/WhispersyncClientInterface.h \
    src/gamecircleleaderboard.h
}

#Add native sound support for playbook
qnx {
    SOURCES += src/bbaudio/blackberryaudio.cpp \
               src/bbaudio/blackberrysoundeffect.cpp \
               src/scoreloop/scoreloop.cpp \
               src/gamepadcontroller.cpp

    HEADERS += src/bbaudio/blackberryaudio.h \
               src/bbaudio/blackberrysoundeffect.h \
               src/scoreloop/scoreloop.h \
               src/gamepadcontroller.h

    LIBS += -lstrm -lmmrndclient -lscoreloopcore -lcurl -lscreen
    DEFINES += SC_HAS_INITDATA=1
} else {
    SOURCES += src/nullgamecontroller.cpp
    HEADERS += src/nullgamecontroller.h
}

# Installation path
# target.path =

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    bar-descriptor.xml \
    bar-descriptor-pb.xml \
    android/AndroidManifest.xml \
    android/src/uk/co/piggz/galaxy_attack_hd/GalaxyAttackHDActivity.java \
    android/src/uk/co/piggz/galaxy_attack_hd/GalaxyAttackHDApplication.java \
    android/src/com/android/vending/billing/IInAppBillingService.aidl \
    android/src/uk/co/piggz/galaxy_attack_hd/GalaxyAttackUtils.java \
    galaxy-attack-512.png \
    galaxy-attack-480.png \
    galaxy-attack-128.png \
    galaxy-attack-124.png \
    android/assets/api_key.txt \
    android/ant.properties \
    rpm/harbour-pgz-galaxy-attack-hd.yaml \
    harbour-pgz-galaxy-attack-hd.desktop \
    harbour-pgz-galaxy-attack-hd.png

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_EXTRA_LIBS = \
        $$PWD/android/jni/libs/libAmazonGamesJni.so
}

DISTFILES += \
    rpm/harbour-pgz-galaxy-attack-hd.spec

