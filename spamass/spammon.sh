#!/bin/sh
/etc/init.d/spamassassin start
ps ax|grep -v grep|grep /usr/sbin/spamd
RC=$?
while [ $RC -eq 0 ]; do
  sleep 600 
  ps ax|grep -v grep|grep /usr/sbin/spamd
  RC=$?
done
