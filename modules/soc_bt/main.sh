#!/bin/bash
. /var/www/html/openWB/openwb.conf

sudo hciconfig hci0 reset
timeout 6 python /var/www/html/openWB/modules/soc_bt/socbt.py $socbt_mac $socbt_cobid $socbt_byteno $socbt_offset $socbt_factor &

