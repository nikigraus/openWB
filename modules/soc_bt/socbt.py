
#!/usr/bin/env
import sys
import time


leaftimer = open('/var/www/html/openWB/ramdisk/soctimer', 'r')
leaftimer = int(leaftimer.read())
#print(leaftimer)
#thecommand=str('python3 /var/www/html/openWB/modules/soc_leaf/getsoc.py')
#thestring=str( sys.argv[1] + ' ' + sys.argv[2] +  ' ' + sys.argv[3] +  ' ' + sys.argv[4] +  ' ' + sys.argv[5] +' &')
#print("socbt command: " + thestring)
leaftimer += 1
f = open('/var/www/html/openWB/ramdisk/soctimer', 'w')
f.write(str(leaftimer))
f.close()
f = open('/var/www/html/openWB/ramdisk/soc', 'w')
f.write(str(leaftimer))
f.close()
