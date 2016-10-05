#!/bin/bash

# get TRANSMISSION_AUTH
. config.sh

cd /var/www/html/torrents/meteo-france/arpege/
for t in $( find ./ -name '*torrent' -cmin +900 )
do
  # delete torrent file from web site
  rm $t
done
cd -
./rss.sh torrents/meteo-france/arpege > /var/www/html/torrents/meteo-france/arpege/rss.xml


cd /var/lib/transmission-daemon/info/torrents
for t in $( find ./ -name '*torrent' -cmin +1440 )
do
  # get original file name
  torrent=$( echo $t | sed 's!.*\(mf-.*grib2\).*!\1!' )
  echo $torrent
  # get torrent number
  num=$( transmission-remote -n "$TRANSMISSION_AUTH" -l | grep "$torrent" | grep -o '^ *[0-9]*' )
  # remove torrent from transmission-daemon
  transmission-remote -n "$TRANSMISSION_AUTH" -t $num -r

  # delete data file
  rm /var/lib/transmission-daemon/downloads/$t
done


