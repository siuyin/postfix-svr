#!/bin/sh
echo "trusted_networks $MAILSVR_IP" >> /etc/spamassassin/local.cf 
sed -i -e's/--max-children\s\+[0-9]\+/--max-children 1/' /etc/default/spamassassin
sed -i -e'/Do not modify anything below this line/i$max_servers = 1;' /etc/amavis/conf.d/50-user

