#!/bin/bash

echo "Changing ownership of /opt/emqx/etc/certs to emqx user..."
chown -R emqx:emqx /opt/emqx/etc/certs

#echo "Switching to emqx user to start the process..."
exec "$@"
