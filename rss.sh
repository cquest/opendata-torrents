#!/bin/bash

cat $3
cd /var/www/html/$1

for t in *.torrent
do
  d=$( stat $t -c %y | egrep -o '^.{16}' )
  d=$( date -d "$d UTC" -R )
  echo "<item>"
  echo "  <title>$t</title>"
  echo "  <pubDate>$d</pubDate>"
  echo "  <category>data</category><link>http://212.47.238.202/$1/$t</link>"
  echo "  <description>$t</description><comments>Source: $2, Licence Ouverte</comments>"
  echo "  <enclosure url='http://212.47.238.202/$1/$t' type='application/x-bittorrent' />"
  echo "</item>"
done
echo '</channel></rss>'
