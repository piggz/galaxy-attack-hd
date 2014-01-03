#ifndef ANDROIDAUDIO_H
#define ANDROIDAUDIO_H

#include <QObject>
#include <QMap>

#include "androidsoundeffect.h"

// for native audio
#include <jni.h>
#include <SLES/OpenSLES.h>
#include <SLES/OpenSLES_Android.h>
#include <android/asset_manager.h>
#include <android/asset_manager_jni.h>

class AndroidAudio : public QObject
{
    Q_OBJECT
public:
    static AndroidAudio* instance();
    ~AndroidAudio();

signals:

public slots:

    void registerSound(const QString& path, const QString &name);
    void playSound(const QString& name, bool loop);

    void bufferPlayerCallback(SLBufferQueueItf bq, void *context);

private:
    explicit AndroidAudio();
    static AndroidAudio* m_instance;

    void createEngine();
    void destroyEngine();
    void startSoundPlayer();

    // engine interfaces
    SLObjectItf mEngineObject;
    SLEngineItf mEngineEngine;

    // output mix interfaces
    SLObjectItf mOutputMixObject;

    // Buffer Player 1
    SLObjectItf mPlayerObject1;
    SLPlayItf mPlayerPlay1;
    SLBufferQueueItf mPlayerQueue1;

    // Buffer Player 2
    SLObjectItf mPlayerObject2;
    SLPlayItf mPlayerPlay2;
    SLBufferQueueItf mPlayerQueue2;

    QMap<QString, AndroidSoundEffect*> mSounds;
    int32_t mSoundCount;
    bool m_loopLastSound;
    QString m_lastSound;

};

#endif // ANDROIDAUDIO_H
