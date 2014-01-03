#ifndef BLACKBERRYAUDIO_H
#define BLACKBERRYAUDIO_H

#include <QObject>
#include <QMap>
#include "blackberrysoundeffect.h"

class BlackberryAudio : public QObject
{
    Q_OBJECT
public:
    explicit BlackberryAudio(QObject *parent = 0);
    ~BlackberryAudio();

signals:

public slots:
    void registerSound(const QString& path, const QString &name);
    void playSound(const QString& name, bool loop = false);
    
private:
    QMap<QString, BlackberrySoundEffect*> mSounds;
};

#endif // BLACKBERRYAUDIO_H
 
