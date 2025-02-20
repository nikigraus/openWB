#!/bin/bash
#set -e

#####
#
# File: regel.sh
#
# Copyright 2018 Kevin Wieland, David Meder-Marouelli
#
#  This file is part of openWB.
#
#     openWB is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
#
#     openWB is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with openWB.  If not, see <https://www.gnu.org/licenses/>.
#
#####

set -o pipefail
cd /var/www/html/openWB/
#config file einlesen
. openwb.conf
source minundpv.sh
source nurpv.sh
source auslademodus.sh
source sofortlademodus.sh
source goecheck.sh
source loadvars.sh
source graphing.sh
source nachtladen.sh
source zielladen.sh
source evsedintest.sh
source hook.sh
source u1p3p.sh
source nrgkickcheck.sh
source rfidtag.sh
source leds.sh
date=$(date)
re='^-?[0-9]+$'
#ladelog ausfuehren
./ladelog.sh &
#doppelte Ausfuehrungsgeschwindigkeit
if [[ $dspeed == "1" ]]; then
	if [ -e ramdisk/5sec ]; then
		sleep 5 && ./regel.sh >> /var/log/openWB.log 2>&1 &
		rm ramdisk/5sec
	else
		echo 0 > ramdisk/5sec
	fi
fi
if [[ $dspeed == "2" ]]; then

	if [ -e ramdisk/5sec ]; then
		rm ramdisk/5sec
		exit 0
	else
		echo 0 > ramdisk/5sec
	fi
fi
updateinprogress=$(<ramdisk/updateinprogress)
if (( updateinprogress == "1" )); then
	echo "Update in progress"
	exit 0
fi

graphtimer=$(<ramdisk/graphtimer)
if (( graphtimer < 4 )); then
	graphtimer=$((graphtimer+1))
	echo $graphtimer > ramdisk/graphtimer
else
	graphtimer=0
	echo $graphtimer > ramdisk/graphtimer
fi
#######################################

if (( displayaktiv == 1 )); then
	execdisplay=$(<ramdisk/execdisplay)
	if (( execdisplay == 1 )); then
	        export DISPLAY=:0 && xset s $displaysleep
	        echo 0 > ramdisk/execdisplay
	fi
fi


#######################################
# check rfid
if [[ $rfidakt == "1" ]]; then
	rfid
fi
#goe mobility check
goecheck
# nrgkick mobility check
nrgkickcheck
#load charging vars
loadvars

if (( u1p3paktiv == 1 )); then
	blockall=$(<ramdisk/blockall)
	if (( blockall == 1 )); then
		if [[ $debug == "1" ]]; then
			echo "Phasen Umschaltung noch aktiv... beende"
		fi
		exit 0
	fi
fi


#EVSE DIN Modbus test
evsedintest

#u1p3p switch
u1p3pswitch
#hooks - externe geraete
hook
#Graphing
graphing

if (( cpunterbrechunglp1 == 1 )); then
       if (( plugstat == 1 )); then
               if (( llalt > 5 )); then
                       if (( ladeleistung < 200 )); then
                               cpulp1waraktiv=$(<ramdisk/cpulp1waraktiv)
                               if (( cpulp1waraktiv == 0 )); then
				       echo "CP Unterbrechung an LP1 durchgeführt"
                                       sudo python runs/cpulp1.py
                                       echo 1 > ramdisk/cpulp1waraktiv
                               fi
                       else
                               echo 0 > ramdisk/cpulp1waraktiv
                       fi
               fi
       else
               echo 0 > ramdisk/cpulp1waraktiv
       fi
fi
if [[ $dspeed == "3" ]]; then

	if [ -e ramdisk/5sec ]; then
		regeltimer=$(<ramdisk/5sec)
		if (( regeltimer < 5 )); then
			regeltimer=$((regeltimer+1))
			echo $regeltimer > ramdisk/5sec
			exit 0
		else
			regeltimer=0
			echo $regeltimer > ramdisk/5sec
		fi
	else
		echo 0 > ramdisk/5sec
	fi
fi

if (( ledsakt == 1 )); then
	ledsteuerung
fi
#evse modbus check
evsemodbustimer=$(<ramdisk/evsemodbustimer)
if (( evsemodbustimer < 30 )); then
	evsemodbustimer=$((evsemodbustimer+1))
	echo $evsemodbustimer > ramdisk/evsemodbustimer
else
	evsemodbustimer=0
	echo $evsemodbustimer > ramdisk/evsemodbustimer
	evsemodbuscheck
fi
#Lademodus 3 == Aus

if (( lademodus == 3 )); then
	auslademodus
fi

#loadsharing check
if [[ $loadsharinglp12 == "1" ]]; then
	if (( loadsharingalp12 == 16 )); then
		agrenze=8
		aagrenze=16
		if (( current > 16 )); then
			current=16
		fi
	else
		agrenze=16
		aagrenze=32
	fi
	tcurrent=$(( llalt + llalts1 ))
	if (( tcurrent > aagrenze )); then
		#detect charging cars
		if (( lla1 > 1 )); then
			lp1c=1
			if (( lla2 > 1 )); then
				lp1c=2
			fi
		else
			lp1c=0
		fi
		if (( llas11 > 1 )); then
			lp2c=1
			if (( llas12 > 1 )); then
				lp2c=2
			fi
		else
			lp2c=0
		fi
		chargingphases=$(( lp1c + lp2c ))
		if (( chargingphases > 2 )); then
			runs/set-current.sh "$agrenze" all
			echo "$date Alle Ladepunkte, Loadsharing LP1-LP2 aktiv. Setze Ladestromstärke auf $agrenze" >> ramdisk/ladestatus.log
			exit 0
		fi
	fi
