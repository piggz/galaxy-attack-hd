#include "androidiap.h"
#include <QDebug>

AndroidIAP *AndroidIAP::m_instance = 0;

AndroidIAP::AndroidIAP(QObject *parent) :
    QObject(parent)
{
    m_instance = this;
}

void AndroidIAP::purchaseItem(const QString &itemName)
{
    qDebug() << "calling jni purchaseItem";
    QAndroidJniObject::callStaticMethod<void>("uk/co/piggz/galaxy_attack_hd/GalaxyAttackHDActivity","purchaseItem", "(Ljava/lang/String;)V", QAndroidJniObject::fromString(itemName).object<jstring>());
}

int AndroidIAP::checkItemPurchased(const QString &itemName)
{
    qDebug() << "calling jni checkItemPurchased";
    return QAndroidJniObject::callStaticMethod<int>("uk/co/piggz/galaxy_attack_hd/GalaxyAttackHDActivity","checkItemPurchased", "(Ljava/lang/String;)I", QAndroidJniObject::fromString(itemName).object<jstring>());
}


