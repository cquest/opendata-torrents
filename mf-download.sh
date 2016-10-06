#!/bin/bash

# get TRANSMISSION_AUTH
. config.sh

cd /var/lib/transmission-daemon/downloads/

d=`date +'%Y-%m-%dT'`
dd=`date +'%Y%m%d'`

# ARPEGE
for h in 00 06 12 18; do
for r in 00H12H 13H24H 25H36H 37H48H 49H60H 61H72H 73H84H 85H96H; do
for p in SP1 SP2 HP1 HP2; do
  f=mf-arpege-$d$h-$r-$p.grib2
  wget -nc -q -t 10 -c --retry-connrefused \
  "http://dcpc-nwp.meteo.fr/services/PS_GetCache_DCPCPreviNum?token=__5yLVTdr-sGeHoPitnFc7TZ6MhBcJxuSsoZp6y0leVHU__&model=ARPEGE&grid=0.1&package=$p&time=$r&referencetime=$d$h:00:00Z&format=grib2" -O $f
  err=$?
  if [ "$err" = "0" ]; then
  transmission-create -t http://212.47.238.202:6969/announce $f

  transmission-remote -n "$TRANSMISSION_AUTH" -a $f.torrent
  chmod a+r $f.torrent
  mv $f.torrent /var/www/html/torrents/meteo-france/arpege
  elif [ "$err" = "1" ]; then
    sleep 0
  else
    rm -f $f
  fi
done
done
done

cd /var/www/html/torrents/
transmission-remote -n "$TRANSMISSION_AUTH" -l > status.txt
transmission-remote -n "$TRANSMISSION_AUTH" -st >> status.txt
curl -s http://localhost:6969/stats >> status.txt

exit

# AROME_0.01_SP1_00H_201610011800.grib2
for p in HP1 SP1 SP2 SP3; do
for h in 00 03 06 12 18; do
for e in 00H 01H 02H 03H 04H 05H 06H 07H 08H 09H 10H 11H 12H 13H 14H 15H 16H 17H 18H 19H 20H 21H 22H 23H 24H 25H 26H 27H 28H 29H 30H 31H 32H 33H 34H 35H 36H 37H 38H 39H 40H 41H 42H; do
  f=mf-AROME-0.01-$dd$h-$e-$p.grib2
  wget -nc -q -t 10 -c --retry-connrefused \
  "http://dcpc-nwp.meteo.fr/services/PS_GetCache_DCPCPreviNum?token=__5yLVTdr-sGeHoPitnFc7TZ6MhBcJxuSsoZp6y0leVHU__&model=AROME&grid=0.01&package=$p&time=$e&referencetime=$d$h:00:00Z&format=grib2" -O $f
  err=$?
  if [ "$err" = "0" ]; then
  transmission-create -t http://212.47.238.202:6969/announce $f
   # -t udp://tracker.opentrackr.org:1337
   # -t http://tracker.openbittorrent.com:80/announce
   # -t udp://tracker.openbittorrent.com:80/announce

  transmission-remote -n "$TRANSMISSION_AUTH" -a $f.torrent
  chmod a+r $f.torrent
  mv $f.torrent /var/www/html/torrents/meteo-france/arome
  elif [ "$err" = "1" ]; then
    sleep 0
  else
    rm -f $f
  fi
done
done
done
