#!/bin/sh
set -e

ASSETS_DIR=/opt/subversion/assets
HTTPD_CONF_DIR=/etc/subversion/httpd
DATA_DIR=/var/opt/subversion

echo "Initializing subversion environment..."

mkdir -p $HTTPD_CONF_DIR
mkdir -p $DATA_DIR/httpd/htdocs

# check if directory exists
if [ ! -f "$HTTPD_CONF_DIR/httpd.conf" ]; then
  echo "Copying httpd.conf ..."
  cp $ASSETS_DIR/httpd.conf $HTTPD_CONF_DIR
fi

if [ ! -d "$HTTPD_CONF_DIR/conf.d" ]; then
  echo "Copying httpd conf.d directory..."
  cp -avr /etc/httpd/conf.d $HTTPD_CONF_DIR
  echo "Copying subversion.conf file..."
  rm $HTTPD_CONF_DIR/conf.d/subversion.conf
  cp $ASSETS_DIR/subversion.conf $HTTPD_CONF_DIR/conf.d
fi

if [ ! -f "$HTTPD_CONF_DIR/users.conf" ]; then
  echo "Copying users.conf ..."
  cp $ASSETS_DIR/users.conf $HTTPD_CONF_DIR
fi

if [ ! -f "$HTTPD_CONF_DIR/authz.conf" ]; then
  echo "Copying authz.conf ..."
  cp $ASSETS_DIR/authz.conf $HTTPD_CONF_DIR
fi

if [ ! -f "$HTTPD_CONF_DIR/conf.d/mod_jk.conf" ]; then
  echo "Copying mod_jk.conf ..."
  cp $ASSETS_DIR/mod_jk.conf $HTTPD_CONF_DIR/conf.d
fi

if [ ! -f "$HTTPD_CONF_DIR/conf.d/workers.properties" ]; then
  echo "Copying workers.properties ..."
  cp $ASSETS_DIR/workers.properties $HTTPD_CONF_DIR/conf.d
fi

if [ ! -f "/etc/logrotate.d/.dockersync" ]; then
  echo "Copying default httpd logrotate conf file ..."
  touch /etc/logrotate.d/.dockersync
  cp -f $ASSETS_DIR/logrotate/logrotate.conf /etc/logrotate.conf
  mkdir -p $DATA_DIR/logrotate/logrotate.d
  cp $ASSETS_DIR/logrotate/httpd $DATA_DIR/logrotate/logrotate.d
fi

if [ ! -d "$DATA_DIR/repositories/bootstrap" ]; then
  echo "Copying a sample repository ..."
  mkdir -p $DATA_DIR/repositories/bootstrap
  cp -r $ASSETS_DIR/bootstrap/* $DATA_DIR/repositories/bootstrap
fi

if [ ! -d "$DATA_DIR/httpd/htdocs/static" ]; then
  echo "Copying static contents ..."
  mkdir -p $DATA_DIR/httpd/htdocs/static
  cp -r $ASSETS_DIR/static/* $DATA_DIR/httpd/htdocs/static
fi


if [ -f "/run/httpd/httpd.pid" ]; then
  rm /run/httpd/httpd.pid
fi

echo "Starting httpd service as foreground..."

/usr/sbin/httpd -k start -f $HTTPD_CONF_DIR/httpd.conf -DFOREGROUND

echo "HTTPD Services was started!"

exec "$@"
sleep 1s
#wait
