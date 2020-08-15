FROM i386/ubuntu:19.10

LABEL MAINTAINER="Xannor Archouse <xannor@users.noreply.github.com>"

ENV TOOLCHAIN_VERSION 8.2-2018.08
ENV TOOLCHAIN_DOWNLOAD https://developer.arm.com/-/media/Files/downloads/gnu-a/${TOOLCHAIN_VERSION}/gcc-arm-${TOOLCHAIN_VERSION}-x86_64-arm-linux-gnueabihf.tar.xz
ENV TOOLCHAIN_DOWNLOAD_SHA256 5b3f20e1327edc3073e545a5bd3d15f33e7f94181ff4e37a76e95924c1b439b9

################# Install packages ################

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -qq install -y software-properties-common \
        language-pack-en-base sudo supervisor git build-essential xz-utils unzip p7zip-full mtd-tools binwalk \
        rsync autoconf bison flex yui-compressor libxml2-utils zlib1g-dev libssl-dev

################# Install packages ################

COPY files/root /

################ Section SSH ################
RUN apt-get update && \
    apt-get install -y openssh-server && \
    mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"

RUN echo "export VISIBLE=now" >> /etc/profile
################ End SSH ################

################ Section cross-compiling ################
RUN wget -q -O toolchain.tar.xz "${TOOLCHAIN_DOWNLOAD}" \
  && echo "${TOOLCHAIN_DOWNLOAD_SHA256} toolchain.tar.xz" | sha256sum -c - \
  && tar -C /opt/yi/ -xvJf toolchain.tar.xz \
  && rm toolchain.tar.xz
#RUN tar xfvJ /opt/yi/gcc-arm-8.2-2018.08-x86_64-arm-linux-gnueabihf.tar.xz -C /opt/yi/
################ End cross-compiling ################

################ Section jefferson ################
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -qq install -y python-pip python-lzma
RUN pip install cstruct && cd /tmp/ && git clone https://github.com/sviehb/jefferson && (cd jefferson && sudo python setup.py install)
################ End jefferson ################

################ Section kernel. Issue #1 ################
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -qq install -y bc cpio
RUN dpkg --add-architecture amd64 && apt update && DEBIAN_FRONTEND=noninteractive apt-get -qq install -y libc6:amd64
################ End kernel ################

ENV TERM xterm
ENV ON_ENTRY_SCRIPT=$ON_ENTRY_SCRIPT

RUN mkdir -p /root/.ssh/ /yi-hack-src/

VOLUME  ["/yi-hack-src"]
VOLUME  ["/root/.ssh/"]

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
