# docker.debian-slim_prosody
Docker image for Prosody server based on Debian Slim base.
* Components installed :
  * [Prosody](https://prosody.im/) (default install from Prosody repository)
  * [Cyrus Sasl](https://www.cyrusimap.org/sasl/) for Sasl authentification, only ldap component installed, modify Dockerfile for more
* Bind mounts on Docker :
	* /etc/prosody/certs/ folder to your certificates
  * /etc/prosody/prosody.cfg.lua to your Prosody config setup
  * /var/lib/prosody/ to make your Prosody data persistent (or other folder according to specific data-path in config file)
  * /usr/lib/sasl2/prosody.conf to your Sasl method config
  * /var/log/prosody/ folder to make your Prosody log persistent
  * /etc/saslauthd.conf for your Sasl authentification config
* default Ports used on Docker (customizable in Prosody config) :
  * 5222 and 5269 for Prosody C2S and S2S exchange
  * 5000 if using Prosody Jingle Proxy ([mod-proxy65](https://prosody.im/doc/modules/mod_proxy65))
