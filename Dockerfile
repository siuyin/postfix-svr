FROM phusion/baseimage:0.9.16
RUN apt-get update && apt-get install postfix wget swaks bsd-mailx libsasl2-modules postfix-pgsql opendkim postfix-policyd-spf-python cpio  nomarch pax  unrar unzip zip dovecot-pgsql dovecot-imapd dovecot-pop3d -y

# set environment so that vim and less work properly
ENV HOME=/root
ENV TERM=ansi

# set your mail server public IP here
ENV MAILSVR_IP=129.41.150.46
# set mailname -- needed for dovecot
ENV HOSTNAME=bm2.beyondbroadcast.com

ADD 10-config-mailname.sh /etc/my_init.d/
RUN chmod +x /etc/my_init.d/10-config-mailname.sh

# postfix
RUN mkdir -p /etc/service/postfix
ADD postfix/postmon.sh /etc/service/postfix/
ADD postfix/runsv-postfix /etc/service/postfix/run
RUN useradd -g mail -u 200 -d /home/mail -s /sbin/nologin mailreader
RUN mkdir -p /home/mail
RUN chown mailreader:mail /home/mail


# dovecot imap
RUN mkdir -p /etc/service/dovecot
ADD dovecot/runsv-dovecot /etc/service/dovecot/run

CMD ["/sbin/my_init"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

