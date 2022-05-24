FROM debian:testing

RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ testing main non-free contrib" > /etc/apt/sources.list
RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ testing-updates main non-free contrib" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian-security/ testing-security main non-free contrib" >> /etc/apt/sources.list

RUN apt-get update -y 
RUN apt-get install -y libterm-readkey-perl user-mode-linux libslirp-helper -y
RUN apt-get -y install apt-utils xz-utils dosfstools --fix-missing

RUN apt-get install debos -y --fix-missing

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends vim ssh ssh-import-id git tree \
    debian-keyring gpgv network-manager host curl bmap-tools --fix-missing

# add credentials on build
ARG SSH_PRIVATE_KEY
RUN mkdir /root/.ssh/
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa && chmod 600 /root/.ssh/id_rsa
RUN touch /root/.ssh/known_hosts

ENV USER=root \
    HOME=/root
