
#!/usr/bin/env

import binascii
import struct
import time
import sys
from bluepy import btle
from bluepy.btle import UUID, Peripheral
from bluepy.btle import Scanner, DefaultDelegate

thestring=str(sys.argv[1] + ' ' + sys.argv[2] + ' ' + sys.argv[3] + ' ' + sys.argv[4] + ' ' + sys.argv[5])
print("soc_bt: " + thestring)

g_cobid = "0374"
g_val = 0

class ScanDelegate(DefaultDelegate):
    def __init__(self):
        DefaultDelegate.__init__(self)

    def handleDiscovery(self, dev, isNewDev, isNewData):
        if isNewDev:
            print("Discovered device", dev.addr)
        elif isNewData:
            print("Received new data from", dev.addr)

scanner = Scanner().withDelegate(ScanDelegate())
#scanner = Scanner()
devices = scanner.scan(2.0)
devaddr = 0
exit_code = 0

for dev in devices:
#    print("Device %s (%s), RSSI=%d dB" % (dev.addr, dev.addrType, dev.rssi))
    devName = dev.getValueText(9)
    if devName  == "dani" :
        print("found dani device with addr: " + dev.addr)
        devaddr = dev.addr
#    for (adtype, desc, value) in dev.getScanData():
#        print("  %s = %s" % (desc, value))

if(devaddr != 0):
 
    #temp_uuid = UUID(0x2221)
    temp_uuid = UUID("D3EDE59D-0CEE-433D-85AD-81B40BC51C3E")
    temp_uuidwr = UUID("54ED5C0A-8E0C-48D8-803C-7D20CE52DCA7")
     
    #p = Peripheral("5D:44:A6:38:CB:E5", "random")
    #p = Peripheral(g_foundDevice.addr, "random")
    p = Peripheral()
     
    try:
        print("try to open " + devaddr)
        p = Peripheral(devaddr, "random")
        
        ch = p.getCharacteristics(uuid=temp_uuid)[0]
    #    print str(ch)
        chwrite = p.getCharacteristics(uuid=temp_uuidwr)[0]
    #    print str(chwrite)
    #    sv = p.getServiceByUUID(0x180D);
    #    print str(sv)

        if (ch.supportsRead()):
                try:
                    strval = ch.read()
                    print "read: " + strval
                    val = binascii.b2a_hex(strval)
                    g_val = binascii.unhexlify(val)
                
                    chwrite.write(g_cobid)
    #               val = struct.unpack('f', val)[0]
#                    print str(val)                    
                    exit_code = 1
                except:
                    print("Oops!",sys.exc_info()[0],"occured.")

    except:
        print("Oops!",sys.exc_info()[0],"occured.")
        p.disconnect()


f = open('/var/www/html/openWB/ramdisk/soc', 'w')
f.write(str(g_val))
f.close()
sys.exit(exit_code)

