#ifndef HELPER_H
#define HELPER_H

#include <QObject>
#include <QSettings>
#include <QtWidgets/QGraphicsItem>

#if defined(MEEGO_EDITION_HARMATTAN) || defined(Q_OS_SYMBIAN)
#include <QtSystemInfo/QSystemDisplayInfo>
#endif

class QDeclarativeItem;

class Helper : public QObject
{
    Q_OBJECT
public:
    explicit Helper(QObject *parent = 0);

signals:

public slots:
    QString keyName(int keycode);

    QVariant getSetting(const QString &settingname, QVariant def);
    bool getBoolSetting(const QString &settingname, QVariant def);

    void setSetting(const QString& settingname, QVariant val);
    bool settingExists(const QString &settingname);
    //QVariant collidingItems(QDeclarativeItem *item, const QString& matchName) const;
    int mmToPixels(int mm);

private:
    QSettings settings;

#if defined(MEEGO_EDITION_HARMATTAN) || defined(Q_OS_SYMBIAN)
    QtMobility::QSystemDisplayInfo m_info;
#endif
    
#if defined(Q_OS_BLACKBERRY_TABLET)
#define mPPI 170
#elif defined(Q_OS_BLACKBERRY)
#define mPPI 320
#else    
#define mPPI 96
#endif
};

#endif // HELPER_H
