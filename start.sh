#!/bin/bash

# Start dbus service to allow scanimage to work properly
service dbus start

# start cups service
service cupsd start

# Run brscan-skey (in background)
/opt/brother/scanner/brscan-skey/brscan-skey

# Run google-cloud-print
if [ -n "$GCPCONFIG" ]; then
        echo "$GCPCONFIG" > /root/gcp-cups-connector.config.json
        service avahi-daemon start
        service cups start
        cd /root
        exec su -l -s /bin/sh -c "/usr/bin/gcp-cups-connector -config-filename /root/gcp-cups-connector.config.json" root &
fi;

# start avahi-daemon service
service avahi-daemon start


# start samba service
service smbd start

# just be sure of it...
service avahi-daemon restart
service smbd restart

# Run scanservjs
cd /var/www/scanservjs/
/var/www/scanservjs/server.js

#echo "starting 'tail -f /dev/null' to keep container hanging"
#tail -f /dev/null
