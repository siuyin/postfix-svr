#!/bin/sh
/etc/init.d/amavis start
ps ax|grep -v grep|grep 'amavisd-new'
RC=$?
while [ $RC -eq 0 ]; do
  sleep 600 
  ps ax|grep -v grep|grep 'amavisd-new'
  RC=$?
done
