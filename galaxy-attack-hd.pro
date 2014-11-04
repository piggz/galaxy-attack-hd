# Add more folders to ship with the application, here
folder_01.source = qml/galaxy-attack-hd
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

VERSION = 0.9.9.5
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
      quick \
      widgets \
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
    src/scoremodel.cpp \
    src/gamecircleleaderboard.cpp


HEADERS += \
    src/Bunker.h \
    src/Helper.h \
    src/BunkerFactory.h \
    src/scoremodel.h \
    src/pgz_platform.h \
    android/jni/includes/AchievementsClientInterface.h \
    android/jni/includes/AGSClientCommonInterface.h \
    android/jni/includes/GameCircleClientInterface.h \
    android/jni/includes/LeaderboardsClientInterface.h \
    android/jni/includes/PlayerClientInterface.h \
    android/jni/includes/WhispersyncClientInterface.h \
    src/gamecircleleaderboard.h

!android {
!qnx
 {
     message(SailfishOS build)

     DEFINES += MER_EDITION_SAILFISH
     MER_EDITION = sailfish
}
}

android {
    #Include the android audio library
    include(src/androidaudio/androidaudio.pri)
    INCLUDEPATH += android/jni/includes/
    LIBS += -L$$PWD/android/jni/libs/ -lAmazonGamesJni

    QT += multimedia \
          androidextras

    SOURCES += src/androidiap.cpp
    HEADERS += src/androidiap.h
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
    qml/galaxy-attack-hd/PGZDialog.qml \
    android/src/com/android/vending/billing/IInAppBillingService.aidl \
    android/src/com/nokia/payment/iap/aidl/INokiaIAPService.aidl \
    android/src/uk/co/piggz/galaxy_attack_hd/GalaxyAttackUtils.java \
    android/src/uk/co/piggz/galaxy_attack_hd/PaymentService.java \
    galaxy-attack-hd.desktop \
    galaxy-attack-512.png \
    galaxy-attack-480.png \
    galaxy-attack-128.png \
    galaxy-attack-124.png \
    galaxy-attack-86.png  \
    rpm/galaxy-attack-hd.yaml \
    rpm/galaxy-attack-hd.spec \
    android/libs/libAmazonGamesJni.so \
    android/assets/api_key.txt \
    android/ant.properties


#ANDROID_EXTRA_LIBS = /home/piggz/sdks/Qt5.2.1/5.2.1/android_armv7/plugins/sensors/libqtsensors_android.so \
#/home/piggz/sdks/Qt5.2.1/5.2.1/android_armv7/plugins/sensors/libqtsensors_generic.so \
#/home/piggz/sdks/Qt5.2.1/5.2.1/android_armv7/lib/libQt5Sensors.so \
#/home/piggz/sdks/Qt5.2.1/5.2.1/android_armv7/lib/libQt5Multimedia.so

ANDROID_EXTRA_LIBS = /home/piggz/projects/galaxy-attack-hd/android/jni/libs/libAmazonGamesJni.so

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

