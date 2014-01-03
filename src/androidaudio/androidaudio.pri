
QT += core

INCLUDEPATH += $$PWD

SOURCES += $$PWD/androidaudio.cpp \
	    $$PWD/androidsoundeffect.cpp

HEADERS += $$PWD/androidaudio.h \
	    $$PWD/androidsoundeffect.h

INCLUDEPATH += $$PWD

LIBS += -lOpenSLES -landroid
