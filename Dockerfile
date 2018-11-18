From php:7.2-apache

RUN apt-get update -y && \   
    apt-get install gawk -y && \
    apt-get install net-tools -y && \
    apt-get install sudo -y && \
    apt-get install nmap -y && \
    echo 'www-data ALL=(ALL) NOPASSWD: /usr/bin/nmap' >> /etc/sudoers
