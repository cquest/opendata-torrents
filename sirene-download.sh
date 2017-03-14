#!/bin/bash

# get TRANSMISSION_AUTH
. config.sh

cd /var/lib/transmission-daemon/downloads/

mkdir -p /var/www/html/torrents/insee/sirene

d=`date +'%Y-%m-%dT'`
dd=`date +'%Y%m%d'`

files=$( curl -s https://www.data.gouv.fr/fr/datasets/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret/ | grep -o http.*zip | grep -v '{' | sort -u )
# SIRENE
for url in $files; do
  f=$(echo $url | sed 's!http://files.data.gouv.fr/sirene/!!')
  if [ ! -f $f ]; then
    wget -nc -q -t 10 -c --retry-connrefused $url
    err=$?
    if [ "$err" = "0" ]; then
      # vérification zip
      zip -T $f
      err=$?
    fi
    if [ "$err" = "0" ]; then
      transmission-create -t http://212.47.238.202:6969/announce $f

      transmission-remote -n "$TRANSMISSION_AUTH" -a $f.torrent
      chmod a+r $f.torrent
      mv $f.torrent /var/www/html/torrents/insee/sirene
    elif [ "$err" = "1" ]; then
      sleep 0
    else
      rm -f $f
    fi
  fi
done
cd - > /dev/null

cd /var/www/html/torrents/
transmission-remote -n "$TRANSMISSION_AUTH" -l > status.txt
transmission-remote -n "$TRANSMISSION_AUTH" -st >> status.txt
curl -s http://localhost:6969/stats >> status.txt
cd - > /dev/null

./rss.sh torrents/insee/sirene > /var/www/html/torrents/insee/sirene/sirene_rss.xml "INSEE" rss-sirene.xml
