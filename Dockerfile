FROM ubuntu:18.04 as builder
RUN apt-get update && apt-get install -y \
        build-essential autoconf mercurial \
        libcups2-dev libfontconfig1-dev libasound2-dev \
        libx11-dev libxext-dev libxrender-dev libxrandr-dev libxtst-dev libxt-dev \
	zip unzip wget
RUN mkdir /javabuild \
  && cd /javabuild \
  && hg clone http://hg.openjdk.java.net/jdk/jdk \
  && mkdir /boot-jdk \
  && cd /boot-jdk \
  && wget https://download.java.net/java/GA/jdk14.0.2/205943a0976c4ed48cb16f1043c5c647/12/GPL/openjdk-14.0.2_linux-x64_bin.tar.gz \
  && tar -xzf openjdk-14.0.2_linux-x64_bin.tar.gz \
  && rm openjdk-14.0.2_linux-x64_bin.tar.gz \
  && cd /javabuild/jdk \
  && bash configure --enable-debug --with-boot-jdk=/boot-jdk/jdk-14.0.2 \
  && make images

FROM ubuntu:18.04 
COPY --from=builder /javabuild/jdk/build/linux-x86_64-server-fastdebug/images/jdk /opt/jdk-debug
