FROM ubuntu:22.04

LABEL Description="Docker container for running a custom Mario 35 Server"
LABEL Original-Server-Implementation="https://github.com/kinnay/SMB35"
LABEL SMB35-Continued-Interest="https://smb35server.com"

LABEL org.opencontainers.image.source="https://github.com/royaltongue/smb35server-docker"

ARG DEBIAN_FRONTEND=noninteractive

ENV PUID=1000 \
    GUID=1000 \
    DOMAIN_NAME=smb35server.com

VOLUME /app/SMB35/source/resources

EXPOSE 20000 20001 20002

WORKDIR /app

RUN apt update && \
    apt install -y makepasswd && \
    apt install -y curl
RUN apt-get install git -y && \
    apt install python3.11 -y && \
    apt install python3-pip -y  

RUN snap install --classic certbot

RUN groupadd -g ${GUID} smb35servergroup
RUN useradd -u  ${PUID} smb35serveruser
RUN smb35serverpassword="$(makepasswd --chars 20)" && echo 'smb35serveruser:'${smb35serverpassword} | chpasswd

COPY docker-entrypoint.sh /app
RUN chown ${PUID}:${GUID} /app/docker-entrypoint.sh
RUN su smb35serveruser

RUN cd /app
RUN git clone https://github.com/kinnay/SMB35.git
RUN pip3 install nintendoclients

RUN mkdir SMB35/source/resources
RUN cd SMB35/source/resources

RUN rm /app/SMB35/source/dashboard.py
COPY dashboard.py /app/SMB35/source/dashboard.py
COPY dashboard.html /app/SMB35/source/dashboard.html

RUN curl -O /app/SMB35/source/resources/chain.pem https://letsencrypt.org/certs/2024/e5.pem

CMD [ "bash", "/app/docker-entrypoint.sh"]