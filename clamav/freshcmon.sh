#!/bin/sh
/etc/init.d/clamav-freshclam start
ps ax|grep -v grep|grep /usr/bin/freshclam
RC=$?
while [ $RC -eq 0 ]; do
  sleep 600 
  ps ax|grep -v grep|grep /usr/bin/freshclam
  RC=$?
done
