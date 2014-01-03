#include "blackberrysoundeffect.h"

#include <QDebug>
#include <errno.h>

extern int errno;

BlackberrySoundEffect::BlackberrySoundEffect(const QString &url, const QString &name)
{
  qDebug() << "BlackberrySoundEffect:" << url;
    m_url = url;
    initAudio(name);  
}

BlackberrySoundEffect::~BlackberrySoundEffect()
{
  deinitAudio();
}

void BlackberrySoundEffect::playSound()
{
    mmr_play(m_ctxt);  
}

void BlackberrySoundEffect::initAudio(const QString& name) 
{
        mode_t mode = S_IRUSR | S_IXUSR;
        m_connection = mmr_connect(NULL);
        
        if (!m_connection) {
          qDebug() << "Unable to connect to mmr:" << errno;
          return;
        }
        m_ctxt = mmr_context_create(m_connection, QString("InvadersAudioPlayer-%1").arg(name).toLocal8Bit().data(), 0, mode);
        
        if (!m_ctxt) {
          qDebug() << "Unable to create context:" << errno;
          return;
        }
        
        mmr_output_attach(m_ctxt, "audio:default", "audio");
        mmr_input_attach(m_ctxt, m_url.toLocal8Bit().data(), "track");
}

void BlackberrySoundEffect::deinitAudio() 
{
        mmr_stop(m_ctxt);
        mmr_input_detach(m_ctxt);
        mmr_context_destroy(m_ctxt);

        mmr_disconnect(m_connection);   
}   
