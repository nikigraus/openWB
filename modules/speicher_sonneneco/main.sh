#!/bin/bash

#Auslesen einer Sonnbenbatterie Eco 4.5 über die integrierte JSON-API des Batteriesystems
. /var/www/html/openWB/openwb.conf

speicherantwort=$(curl --connect-timeout 5 -s "$sonnenecoip:7979/rest/devices/battery")

speichersoc=$(echo $speicherantwort | jq '.M05' | sed 's/\..*$//')

speicherentladung=$(echo $speicherantwort | jq '.M34' | sed 's/\..*$//')

speicherladung=$(echo $speicherantwort | jq '.M35' |sed 's/\..*$//')

speicherwatt=$(echo "$speicherladung - $speicherentladung" | bc)

#wenn Batterie aus bzw. keine Antwort ersetze leeren Wert durch eine 0
ra='^-?[0-9]+$'

if ! [[ $speicherwatt =~ $ra ]] ; then
		  speicherwatt="0"
fi

echo $speicherwatt > /var/www/html/openWB/ramdisk/speicherleistung

if ! [[ $speichersoc =~ $ra ]] ; then
		  speichersoc="0"
fi

echo $speichersoc > /var/www/html/openWB/ramdisk/speichersoc

