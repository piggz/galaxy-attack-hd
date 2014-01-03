#include "androidaudio.h"
#include "androidsoundeffect.h"

#include <QDebug>

AndroidAudio* AndroidAudio::m_instance = 0;

void staticBufferPlayerCallback(SLBufferQueueItf bq, void *context)
{
    qDebug() << "AndroidAudio::staticBufferPlayerCallback";
    AndroidAudio::instance()->bufferPlayerCallback(bq, context);
}

AndroidAudio* AndroidAudio::instance()
{
    if (!m_instance) {
        m_instance = new AndroidAudio();
    }

    return m_instance;
}

AndroidAudio::AndroidAudio() :
    QObject(0), mEngineObject(NULL), mEngineEngine(NULL), mOutputMixObject(NULL), mSounds(), mSoundCount(0), mPlayerObject1(NULL)
{
    createEngine();
    startSoundPlayer();
}

AndroidAudio::~AndroidAudio()
{
    destroyEngine();

    for (int32_t i = 0; i < mSoundCount; ++i) {
        qDeleteAll(mSounds);
    }
}

// create the engine and output mix objects
void AndroidAudio::createEngine()
{
    SLresult result;

    // create engine
    result = slCreateEngine(&mEngineObject, 0, NULL, 0, NULL, NULL);
    Q_ASSERT(SL_RESULT_SUCCESS == result);

    // realize the engine
    result = (*mEngineObject)->Realize(mEngineObject, SL_BOOLEAN_FALSE);
    Q_ASSERT(SL_RESULT_SUCCESS == result);

    // get the engine interface, which is needed in order to create other objects
    result = (*mEngineObject)->GetInterface(mEngineObject, SL_IID_ENGINE, &mEngineEngine);
    Q_ASSERT(SL_RESULT_SUCCESS == result);

    // create output mix
    const SLInterfaceID ids[] = {};
    const SLboolean req[] = {};
    result = (*mEngineEngine)->CreateOutputMix(mEngineEngine, &mOutputMixObject, 0, ids, req);
    Q_ASSERT(SL_RESULT_SUCCESS == result);

    // realize the output mix
    result = (*mOutputMixObject)->Realize(mOutputMixObject, SL_BOOLEAN_FALSE);
    Q_ASSERT(SL_RESULT_SUCCESS == result);  

    qDebug() << "Created Android Audio Engine";
}

void AndroidAudio::destroyEngine()
{
    if (mOutputMixObject != NULL) {
        (*mOutputMixObject)->Destroy(mOutputMixObject);
    }

    if (mEngineObject != NULL) {
        (*mEngineObject)->Destroy(mEngineObject);
    }

    if (mPlayerObject1 != NULL) {
        (*mPlayerObject1)->Destroy(mPlayerObject1);
    }

    for (int32_t i = 0; i < mSoundCount; ++i) {
        mSounds.values().at(i)->unload();
    }

    qDebug() << "Destroyed Android Audio Engine";
}

void AndroidAudio::registerSound(const QString& path, const QString& name)
{
    qDebug() << "registerSound:" << path << name;
    AndroidSoundEffect *lSound = new AndroidSoundEffect(path, this);
    qDebug() << "registerSound:created";
    mSounds[name] = lSound;

    qDebug() << "registerSound:loading";
    lSound->load();
    qDebug() << "registerSound:loaded";
}

