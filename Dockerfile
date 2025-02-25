FROM ubuntu:22.04

LABEL Description="Docker container for running a custom Mario 35 Server"
LABEL Original-Server-Implementation="https://github.com/kinnay/SMB35"
LABEL SMB35-Continued-Interest="https://smb35server.com/emulator"

LABEL org.opencontainers.image.source https://github.com/royaltongue/smb35server-docker

ARG DEBIAN_FRONTEND=noninteractive

ENV PUID=1049 \
    GUID=1049 \
    SERVER_ADDRESS=smb35server.com

EXPOSE 20000 20001 20002

WORKDIR /app

RUN apt update && \
    apt install -y makepasswd
RUN apt-get install git -y && \
    apt install python3.11 -y && \
    apt install python3-pip -y

RUN pip3 install nintendoclients

RUN groupadd -g ${GUID} smb35servergroup
RUN useradd -u  ${PUID} smb35serveruser
RUN smb35serverpassword="$(makepasswd --chars 20)" && echo 'smb35serveruser:'${smb35serverpassword} | chpasswd
RUN su smb35serveruser

RUN cd /app
RUN git clone https://github.com/kinnay/SMB35.git

RUN mkdir /app/SMB35/source/resources
RUN openssl genrsa > /app/SMB35/source/resources/privkey.pem
RUN openssl req -new -x509 -subj /C=US/ST=NY/L=NY/O=SMB35/OU=SMB35/CN=localhost -key  /app/SMB35/source/resources/privkey.pem >  /app/SMB35/source/resources/fullchain.pem

WORKDIR /app/SMB35/source
CMD [ "python3", "main.py"]