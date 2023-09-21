FROM ubuntu:22.04

ARG TARGETARCH
ARG JDK_VERSION=17
ARG PLATFORM_VERSION=android-34
ARG BUILD_TOOLS_VERSION=34.0.0-rc3
ARG NDK_VERSION=25.1.8937393
ARG CMAKE_VERSION=3.22.1

ENV ANDROID_HOME    /opt/android-sdk

ENV PATH "${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin"
ENV PATH "${PATH}:${ANDROID_HOME}/cmdline-tools/tools/bin"
ENV PATH "${PATH}:${ANDROID_HOME}/tools/bin"
ENV PATH "${PATH}:${ANDROID_HOME}/build-tools/${BUILD_TOOLS_VERSION}"
ENV PATH "${PATH}:${ANDROID_HOME}/platform-tools"
ENV PATH "${PATH}:${ANDROID_HOME}/bin"

RUN apt-get update \
 && apt-get install -y openjdk-${JDK_VERSION}-jdk wget unzip git build-essential python3.10 python3-pip npm zip

RUN npm install -g n
RUN n stable

COPY tools /opt/tools
COPY license /opt/license
RUN chmod +x /opt/tools/*.sh
RUN sed -i -e 's/\r$//' /opt/tools/*.sh

RUN mkdir -p $ANDROID_HOME
RUN chmod -R 777 $ANDROID_HOME

# Install Android Commandline-Tools
RUN /opt/tools/cmdline_tools.sh

RUN cd $ANDROID_HOME
RUN yes | sdkmanager --licenses

# RUN sdkmanager "cmdline-tools;latest"
RUN sdkmanager "platforms;${PLATFORM_VERSION}"
RUN sdkmanager "platform-tools"

RUN sdkmanager "build-tools;${BUILD_TOOLS_VERSION}"
RUN sdkmanager "ndk;${NDK_VERSION}"
RUN sdkmanager "cmake;${CMAKE_VERSION}"

RUN python3 -m pip install argparse
RUN python3 -m pip install pycryptodome