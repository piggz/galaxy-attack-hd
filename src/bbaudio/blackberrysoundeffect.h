#ifndef BLACKBERRYSOUNDEFFECT_H
#define BLACKBERRYSOUNDEFFECT_H

#include <QObject>
#include <QMap>

#include <QTimer>
#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>
#include <sys/stat.h>
#include <mm/renderer.h>
#include <QFileInfo>
#include <sys/platform.h>
#include <bps/bps.h>


class BlackberrySoundEffect
{
public:
    explicit BlackberrySoundEffect(const QString& url, const QString &name);
    ~BlackberrySoundEffect();

signals:

public slots:
    void playSound();
    
private:

    mmr_context_t *m_ctxt;
    mmr_connection_t *m_connection;
    QString m_url;
    
    void initAudio(const QString &name);
    void deinitAudio();
    
};

#endif // BLACKBERRYSOUNDEFFECT_H
 
 