void AndroidAudio::startSoundPlayer()
{
    qDebug() << "Starting Sound Player";

    SLresult lRes;

    //Configure the sound player input/output
    SLDataLocator_AndroidSimpleBufferQueue lDataLocatorIn;
    lDataLocatorIn.locatorType = SL_DATALOCATOR_BUFFERQUEUE;
    lDataLocatorIn.numBuffers = 1;

    //Set the data format as mono-pcm-16bit-44100
    SLDataFormat_PCM lDataFormat;
    lDataFormat.formatType = SL_DATAFORMAT_PCM;
    lDataFormat.numChannels = 2;
    lDataFormat.samplesPerSec = SL_SAMPLINGRATE_44_1;
    lDataFormat.bitsPerSample = SL_PCMSAMPLEFORMAT_FIXED_16;
    lDataFormat.containerSize = SL_PCMSAMPLEFORMAT_FIXED_16;
    lDataFormat.channelMask = SL_SPEAKER_FRONT_LEFT | SL_SPEAKER_FRONT_RIGHT;
    lDataFormat.endianness = SL_BYTEORDER_LITTLEENDIAN;

    SLDataSource lDataSource;
    lDataSource.pLocator = &lDataLocatorIn;
    lDataSource.pFormat = &lDataFormat;

    SLDataLocator_OutputMix lDataLocatorOut;
    lDataLocatorOut.locatorType = SL_DATALOCATOR_OUTPUTMIX;
    lDataLocatorOut.outputMix = mOutputMixObject;

    SLDataSink lDataSink;
    lDataSink.pLocator = &lDataLocatorOut;
    lDataSink.pFormat = NULL;

    //Create the sound player
    const SLuint32 lSoundPlayerIIDCount = 2;
    const SLInterfaceID lSoundPlayerIIDs[] = { SL_IID_PLAY, SL_IID_BUFFERQUEUE };
    const SLboolean lSoundPlayerReqs[] = { SL_BOOLEAN_TRUE, SL_BOOLEAN_TRUE };

    qDebug() << "Creating buffer player 1";

    lRes = (*mEngineEngine)->CreateAudioPlayer(mEngineEngine, &mPlayerObject1, &lDataSource, &lDataSink, lSoundPlayerIIDCount, lSoundPlayerIIDs, lSoundPlayerReqs);
    Q_ASSERT(SL_RESULT_SUCCESS == lRes);
    lRes = (*mPlayerObject1)->Realize(mPlayerObject1, SL_BOOLEAN_FALSE);
    Q_ASSERT(SL_RESULT_SUCCESS == lRes);
    lRes = (*mPlayerObject1)->GetInterface(mPlayerObject1, SL_IID_PLAY, &mPlayerPlay1);
    Q_ASSERT(SL_RESULT_SUCCESS == lRes);
    lRes = (*mPlayerObject1)->GetInterface(mPlayerObject1, SL_IID_BUFFERQUEUE, &mPlayerQueue1);
    Q_ASSERT(SL_RESULT_SUCCESS == lRes);
    lRes = (*mPlayerPlay1)->SetPlayState(mPlayerPlay1, SL_PLAYSTATE_PLAYING);
    Q_ASSERT(SL_RESULT_SUCCESS == lRes);

    qDebug() << "Created buffer player 1";

    qDebug() << "Creating buffer player 2";

    lRes = (*mEngineEngine)->CreateAudioPlayer(mEngineEngine, &mPlayerObject2, &lDataSource, &lDataSink, lSoundPlayerIIDCount, lSoundPlayerIIDs, lSoundPlayerReqs);
    Q_ASSERT(SL_RESULT_SUCCESS == lRes);
    lRes = (*mPlayerObject1)->Realize(mPlayerObject2, SL_BOOLEAN_FALSE);
    Q_ASSERT(SL_RESULT_SUCCESS == lRes);
    lRes = (*mPlayerObject1)->GetInterface(mPlayerObject2, SL_IID_PLAY, &mPlayerPlay2);
    Q_ASSERT(SL_RESULT_SUCCESS == lRes);
    lRes = (*mPlayerObject1)->GetInterface(mPlayerObject2, SL_IID_BUFFERQUEUE, &mPlayerQueue2);
    Q_ASSERT(SL_RESULT_SUCCESS == lRes);
    lRes = (*mPlayerPlay2)->SetPlayState(mPlayerPlay2, SL_PLAYSTATE_PLAYING);
    Q_ASSERT(SL_RESULT_SUCCESS == lRes);

    qDebug() << "Created buffer player 2";

}

void AndroidAudio::playSound(const QString& name, bool loop)
{
    SLresult lRes;
    SLuint32 lPlayerObjState;
    SLBufferQueueState lBufferState;

    m_lastSound = name;
    m_loopLastSound = loop;

    AndroidSoundEffect* sound = mSounds[name];

    if (!sound) {
        qDebug() << "No such sound:" << name;
        return;
    }
    //Get the current state of the player
    (*mPlayerObject1)->GetState(mPlayerObject1, &lPlayerObjState);
    (*mPlayerQueue1)->GetState(mPlayerQueue1, &lBufferState);

    //If the player is realised and not playing
    if (lPlayerObjState == SL_OBJECT_STATE_REALIZED && lBufferState.count == 0) {
        //Get the buffer and length of the effect
        int16_t* lBuffer = (int16_t *)sound->mBuffer;
        off_t lLength = sound->mLength;

        //Remove any sound from the queue
        lRes = (*mPlayerQueue1)->Clear(mPlayerQueue1);
        Q_ASSERT(SL_RESULT_SUCCESS == lRes);

        //Play the new sound
        (*mPlayerQueue1)->Enqueue(mPlayerQueue1, lBuffer, lLength);
        Q_ASSERT(SL_RESULT_SUCCESS == lRes);
        return;
    }

    //If we get this far, then the first player was busy, so try the second
    //Get the current state of the player
    (*mPlayerObject2)->GetState(mPlayerObject2, &lPlayerObjState);
    (*mPlayerQueue2)->GetState(mPlayerQueue2, &lBufferState);

    //If the player is realised and not playing
    if (lPlayerObjState == SL_OBJECT_STATE_REALIZED && lBufferState.count == 0) {
        //Get the buffer and length of the effect
        int16_t* lBuffer = (int16_t *)sound->mBuffer;
        off_t lLength = sound->mLength;

        //Remove any sound from the queue
        lRes = (*mPlayerQueue2)->Clear(mPlayerQueue2);
        Q_ASSERT(SL_RESULT_SUCCESS == lRes);

        //Play the new sound
        (*mPlayerQueue2)->Enqueue(mPlayerQueue2, lBuffer, lLength);
        Q_ASSERT(SL_RESULT_SUCCESS == lRes);
    }

}

void AndroidAudio::bufferPlayerCallback(SLBufferQueueItf bq, void *context)
{
    qDebug() << "AndroidAudio::bufferPlayerCallback";
    if (m_loopLastSound) {
        playSound(m_lastSound, m_loopLastSound);
    }
}