fi


#########################################
#Regelautomatiken

if (( zielladenaktivlp1 == 1 )); then
	ziellademodus
fi
####################
# Nachtladung bzw. Ladung bis SOC x% nachts von x bis x Uhr

prenachtlademodus

########################
# Sofort Laden
if (( lademodus == 0 )); then
	sofortlademodus	
fi

#######################
#Ladestromstarke berechnen
anzahlphasen=$(</var/www/html/openWB/ramdisk/anzahlphasen)
if (( anzahlphasen > 9 )); then
	anzahlphasen=1
fi
llphasentest=3
#Anzahl genutzter Phasen ermitteln, wenn ladestrom kleiner 3 (nicht vorhanden) nutze den letzten bekannten wert
if (( llalt > 3 )); then
	anzahlphasen=0
	if [ $lla1 -ge $llphasentest ]; then
		anzahlphasen=$((anzahlphasen + 1 ))
	fi
	if [ $lla2 -ge $llphasentest ]; then
  	anzahlphasen=$((anzahlphasen + 1 ))
	fi
	if [ $lla3 -ge $llphasentest ]; then
		anzahlphasen=$((anzahlphasen + 1 ))
	fi
	echo $anzahlphasen > /var/www/html/openWB/ramdisk/anzahlphasen
else
	if [ ! -f /var/www/html/openWB/ramdisk/anzahlphasen ]; then
  	echo 1 > /var/www/html/openWB/ramdisk/anzahlphasen
	fi
	if (( u1p3paktiv == 1 )); then
		anzahlphasen=$(cat /var/www/html/openWB/ramdisk/u1p3pstat)
	else
		anzahlphasen=$(cat /var/www/html/openWB/ramdisk/anzahlphasen)

	fi
fi
if (( lastmanagement == 1 )); then
	if (( llas11 > 3 )); then
		if [ "$llas11" -ge $llphasentest ]; then
			anzahlphasen=$((anzahlphasen + 1 ))
		fi
		if [ "$llas12" -ge $llphasentest ]; then
	  	anzahlphasen=$((anzahlphasen + 1 ))
		fi
		if [ "$llas13" -ge $llphasentest ]; then
			anzahlphasen=$((anzahlphasen + 1 ))
		fi

		echo $anzahlphasen > /var/www/html/openWB/ramdisk/anzahlphasen
	fi
fi
if (( lastmanagements2 == 1 )); then
	if (( llas21 > 3 )); then
		if [ "$llas21" -ge $llphasentest ]; then
			anzahlphasen=$((anzahlphasen + 1 ))
		fi
		if [ "$llas22" -ge $llphasentest ]; then
	  	anzahlphasen=$((anzahlphasen + 1 ))
		fi
		if [ "$llas23" -ge $llphasentest ]; then
			anzahlphasen=$((anzahlphasen + 1 ))
		fi
		echo $anzahlphasen > /var/www/html/openWB/ramdisk/anzahlphasen
	fi
fi
if [ $anzahlphasen -eq 0 ]; then
	anzahlphasen=1
fi
########################
# Berechnung für PV Regelung
mindestuberschussphasen=$(echo "($mindestuberschuss*$anzahlphasen)" | bc)
wattkombiniert=$(echo "($ladeleistung+$uberschuss)" | bc)
abschaltungw=$(echo "(($abschaltuberschuss-1320)*-1*$anzahlphasen)" | bc)
#PV Regelmodus
if [[ $pvbezugeinspeisung == "0" ]]; then
	pvregelungm="0"
        schaltschwelle=$(echo "(230*$anzahlphasen)" | bc)
fi
if [[ $pvbezugeinspeisung == "1" ]]; then
	pvregelungm=$(echo "(230*$anzahlphasen*-1)" | bc)
	schaltschwelle="0"
fi
if [[ $pvbezugeinspeisung == "2" ]]; then
	pvregelungm=$offsetpv
	schaltschwelle=$((schaltschwelle + offsetpv))
fi
# Debug Ausgaben
if [[ $debug == "1" ]]; then
	echo anzahlphasen "$anzahlphasen"
fi
if [[ $debug == "2" ]]; then
	echo "$date"
	echo "uberschuss" $uberschuss "wattbezug" $wattbezug "ladestatus" $ladestatus "llsoll" $llalt "pvwatt" $pvwatt "mindestuberschussphasen" $mindestuberschussphasen "wattkombiniert" $wattkombiniert "abschaltungw" $abschaltungw "schaltschwelle" $schaltschwelle
fi
########################
#Min Ladung + PV Uberschussregelung lademodus 1
if (( lademodus == 1 )); then
	minundpvlademodus
fi
########################
#NUR PV Uberschussregelung lademodus 2
# wenn evse aus und $mindestuberschuss vorhanden, starte evse mit 6A Ladestromstaerke (1320 - 3960 Watt je nach Anzahl Phasen)
if (( lademodus == 2 )); then
	nurpvlademodus
fi



#Lademodus 4 == SemiAus

if (( lademodus == 4 )); then
	semiauslademodus
fi
