From ubuntu:latest

RUN apt update; apt upgrade -y; apt autoremove -y;

RUN apt install \
vim \
gnupg2 \
ca-certificates \
iptables \
openssh-server \
-y

RUN echo 'deb https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse' > /etc/apt/sources.list.d/mongodb-org-4.0.list
RUN echo 'deb http://repo.pritunl.com/stable/apt bionic main' > /etc/apt/sources.list.d/pritunl.list

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
RUN apt update

RUN apt install pritunl mongodb-server -y
RUN sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongodb.conf

RUN mkdir /var/log/pritunl
RUN sed -i 's/\/var\/log\/pritunl.log/\/var\/log\/pritunl\/pritunl.log/g' /etc/pritunl.conf
