#!/bin/bash

cd $ANDROID_HOME

echo "*** Install Android Emulator ***"
if [ "$TARGETARCH" = "arm64" ]; then
  apt-get install -y libc6-amd64-cross libgcc1-amd64-cross
  ln -s /usr/x86_64-linux-gnu/lib64/ /lib64
  wget -q https://redirector.gvt1.com/edgedl/android/repository/emulator-linux_x64-8420304.zip -O emulator-linux.zip
  unzip emulator-linux.zip
  rm emulator-linux.zip
  mv /opt/license/package.xml $ANDROID_HOME/emulator
else
  sdkmanager "emulator"
fi
