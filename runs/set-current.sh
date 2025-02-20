#!/bin/bash

#####
#
# File: set-current.sh
#
# Copyright 2018 David Meder-Marouelli, Kevin Wieland
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

# set charging current in EVSE
#
# Parameters:
# 1: current
# 2: charging points, one of "all","m","s1","s2"
#
# Example: ./set-current.sh 9 s1
# sets charging current on point "s1" to 9A

. /var/www/html/openWB/openwb.conf

#####
#
# functions
# 
#####
# function for setting the current - dac
# Parameters:
# 1: current
# 2: dacregister
function setChargingCurrentDAC () {
	current=$1
	dacregister=$2
	# set desired charging current 
	# INFO: needs new dac.py to accept current and use translation table 
	sudo python /var/www/html/openWB/runs/dac.py $current $dacregister
}

# function for setting the current - modbusevse
# Parameters:
# 1: current
# 2: modbusevseresource
# 3: modbusevseid
function setChargingCurrentModbus () {
	current=$1
	modbusevsesource=$2
	modbusevseid=$3
	# set desired charging current
	sudo python /var/www/html/openWB/runs/evsewritemodbus.py $modbusevsesource $modbusevseid $current
}


# function for openwb slave kit
function setChargingCurrentSlaveeth () {
	current=$1
	# set desired charging current
	sudo python /var/www/html/openWB/runs/evseslavewritemodbus.py $current
}
function setChargingCurrentMasterethframer () {
	current=$1
	# set desired charging current
	sudo python /var/www/html/openWB/runs/evsemasterethframerwritemodbus.py $current
}
# function for openwb third kit
function setChargingCurrentThirdeth () {
	current=$1
	# set desired charging current
	sudo python /var/www/html/openWB/runs/evsethirdwritemodbus.py $current
}

