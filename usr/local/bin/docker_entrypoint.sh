#!/bin/bash
# run Sasl service
/etc/init.d/saslauthd start
# run Prosody as prosody user in foreground
usermod -u "$(stat -c %u /var/lib/prosody/.)" prosody
runuser -u prosody -- "prosody" "-F"
