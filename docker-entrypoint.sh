#!/usr/bin/env bash
set -euo pipefail

export PORT="${PORT:-8080}"

# Make Apache listen on $PORT (Railway requirement)
if [ -f /etc/apache2/ports.conf ]; then
  sed -ri "s/^[# ]*Listen .*/Listen ${PORT}/" /etc/apache2/ports.conf
fi
if [ -f /etc/apache2/sites-available/000-default.conf ]; then
  sed -ri "s%<VirtualHost \\*:.*>%<VirtualHost *:${PORT}>%" /etc/apache2/sites-available/000-default.conf
fi

# Ensure writable data dirs (www-data = uid/gid 33 in this image)
mkdir -p /var/www/html/data /var/www/html/uploads
chown -R 33:33 /var/www/html/data /var/www/html/uploads
chmod -R 775 /var/www/html/data /var/www/html/uploads

# Quiet the FQDN warning
echo "ServerName ${ESPOCRM_SITE_URL:-localhost}" >> /etc/apache2/apache2.conf

exec apache2-foreground
