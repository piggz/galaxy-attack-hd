#include "blackberryaudio.h"

BlackberryAudio::BlackberryAudio(QObject *parent) : QObject(parent)
{
}

BlackberryAudio::~BlackberryAudio()
{
  
}

void BlackberryAudio::registerSound(const QString &path, const QString &name)
{
    char cwd[PATH_MAX];
    char input_url[PATH_MAX];
        
    getcwd(cwd, PATH_MAX);
    snprintf(input_url, PATH_MAX, "file://%s%s%s", cwd, "/app/native/", path.toLocal8Bit().data());
        
    BlackberrySoundEffect *lSound = new BlackberrySoundEffect(input_url, name);
    mSounds[name] = lSound;
}
    
void BlackberryAudio::playSound(const QString &sound, bool loop)
{
  BlackberrySoundEffect *effect = mSounds[sound];
  
  if (effect){
    effect->playSound();
  } 
}