# function for setting the current - WiFi
# Parameters:
# 1: current
# 2: evsewifitimeoutlp1 
# 3: evsewifiiplp1
function setChargingCurrentWifi () {
	if [[ $evsecon == "simpleevsewifi" ]]; then
		if [[ $current -eq 0 ]]; then
			output=$(curl --connect-timeout $evsewifitimeoutlp1 -s http://$evsewifiiplp1/getParameters)
			state=$(echo $output | jq '.list[] | .evseState')
			if ((state == true)) ; then
				curl --silent --connect-timeout $evsewifitimeoutlp1 -s http://$evsewifiiplp1/setStatus?active=false > /dev/null
			fi
		else
			output=$(curl --connect-timeout $evsewifitimeoutlp1 -s http://$evsewifiiplp1/getParameters)
			state=$(echo $output | jq '.list[] | .evseState')
			if ((state == false)) ; then
				curl --silent --connect-timeout $evsewifitimeoutlp1 -s http://$evsewifiiplp1/setStatus?active=true > /dev/null
			fi
			oldcurrent=$(echo $output | jq '.list[] | .actualCurrent')
			if (( oldcurrent != $current )) ; then
				curl --silent --connect-timeout $evsewifitimeoutlp1 -s http://$evsewifiiplp1/setCurrent?current=$current > /dev/null
			fi
		fi
	fi
}
# function for setting the current - go-e charger
# Parameters:
# 1: current
# 2: goetimeoutlp1 
# 3: goeiplp1
function setChargingCurrentgoe () {
	if [[ $evsecon == "goe" ]]; then
		if [[ $current -eq 0 ]]; then
			output=$(curl --connect-timeout $goetimeoutlp1 -s http://$goeiplp1/status)
			state=$(echo $output | jq -r '.alw')
			if ((state == "1")) ; then
				curl --silent --connect-timeout $goetimeoutlp1 -s http://$goeiplp1/mqtt?payload=alw=0 > /dev/null
			fi
		else
			output=$(curl --connect-timeout $goetimeoutlp1 -s http://$goeiplp1/status)
			state=$(echo $output | jq -r '.alw')
			if ((state == "0")) ; then
				 curl --silent --connect-timeout $goetimeoutlp1 -s http://$goeiplp1/mqtt?payload=alw=1 > /dev/null
			fi
			oldcurrent=$(echo $output | jq -r '.amp')
			if (( oldcurrent != $current )) ; then
				curl --silent --connect-timeout $goetimeoutlp1 -s http://$goeiplp1/mqtt?payload=amp=$current > /dev/null
			fi
		fi
	fi
}
# function for setting the current - keba charger
# Parameters:
# 1: current
# 2: goeiplp1
function setChargingCurrentkeba () {
	if [[ $evsecon == "keba" ]]; then
		kebacurr=$(( current * 1000 ))
		if [[ $current -eq 0 ]]; then
			echo -n "ena 0" | socat - UDP-DATAGRAM:$kebaiplp1:7090
		else
			echo -n "ena 1" | socat - UDP-DATAGRAM:$kebaiplp1:7090
			echo -n "curr $kebacurr" | socat - UDP-DATAGRAM:$kebaiplp1:7090	
			echo -n "display 1 10 10 0 S$current" | socat - UDP-DATAGRAM:$kebaiplp1:7090	
		fi
	fi
}


function setChargingCurrentnrgkick () {
	if [[ $evsecon == "nrgkick" ]]; then
		if [[ $current -eq 0 ]]; then
			output=$(curl --connect-timeout 3 -s http://$nrgkickiplp1/api/settings/$nrgkickmaclp1)
			state=$(echo $output | jq -r '.Values.ChargingStatus.Charging')
			if [[ $state == "false" ]] ; then
				curl --connect-timeout 2 -s -X PUT -H "Content-Type: application/json" --data "{ "Values": {"ChargingStatus": { "Charging": false }, "ChargingCurrent": { "Value": "6" }, "DeviceMetadata":{"Password": $nrgkickpwlp1}}}" $nrgkickiplp1/api/settings/$nrgkickmaclp1 > /dev/null
			fi
		else
			output=$(curl --connect-timeout 3 -s http://$nrgkickiplp1/api/settings/$nrgkickmaclp1)
			state=$(echo $output | jq -r '.Values.ChargingStatus.Charging')
			if [[ $state == "false" ]] ; then
				 curl --connect-timeout 2 -s -X PUT -H "Content-Type: application/json" --data "{ "Values": {"ChargingStatus": { "Charging": true }, "ChargingCurrent": { "Value": $current }, "DeviceMetadata":{"Password": $nrgkickpwlp1}}}" $nrgkickiplp1/api/settings/$nrgkickmaclp1 > /dev/null
			fi
			oldcurrent=$(echo $output | jq -r '.Values.ChargingCurrent.Value')
			if (( oldcurrent != $current )) ; then
				curl --silent --connect-timeout $nrgkicktimeoutlp1 -s -X PUT -H "Content-Type: application/json" --data "{ "Values": {"ChargingStatus": { "Charging": true }, "ChargingCurrent": { "Value": $current}, "DeviceMetadata":{"Password": $nrgkickpwlp1}}}" $nrgkickiplp1/api/settings/$nrgkickmaclp1 > /dev/null
 > /dev/null
			fi
		fi
	fi
}






# function for setting the charging current
# no parameters, variables need to be set before...
function setChargingCurrent () {
	if [[ $evsecon == "dac" ]]; then
		setChargingCurrentDAC $current $dacregister
	fi

	if [[ $evsecon == "modbusevse" ]]; then
		setChargingCurrentModbus $current $modbusevsesource $modbusevseid 
	fi

	if [[ $evsecon == "simpleevsewifi" ]]; then
		setChargingCurrentWifi $current $evsewifitimeoutlp1 $evsewifiiplp1
	fi
	if [[ $evsecon == "goe" ]]; then
		setChargingCurrentgoe $current $goetimeoutlp1 $goeiplp1
	fi
	if [[ $evsecon == "slaveeth" ]]; then
		setChargingCurrentSlaveeth $current 
	fi
	if [[ $evsecon == "thirdeth" ]]; then
		setChargingCurrentThirdeth $current 
	fi

	if [[ $evsecon == "masterethframer" ]]; then
		setChargingCurrentMasterethframer $current 
	fi
	if [[ $evsecon == "nrgkick" ]]; then
		setChargingCurrentnrgkick $current $nrgkicktimeoutlp1 $nrgkickiplp1 $nrgkickmaclp1 $nrgkickpwlp1
	fi
	if [[ $evsecon == "keba" ]]; then
		setChargingCurrentkeba $current $kebaiplp1
	fi
}

#####
#
# main routine 
#
#####

# input validation
let current=$1
if [[ current -lt 0 ]] | [[ current -gt 32 ]]; then 
	if [[ $debug == "2" ]]; then 
		echo "ungültiger Wert für Ladestrom" > /var/www/html/openWB/web/lade.log
	fi
	exit 1
fi

if !([[ $2 == "all" ]] || [[ $2 == "m" ]] || [[ $2 == "s1" ]] || [[ $2 == "s2" ]]) ; then
	if [[ $debug == "2" ]]; then
		echo "ungültiger Wert für Ziel: $2" > /var/www/html/openWB/web/lade.log
	fi
	exit 1
fi

# value below threshold
if [[ current -lt 6 ]]; then 
	if [[ $debug == "2" ]]; then 
		echo "Ladestrom < 6A, setze auf 0A"
	fi
	current=0
	lstate=0
else
	lstate=1
fi 

# set desired charging current 

if [[ $debug == "2" ]]; then
	echo "setze ladung auf $current" >> /var/www/html/openWB/web/lade.log
fi

# Loadsharing LP 1 / 2
if [[ $loadsharinglp12 == "1" ]]; then
	if (( loadsharingalp12 == 16 )); then
		agrenze=8
		aagrenze=16
		if (( current > 16 )); then
			current=16
			new2=all
		fi
	else
		agrenze=16
		aagrenze=32
	fi
	if (( current > agrenze )); then
		lla1=$(cat /var/www/html/openWB/ramdisk/lla1)
		lla2=$(cat /var/www/html/openWB/ramdisk/lla2)
		lla3=$(cat /var/www/html/openWB/ramdisk/lla3)
		lla1=$(echo $lla1 | sed 's/\..*$//')
		lla2=$(echo $lla2 | sed 's/\..*$//')
		lla3=$(echo $lla3 | sed 's/\..*$//')
		llas11=$(cat /var/www/html/openWB/ramdisk/llas11)
		llas12=$(cat /var/www/html/openWB/ramdisk/llas12)
		llas13=$(cat /var/www/html/openWB/ramdisk/llas13)
		llas11=$(echo $llas11 | sed 's/\..*$//')
		llas12=$(echo $llas12 | sed 's/\..*$//')
		llas13=$(echo $llas13 | sed 's/\..*$//')
		lslpl1=$((lla1 + llas12))
		lslpl2=$((lla2 + llas13))
		lslpl3=$((lla3 + llas11))
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
			current=$agrenze
		fi
		if (( lslpl1 > aagrenze )) && (( lslpl2 > aagrenze )) && (( lslpl3 > aagrenze )); then
			current=$(( agrenze - 1))
			new2=all
			if [[ $debug == "2" ]]; then
			echo "setzeladung auf $current durch loadsharing LP12" >> /var/www/html/openWB/web/lade.log
			fi
		fi
	fi
fi


if ! [ -z $new2 ]; then
	points=$new2
else
	points=$2
fi

# set charging current - first charging point
if [[ $points == "all" ]] || [[ $points == "m" ]]; then
	setChargingCurrent
	echo $current > /var/www/html/openWB/ramdisk/llsoll
	echo $lstate > /var/www/html/openWB/ramdisk/ladestatus
fi

# set charging current - second charging point
if [[ $lastmanagement == "1" ]]; then
	if [[ $points == "all" ]] || [[ $points == "s1" ]]; then
		evsecon=$evsecons1
		dacregister=$dacregisters1
		modbusevsesource=$evsesources1
		modbusevseid=$evseids1
		evsewifitimeoutlp1=$evsewifitimeoutlp2
		evsewifiiplp1=$evsewifiiplp2
		goeiplp1=$goeiplp2
		goetimeoutlp1=$goetimeoutlp2
		kebaiplp1=$kebaiplp2
		nrgkickiplp1=$nrgkickiplp2
		nrgkicktimeoutlp1=$nrgkicktimeoutlp2
		nrgkickmaclp1=$nrgkickmaclp2
		nrgkickpwlp1=$nrgkickpwlp2
		# dirty call (no parameters, all is set above...)
		setChargingCurrent

		echo $current > /var/www/html/openWB/ramdisk/llsolls1
		echo $lstate > /var/www/html/openWB/ramdisk/ladestatuss1
	fi
fi

# set charging current - third charging point
if [[ $lastmanagements2 == "1" ]]; then
	if [[ $points == "all" ]] || [[ $points == "s2" ]]; then 
		evsecon=$evsecons2
		dacregister=$dacregisters2
		modbusevsesource=$evsesources2
		modbusevseid=$evseids2
		evsewifitimeoutlp1=$evsewifitimeoutlp3
		evsewifiiplp1=$evsewifiiplp3
		goeiplp1=$goeiplp3
		goetimeoutlp1=$goetimeoutlp3

		# dirty call (no parameters, all is set above...)
		setChargingCurrent

		echo $current > /var/www/html/openWB/ramdisk/llsolls2
		echo $lstate > /var/www/html/openWB/ramdisk/ladestatuss2
	fi
fi
