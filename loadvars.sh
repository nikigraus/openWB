#!/bin/bash
loadvars(){

#get oldvars for mqtt
opvwatt=$(<ramdisk/pvwatt)
owattbezug=$(<ramdisk/wattbezug)
ollaktuell=$(<ramdisk/llaktuell)
ohausverbrauch=$(<ramdisk/hausverbrauch)
ollkombiniert=$(<ramdisk/llkombiniert)
ollaktuells1=$(<ramdisk/llaktuells1)
ollaktuells2=$(<ramdisk/llaktuells2)
ospeicherleistung=$(<ramdisk/speicherleistung)
oladestatus=$(<ramdisk/mqttlastladestatus)
olademodus=$(<ramdisk/mqttlastlademodus)
osoc=$(<ramdisk/soc)
osoc1=$(<ramdisk/soc1)
ospeichersoc=$(<ramdisk/speichersoc)
oplugstat=$(<ramdisk/mqttlastplugstat)
ochargestat=$(<ramdisk/mqttlastchargestat)
oplugstats1=$(<ramdisk/mqttlastplugstats1)
ochargestats1=$(<ramdisk/mqttlastchargestats1)
ladestatus=$(</var/www/html/openWB/ramdisk/ladestatus)
# EVSE DIN Plug State
if [[ $evsecon == "modbusevse" ]]; then
	evseplugstate=$(sudo python runs/readmodbus.py $modbusevsesource $modbusevseid 1002 1)
	if [ "$evseplugstate" -ge "0" ] && [ "$evseplugstate" -le "10" ] ; then
		if [[ $evseplugstate > "1" ]]; then
			plugstat=$(</var/www/html/openWB/ramdisk/plugstat)
			if [[ $plugstat == "0" ]] && [[ $pushbplug == "1" ]] && [[ $ladestatus == "0" ]] && [[ $pushbenachrichtigung == "1" ]] ; then
				message="Fahrzeug eingesteckt. Ladung startet bei erfüllter Ladebedingung automatisch."
				/var/www/html/openWB/runs/pushover.sh "$message"
			fi
				echo 1 > /var/www/html/openWB/ramdisk/plugstat
				plugstat=1
		else
			echo 0 > /var/www/html/openWB/ramdisk/plugstat
			plugstat=0
		fi
		if [[ $evseplugstate > "2" ]] && [[ $ladestatus == "1" ]] ; then
			echo 1 > /var/www/html/openWB/ramdisk/chargestat
			chargestat=1
		else
			echo 0 > /var/www/html/openWB/ramdisk/chargestat
			chargestat=0
		fi
	fi
fi
if [[ $lastmanagement == "1" ]]; then
	if [[ $evsecons1 == "modbusevse" ]]; then
		evseplugstatelp2=$(sudo python runs/readmodbus.py $evsesources1 $evseids1 1002 1)
		ladestatuss1=$(</var/www/html/openWB/ramdisk/ladestatuss1)

		if [[ $evseplugstatelp2 > "1" ]]; then
			echo 1 > /var/www/html/openWB/ramdisk/plugstats1
		else
			echo 0 > /var/www/html/openWB/ramdisk/plugstats1
		fi
		if [[ $evseplugstatelp2 > "2" ]] && [[ $ladestatuss1 == "1" ]] ; then
			echo 1 > /var/www/html/openWB/ramdisk/chargestats1
		else
			echo 0 > /var/www/html/openWB/ramdisk/chargestats1
		fi
	fi
	if [[ $evsecons1 == "slaveeth" ]]; then
		evseplugstatelp2=$(sudo python runs/readslave.py 1002 1)
		ladestatuss1=$(</var/www/html/openWB/ramdisk/ladestatuss1)

		if [[ $evseplugstatelp2 > "1" ]]; then
			echo 1 > /var/www/html/openWB/ramdisk/plugstats1
		else
			echo 0 > /var/www/html/openWB/ramdisk/plugstats1
		fi
		if [[ $evseplugstatelp2 > "2" ]] && [[ $ladestatuss1 == "1" ]] ; then
			echo 1 > /var/www/html/openWB/ramdisk/chargestats1
		else
			echo 0 > /var/www/html/openWB/ramdisk/chargestats1
		fi
	fi
fi
# Lastmanagement var check age
if test $(find "ramdisk/lastregelungaktiv" -mmin +2); then
       echo "" > ramdisk/lastregelungaktiv
fi

# Werte für die Berechnung ermitteln
lademodus=$(</var/www/html/openWB/ramdisk/lademodus)
llalt=$(cat /var/www/html/openWB/ramdisk/llsoll)
#PV Leistung ermitteln
if [[ $pvwattmodul != "none" ]]; then
	pvwatt=$(modules/$pvwattmodul/main.sh || true)
	if ! [[ $pvwatt =~ $re ]] ; then
		pvwatt="0"
	fi
else
	pvwatt=$(</var/www/html/openWB/ramdisk/pvwatt)
fi

#Speicher werte
if [[ $speichermodul != "none" ]] ; then
	timeout 5 modules/$speichermodul/main.sh || true
	speicherleistung=$(</var/www/html/openWB/ramdisk/speicherleistung)
	speichersoc=$(</var/www/html/openWB/ramdisk/speichersoc)
	speichersoc=$(echo $speichersoc | sed 's/\..*$//')
	speichervorhanden="1"
	echo 1 > /var/www/html/openWB/ramdisk/speichervorhanden
else
	speichervorhanden="0"
	echo 0 > /var/www/html/openWB/ramdisk/speichervorhanden
fi

#Ladeleistung ermitteln
if [[ $ladeleistungmodul != "none" ]]; then
	timeout 10 modules/$ladeleistungmodul/main.sh || true
	llkwh=$(</var/www/html/openWB/ramdisk/llkwh)
	llkwhges=$llkwh
	lla1=$(cat /var/www/html/openWB/ramdisk/lla1)
	lla2=$(cat /var/www/html/openWB/ramdisk/lla2)
	lla3=$(cat /var/www/html/openWB/ramdisk/lla3)
	lla1=$(echo $lla1 | sed 's/\..*$//')
	lla2=$(echo $lla2 | sed 's/\..*$//')
	lla3=$(echo $lla3 | sed 's/\..*$//')
	ladeleistung=$(cat /var/www/html/openWB/ramdisk/llaktuell)
	ladeleistunglp1=$ladeleistung
	if ! [[ $lla1 =~ $re ]] ; then
		 lla1="0"
	fi
	if ! [[ $lla2 =~ $re ]] ; then
		 lla2="0"
	fi

	if ! [[ $lla3 =~ $re ]] ; then
		 lla3="0"
	fi
	if ! [[ $ladeleistung =~ $re ]] ; then
		 ladeleistung="0"
	fi
	ladestatus=$(</var/www/html/openWB/ramdisk/ladestatus)

else
	lla1=0
	lla2=0
	lla3=0
	ladeleistung=0
	llkwh=0
	llkwhges=$llkwh
fi
#zweiter ladepunkt
if [[ $lastmanagement == "1" ]]; then
	if [[ $socmodul1 != "none" ]]; then
		timeout 10 modules/$socmodul1/main.sh || true
		soc1=$(</var/www/html/openWB/ramdisk/soc1)
		if ! [[ $soc1 =~ $re ]] ; then
		 soc1="0"
		fi
		echo 1 > /var/www/html/openWB/ramdisk/soc1vorhanden
	else
		echo 0 > /var/www/html/openWB/ramdisk/soc1vorhanden
		soc1=0
	fi
	timeout 10 modules/$ladeleistungs1modul/main.sh || true
	llkwhs1=$(</var/www/html/openWB/ramdisk/llkwhs1)
	llkwhges=$(echo "$llkwhges + $llkwhs1" |bc)
	llalts1=$(cat /var/www/html/openWB/ramdisk/llsolls1)
	ladeleistungs1=$(cat /var/www/html/openWB/ramdisk/llaktuells1)
	ladeleistunglp2=$ladeleistungs1
	llas11=$(cat /var/www/html/openWB/ramdisk/llas11)
	llas12=$(cat /var/www/html/openWB/ramdisk/llas12)
	llas13=$(cat /var/www/html/openWB/ramdisk/llas13)
	llas11=$(echo $llas11 | sed 's/\..*$//')
	llas12=$(echo $llas12 | sed 's/\..*$//')
	llas13=$(echo $llas13 | sed 's/\..*$//')
	ladestatuss1=$(</var/www/html/openWB/ramdisk/ladestatuss1)
	if ! [[ $ladeleistungs1 =~ $re ]] ; then
	 ladeleistungs1="0"
	fi
	ladeleistung=$(( ladeleistung + ladeleistungs1 ))
	echo "$ladeleistung" > /var/www/html/openWB/ramdisk/llkombiniert
else
	echo "$ladeleistung" > /var/www/html/openWB/ramdisk/llkombiniert
fi
#dritter ladepunkt
if [[ $lastmanagements2 == "1" ]]; then
	timeout 10 modules/$ladeleistungs2modul/main.sh || true
	llkwhs2=$(</var/www/html/openWB/ramdisk/llkwhs2)
	llkwhges=$(echo "$llkwhges + $llkwhs2" |bc)
	llalts2=$(cat /var/www/html/openWB/ramdisk/llsolls2)
	ladeleistungs2=$(cat /var/www/html/openWB/ramdisk/llaktuells2)
	llas21=$(cat /var/www/html/openWB/ramdisk/llas21)
	llas22=$(cat /var/www/html/openWB/ramdisk/llas22)
	llas23=$(cat /var/www/html/openWB/ramdisk/llas23)
	llas21=$(echo $llas21 | sed 's/\..*$//')
	llas22=$(echo $llas22 | sed 's/\..*$//')
	llas23=$(echo $llas23 | sed 's/\..*$//')
	ladestatuss2=$(</var/www/html/openWB/ramdisk/ladestatuss2)
	if ! [[ $ladeleistungs2 =~ $re ]] ; then
	 ladeleistungs2="0"
	fi
	ladeleistung=$(( ladeleistung + ladeleistungs2 ))
	echo "$ladeleistung" > /var/www/html/openWB/ramdisk/llkombiniert
else
	echo "$ladeleistung" > /var/www/html/openWB/ramdisk/llkombiniert
fi
echo $llkwhges > ramdisk/llkwhges

#Wattbezug
if [[ $wattbezugmodul != "none" ]]; then
	wattbezug=$(modules/$wattbezugmodul/main.sh || true)
	if ! [[ $wattbezug =~ $re ]] ; then
		wattbezug="0"
	fi
	#evu glaettung
	if (( evuglaettungakt == 1 )); then
		ganzahl=$(( evuglaettung / 10 ))
		for ((i=ganzahl;i>=1;i--)); do
			i2=$(( i + 1 ))
			cp ramdisk/glaettung$i ramdisk/glaettung$i2
		done
		echo $wattbezug > ramdisk/glaettung1
		for ((i=1;i<=ganzahl;i++)); do
			glaettung=$(<ramdisk/glaettung$i)
			glaettungw=$(( glaettung + glaettungw))
		done
		glaettungfinal=$((glaettungw / ganzahl))
		echo $glaettungfinal > ramdisk/glattwattbezug
		wattbezug=$glaettungfinal
	fi
	#uberschuss zur berechnung
	wattbezugint=$(printf "%.0f\n" $wattbezug)
	uberschuss=$((wattbezugint * -1))
	if [[ $speichervorhanden == "1" ]]; then
		if [[ $speicherpveinbeziehen == "1" ]]; then
			if (( speicherleistung > 0 )); then
				if (( speichersoc > speichersocnurpv )); then
					speicherww=$((speicherleistung + speicherwattnurpv))
					uberschuss=$((uberschuss + speicherww))
				else
					speicherww=$((speicherleistung - speichermaxwatt))
					uberschuss=$((uberschuss + speicherww))
				fi
			fi
		fi
	fi
	evua1=$(cat /var/www/html/openWB/ramdisk/bezuga1)
	evua2=$(cat /var/www/html/openWB/ramdisk/bezuga2)
	evua3=$(cat /var/www/html/openWB/ramdisk/bezuga3)
	evua1=$(echo $evua1 | sed 's/\..*$//')
	evua2=$(echo $evua2 | sed 's/\..*$//')
	evua3=$(echo $evua3 | sed 's/\..*$//')
	if ! [[ $evua1 =~ $re ]] ; then
		evua1="0"
	fi
	if ! [[ $evua2 =~ $re ]] ; then
		evua2="0"
	fi
	if ! [[ $evua3 =~ $re ]] ; then
		evua3="0"
	fi
else
	wattbezug=$pvwatt
	wattbezugint=$(printf "%.0f\n" $wattbezug)
	wattbezugint=$(echo "($wattbezugint+$hausbezugnone+$ladeleistung)" |bc)
	echo "$wattbezugint" > /var/www/html/openWB/ramdisk/wattbezug
	uberschuss=$((wattbezugint * -1))

fi

#Soc ermitteln
if [[ $socmodul != "none" ]]; then
	timeout 10 modules/$socmodul/main.sh || true
	soc=$(</var/www/html/openWB/ramdisk/soc)
	if ! [[ $soc =~ $re ]] ; then
	 soc="0"
	fi
else
	soc=0
fi
hausverbrauch=$((wattbezugint - pvwatt - ladeleistung - speicherleistung))
echo $hausverbrauch > /var/www/html/openWB/ramdisk/hausverbrauch
#Uhrzeit
date=$(date)
H=$(date +%H)
if [[ $debug == "1" ]]; then
	echo "$(tail -20000 /var/www/html/openWB/ramdisk/openWB.log)" > /var/www/html/openWB/ramdisk/openWB.log
	date
	if [[ $speichermodul != "none" ]] ; then
		echo speicherleistung $speicherleistung speichersoc $speichersoc
	fi
	echo pvwatt $pvwatt ladeleistung "$ladeleistung" llalt "$llalt" nachtladen "$nachtladen" nachtladen "$nachtladens1" minimalA "$minimalstromstaerke" maximalA "$maximalstromstaerke"
	echo lla1 "$lla1" llas11 "$llas11" llas21 "$llas21" mindestuberschuss "$mindestuberschuss" abschaltuberschuss "$abschaltuberschuss" lademodus "$lademodus"
	echo lla2 "$lla2" llas12 "$llas12" llas22 "$llas22" sofortll "$sofortll" wattbezugint "$wattbezugint" wattbezug "$wattbezug" uberschuss "$uberschuss"
	echo lla3 "$lla3" llas13 "$llas13" llas23 "$llas23" soclp1 $soc soclp2 $soc1
	echo evua 1 "$evua1" 2 "$evua2" 3 "$evua3"
fi
if (( opvwatt != pvwatt )); then
	mosquitto_pub -t openWB/Wpvwatt -r -m "$pvwatt"
fi
if (( owattbezug != wattbezug )); then
	mosquitto_pub -t openWB/Wwattbezug -r -m "$wattbezug"
fi
if (( ollaktuell != ladeleistunglp1 )); then
	mosquitto_pub -t openWB/Wllaktuell -r -m "$ladeleistunglp1"
fi
if (( oladestatus != ladestatus )); then
	mosquitto_pub -t openWB/ladestatus -m "$ladestatus"
	echo $ladestatus > ramdisk/mqttlastladestatus
fi
if (( olademodus != lademodus )); then
	mosquitto_pub -t openWB/lademodus -m "$lademodus"
	echo $lademodus > ramdisk/mqttlastlademodus
fi
if (( ohausverbrauch != hausverbrauch )); then
	mosquitto_pub -t openWB/Whausverbrauch -r -m "$hausverbrauch"
fi
if (( ollaktuells1 != ladeleistungs1 )); then
	mosquitto_pub -t openWB/Wllaktuells1 -r -m "$ladeleistungs1"
fi
if (( ollaktuells2 != ladeleistungs2 )); then
	mosquitto_pub -t openWB/Wllaktuells2 -r -m "$ladeleistungs2"
fi
if (( ollkombiniert != ladeleistung )); then
	mosquitto_pub -t openWB/Wllkombiniert -r -m "$ladeleistung"
fi
if (( ospeicherleistung != speicherleistung )); then
	mosquitto_pub -t openWB/Wspeicherleistung -r -m "$speicherleistung"
fi
if (( ospeichersoc != speichersoc )); then
	mosquitto_pub -t openWB/%speichersoc -r -m "$speichersoc"
fi
if (( osoc != soc )); then
	mosquitto_pub -t openWB/%soc -r -m "$soc"
fi
if (( osoc1 != soc1 )); then
	mosquitto_pub -t openWB/%soc1 -r -m "$soc1"
fi
plugstat=$(<ramdisk/plugstat)
chargestat=$(<ramdisk/chargestat)
plugstats1=$(<ramdisk/plugstats1)
chargestats1=$(<ramdisk/chargestats1)
if (( oplugstat != plugstat )); then
	mosquitto_pub -t openWB/boolplugstat -r -m "$plugstat"
	echo $plugstat > ramdisk/mqttlastplugstat

fi
if (( oplugstats1 != plugstats1 )); then
	mosquitto_pub -t openWB/boolplugstats1 -r -m "$plugstats1"
	echo $plugstats1 > ramdisk/mqttlastplugstats1
fi
if (( ochargestats1 != chargestats1 )); then
	mosquitto_pub -t openWB/boolchargestats1 -r -m "$chargestats1"
	echo $chargestats1 > ramdisk/mqttlastchargestats1
fi
if (( ochargestat != chargestat )); then
	mosquitto_pub -t openWB/boolchargestat -r -m "$chargestat"
	echo $chargestat > ramdisk/mqttlastchargestat
fi

}
