#!/bin/sh
/etc/init.d/clamav-daemon start
ps ax|grep -v grep|grep /usr/sbin/clamd
RC=$?
while [ $RC -eq 0 ]; do
  sleep 600 
  ps ax|grep -v grep|grep /usr/sbin/clamd
  RC=$?
done
