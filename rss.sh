#!/bin/bash

cat rss.xml
cd /var/www/html/$1

for t in *.torrent
do
  echo "<item>"
  echo "  <title>$t</title><guid isPermaLink='true'>http://212.47.238.202/$1/$t</guid>"
  echo "  <pubDate>Mon, 03 Oct 2016 11:35:38 +0200</pubDate>"
  echo "  <category>data</category><link>http://212.47.238.202/$1/$t</link>"
  echo "  <description>$t</description><comments>Source: Météo-France, Licence Ouverte</comments>"
  echo "  <enclosure url='http://212.47.238.202/$1/$t' type='application/x-bittorrent' />"
  echo "</item>"
done
echo '</channel></rss>'
