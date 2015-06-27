FROM phusion/baseimage:0.9.16
RUN apt-get update
RUN apt-get install postfix wget swaks bsd-mailx libsasl2-modules postfix-pgsql amavisd-new spamassassin clamav-daemon opendkim postfix-policyd-spf-python pyzor razor arj cabextract cpio  nomarch pax  unrar unzip zip dovecot-pgsql dovecot-imapd dovecot-pop3d -y

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

# spamassassin
RUN adduser clamav amavis && adduser amavis clamav
RUN sed -e 's/ENABLED=0/ENABLED=1/;s/CRON=0/CRON=1/' /etc/default/spamassassin > /tmp/spamassassin && mv /tmp/spamassassin /etc/default/spamassassin
RUN mkdir -p /etc/service/spamassassin
ADD spamass/spammon.sh /etc/service/spamassassin/
ADD spamass/runsv-spamassassin /etc/service/spamassassin/run
ADD 10-config-spamassassin.sh /etc/my_init.d/
RUN chmod +x /etc/my_init.d/10-config-spamassassin.sh
#  only set RDNS_NONE 0 if you do not have a trusted networks line above 
#RUN echo "score RDNS_NONE 0" >> /etc/spamassassin/local.cf

# amavisd-new
RUN sed -e's/#@bypass/@bypass/;s/#   \\%bypass/   \\%bypass/' /etc/amavis/conf.d/15-content_filter_mode > /tmp/amavis && mv /tmp/amavis /etc/amavis/conf.d/15-content_filter_mode
ADD amavis/amavismon.sh /etc/service/amavis/
ADD amavis/runsv-amavis /etc/service/amavis/run

# clamav clamd
RUN mkdir -p /etc/service/clamd
ADD clamav/clammon.sh /etc/service/clamd/
ADD clamav/runsv-clamd /etc/service/clamd/run

# clamav freshclam
RUN mkdir -p /etc/service/freshclam
ADD clamav/freshcmon.sh /etc/service/freshclam/
ADD clamav/runsv-freshclam /etc/service/freshclam/run

# dovecot imap
RUN mkdir -p /etc/service/dovecot
ADD dovecot/runsv-dovecot /etc/service/dovecot/run

CMD ["/sbin/my_init"]

# Clean up APT when done.
#RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

