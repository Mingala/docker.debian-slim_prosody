#!/bin/bash
# run Sasl service
/etc/init.d/saslauthd start
# run Prosody as prosody user in foreground
runuser -u prosody -- "prosody" "-F"
