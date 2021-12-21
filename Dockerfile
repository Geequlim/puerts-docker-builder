FROM ubuntu:20.04
ENV ENGINE="v8"
ENV CMAKE_OPTIONS=""
ENV ANDROID_NDK=/root/android-ndk-r21b
WORKDIR /root
VOLUME /root/puerts

RUN echo '' > /etc/apt/sources.list \
    && echo 'deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted' >> /etc/apt/sources.list \
    && echo 'deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted' >> /etc/apt/sources.list \
    && echo 'deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal universe' >> /etc/apt/sources.list \
    && echo 'deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates universe' >> /etc/apt/sources.list \
    && echo 'deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal multiverse' >> /etc/apt/sources.list \
    && echo 'deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates multiverse' >> /etc/apt/sources.list \
    && echo 'deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse' >> /etc/apt/sources.list \
    && echo 'deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted' >> /etc/apt/sources.list \
    && echo 'deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security universe' >> /etc/apt/sources.list \
    && echo 'deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security multiverse' >> /etc/apt/sources.list

# 安装基础依赖
RUN set -x; buildDeps='make wget unzip cmake nodejs' \
    && apt-get update && apt-get install -y $buildDeps

# 添加 Android NDK
ADD https://dl.google.com/android/repository/android-ndk-r21b-linux-x86_64.zip /root/ndk.zip
RUN unzip -q /root/ndk.zip && rm /root/ndk.zip

# 添加 V8 静态库
ADD https://github.com/Tencent/puerts/releases/download/V8_8.4.371.19_2021_10_29/v8_bin_8.4.371.19.tgz /roo/v8_bin.tgz

# 添加构建脚本
ADD scripts /root/scripts

CMD cd /root/puerts/unity/native_src \
    && tar -xzf /roo/v8_bin.tgz \
    && node /root/scripts/make_android.js $ENGINE $CMAKE_OPTIONS
