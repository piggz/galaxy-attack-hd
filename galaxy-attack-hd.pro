# Add more folders to ship with the application, here
folder_01.source = qml/galaxy-attack-hd
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

VERSION = 0.9.8
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
    src/scoremodel.cpp

HEADERS += \
    src/Bunker.h \
    src/Helper.h \
    src/BunkerFactory.h \
    src/scoremodel.h

android {
    #Include the android audio library
    include(androidaudio/androidaudio.pri)
    INCLUDEPATH += Scoreloop/include
    LIBS += -L$$PWD/Scoreloop/libraries/armeabi-v7a/ -lscoreloopcore

    QT += multimedia

    SOURCES += src/scoreloop/scoreloop.cpp
    HEADERS += src/scoreloop/scoreloop.h
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
    android/src/uk/co/piggz/pgz_spaceinvaders/MyApplication.java

ANDROID_EXTRA_LIBS = /home/piggz/sdks/Qt5.2.0rc1/5.2.0-rc1/android_armv7/plugins/sensors/libqtsensors_android.so \
/home/piggz/sdks/Qt5.2.0rc1/5.2.0-rc1/android_armv7/plugins/sensors/libqtsensors_generic.so \
/home/piggz/sdks/Qt5.2.0rc1/5.2.0-rc1/android_armv7/lib/libQt5Sensors.so \
/home/piggz/sdks/Qt5.2.0rc1/5.2.0-rc1/android_armv7/lib/libQt5Multimedia.so \
/home/piggz/projects/pgz-spaceinvaders-qt5/Scoreloop/libraries/armeabi-v7a/libscoreloopcore.so

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

