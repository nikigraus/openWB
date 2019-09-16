
#!/usr/bin/env
import sys
import time


leaftimer = open('/var/www/html/openWB/ramdisk/soctimer', 'r')
#leaftimer = int(leaftimer.read())
#thecommand=str('python3 /var/www/html/openWB/modules/soc_leaf/getsoc.py')
#thestring=str( sys.argv[1] + ' ' + sys.argv[2] + ' &') 
leaftimer += 1
f = open('/var/www/html/openWB/ramdisk/soctimer', 'w')
f.write(str(leaftimer))
f.close()
f = open('/var/www/html/openWB/ramdisk/soc', 'w')
f.write(str(leaftimer))
f.close()
