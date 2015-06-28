#!/bin/sh
echo "trusted_networks $MAILSVR_IP" >> /etc/spamassassin/local.cf 
sed -i -e's/--max-children\s\+[0-9]\+/--max-children 1/' /etc/default/spamassassin

