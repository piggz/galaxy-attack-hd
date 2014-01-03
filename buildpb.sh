#!/bin/sh
#Build script for blackberry playbook

#Enable the pb environment
source /home/piggz/sdks/bbndk-2.1.0/bbndk-env.sh
export PATH=$HOME/development/qnx/qt51/bin:$PATH
export DEBUG_TOKEN="$HOME/.rim/debugtokenpb.bar"
export STORE_PASS="scrumpyc4t"
export QT_INSTALL_LIBS=$HOME/development/qnx/qt51/lib
export QT_INSTALL_PLUGINS=$HOME/development/qnx/qt51/plugins
export QT_INSTALL_QML=$HOME/development/qnx/qt51/qml
export SRC_DIR=$HOME/projects/pgz-spaceinvaders-qt5/

#Do the build
mkdir ../build-pb
cd ../build-pb
which qmake
qmake ../pgz-spaceinvaders-qt5/pgz-spaceinvaders-qt5.pro
make

cp $SRC_DIR/bar-descriptor-pb.xml .

#Sign for debug
#blackberry-nativepackager -package pgz-spaceinvaders-qt5-pb.bar -devMode -debugToken $DEBUG_TOKEN bar-descriptor-pb.xml

#Sign for release
blackberry-nativepackager -package pgz-spaceinvaders-qt5-pb-090.bar -sign -storepass $STORE_PASS bar-descriptor-pb.xml

#blackberry-deploy -installApp -device 169.254.0.1 -password scrumpyc4t pgz-spaceinvaders-qt5-bb10.bar

