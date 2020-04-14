From ubuntu:18.04

RUN apt update; apt upgrade -y; apt autoremove -y;

RUN apt install \
vim \
gnupg2 \
ca-certificates \
iptables \
openssh-server \
git \
python \
build-essential \
libssl-dev \
libffi-dev \
python-dev \
bzr \
net-tools \
openvpn \
iputils-ping \
bridge-utils \
psmisc \
-y

RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py

# 2020/04/10
ENV GO_VERSION="1.14.2"

RUN wget https://storage.googleapis.com/golang/go$GO_VERSION.linux-arm64.tar.gz
RUN tar -zxvf go$GO_VERSION.linux-arm64.tar.gz
RUN mv go /usr/local/

ENV GOPATH=/root/go
ENV PATH="/usr/local/go/bin:${PATH}"

RUN go get -u github.com/pritunl/pritunl-dns
RUN go get -u github.com/pritunl/pritunl-web

RUN ln -s ~/go/bin/pritunl-dns /usr/bin/pritunl-dns
RUN ln -s ~/go/bin/pritunl-web /usr/bin/pritunl-web

# 2020/04/10
ENV PRITUNL_VERSION="1.29.2395.63"

RUN wget https://github.com/pritunl/pritunl/archive/$PRITUNL_VERSION.tar.gz

RUN tar xf $PRITUNL_VERSION.tar.gz
WORKDIR pritunl-$PRITUNL_VERSION

RUN python setup.py build

RUN pip install -r requirements.txt
RUN python setup.py install
RUN mkdir /var/log/pritunl
RUN sed -i 's/\/var\/log\/pritunl.log/\/var\/log\/pritunl\/pritunl.log/g' /etc/pritunl.conf

