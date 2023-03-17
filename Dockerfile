FROM debian:latest

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt -y install git openssl

RUN mkdir -p /ca/private

RUN git clone https://github.com/OpenVPN/easy-rsa.git /ca/easyrsa

WORKDIR /ca/easyrsa

RUN git checkout tags/v3.1.2

WORKDIR /

RUN apt -y clean autoclean

RUN apt -y autoremove --yes

RUN rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN rm /ca/easyrsa/easyrsa3/vars.example

RUN mkdir -p /ca/private/reqs ; mkdir -p /ca/private/private

ADD easyrsa_vars /ca/private/vars

ADD openssl-easyrsa.cnf /ca/private/openssl-easyrsa.cnf

ADD safessl-easyrsa.cnf /ca/private/safessl-easyrsa.cnf

VOLUME [ "/ca/private" ]

ENV EASYRSA=/ca/private

WORKDIR /ca

ENV PATH /ca/easyrsa/easyrsa3:/usr/local/sbin:$PATH

ENV EASYRSA_BATCH 1

CMD ["/bin/bash"]
