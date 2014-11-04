#include "Helper.h"
#include <QtWidgets/QApplication>
#include <QDebug>
#include <QtWidgets/QGraphicsItem>
#include <QMetaEnum>

#if defined(Q_OS_ANDROID) || defined(MER_EDITION_SAILFISH)
#include <QScreen>
#endif
class StaticQtMetaObject : public QObject
{
public:
    static inline const QMetaObject& get() {return staticQtMetaObject;}
};

Helper::Helper(QObject *parent) :
    QObject(parent)
{
}

QString Helper::keyName(int keycode)
{
    int index = StaticQtMetaObject::get().indexOfEnumerator("Key");
    QMetaEnum metaEnum = StaticQtMetaObject::get().enumerator( index);
    QString keyString = metaEnum.valueToKey( keycode );
    return keyString.replace("Key_","");
    return QString();
}


QVariant Helper::getSetting(const QString &settingname, QVariant def)
{
    return settings.value("settings/" + settingname, def);
}

bool Helper::getBoolSetting(const QString &settingname, QVariant def)
{
    return getSetting(settingname, def).toBool();
}

    
void Helper::setSetting(const QString &settingname, QVariant val)
{
    settings.setValue("settings/" + settingname, val);
    settings.sync();
}

bool Helper::settingExists(const QString &settingname)
{
    return settings.contains("settings/" + settingname);
}

int Helper::mmToPixels(int mm)
{
#if defined(MEEGO_EDITION_HARMATTAN) || defined(Q_OS_SYMBIAN)
    qDebug() << "Screen 0 DPI is " << m_info.getDPIWidth(0);
    return (mm*m_info.getDPIWidth(0)) / 25.4;
#elif defined(Q_OS_ANDROID) || defined(MER_EDITION_SAILFISH)
    //qDebug() << "Converting " << mm << " to " << (mm*QGuiApplication::primaryScreen()->physicalDotsPerInch()) / 25.4;
    //qDebug() << "PhysicalDPI is" << QGuiApplication::primaryScreen()->physicalDotsPerInch() << "Physical Size" << QGuiApplication::primaryScreen()->physicalSize() << "LogicalDDPI" << QGuiApplication::primaryScreen()->logicalDotsPerInch();
    return (mm*QGuiApplication::primaryScreen()->physicalDotsPerInch()) / 25.4;
#else
    return (mm*mPPI) / 25.4;
#endif
}
