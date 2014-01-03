AndroidAudio

A set of classes to play simple audio files (wav) on an android device
using Qt and/or QML.

Current Version 
===============
0.2

History
=======
0.2 - Inital Release

TODO
====
Refactor somewhat to allow an arbritary number of channels, one per effect
Background music

Installation
============
Include androidaudio.pri in your project

Setup
=====
In your main.cpp file, have the following lines in appropriate places:

#ifdef Q_OS_ANDROID
#include <androidaudio.h>
#endif

#ifdef Q_OS_ANDROID
    AndroidAudio *androidAudio = AndroidAudio::instance();
    viewer->rootContext()->setContextProperty("AndroidAudio", androidAudio);
#else 

Use
===
In your QML file, in some startup function have:

AndroidAudio.registerSound("assets:/qml/project/sounds/file1.wav", "file1");
AndroidAudio.registerSound("assets:/qml/project/sounds/file2.wav", "file2");
AndroidAudio.registerSound("assets:/qml/project/sounds/file3.wav", "file3");

And to play a sound, call
AndroidAudio.playSound("name", false);

The second argument is a boolean which is to loop the sound.  Dont do this in the current version!

