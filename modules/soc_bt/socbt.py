
#!/usr/bin/env

import binascii
import struct
import time
import sys
from bluepy import btle
from bluepy.btle import UUID, Peripheral
from bluepy.btle import Scanner, DefaultDelegate

# ----------------------------------------------------------------------------------------
# arg 1: MAC address
# arg 2: CAN Telegram COBID
# arg 3: CAN Telegram byte number (0-7)
# arg 4: Value offset 
# arg 5: Value factor (float value)
# ----------------------------------------------------------------------------------------
# Module will return the selected byte from the CAN telegram, treated by offset and factor
# SOC = (byteval + offset) * factor
# ----------------------------------------------------------------------------------------

thestring=str(sys.argv[1] + ' ' + sys.argv[2] + ' ' + sys.argv[3] + ' ' + sys.argv[4] + ' ' + sys.argv[5])
print "soc_bt: " + thestring

g_startTime = (int)(time.time())
g_strMACAddress = sys.argv[1]
g_strCOBID = "0374"
g_intVal = 0
g_exit_code = 0

#class ScanDelegate(DefaultDelegate):
#    def __init__(self):
#        DefaultDelegate.__init__(self)

#    def handleDiscovery(self, dev, isNewDev, isNewData):
#        if isNewDev:
#            print("Discovered device", dev.addr)
#        elif isNewData:
#            print("Received new data from", dev.addr)

#scanner = Scanner().withDelegate(ScanDelegate())

# if user defined 00:00:00:00:00:00 as MAC adress, we try to scan for it
if(g_strMACAddress == "00:00:00:00:00:00"):
    scanner = Scanner()
    devices = scanner.scan(2.0)
    devaddr = 0

    for dev in devices:
    #    print("Device %s (%s), RSSI=%d dB" % (dev.addr, dev.addrType, dev.rssi))
        devName = dev.getValueText(9)
        if devName  == "dani" :
            print "found dani device with addr: " + dev.addr
            devaddr = dev.addr
    #    for (adtype, desc, value) in dev.getScanData():
    #        print("  %s = %s" % (desc, value))

    if(devaddr != 0):
        g_strMACAddress = devaddr
        
if(g_strMACAddress != "00:00:00:00:00:00"):
    #temp_uuid = UUID(0x2221)
    temp_uuid = UUID("D3EDE59D-0CEE-433D-85AD-81B40BC51C3E")
    temp_uuidwr = UUID("54ED5C0A-8E0C-48D8-803C-7D20CE52DCA7")
     
    #p = Peripheral("5D:44:A6:38:CB:E5", "random")
    #p = Peripheral(g_foundDevice.addr, "random")
    p = Peripheral()
    devaddr = g_strMACAddress
     
    try:
        print "try to open " + devaddr
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
                    print("success. read: " + strval)
                    val = binascii.b2a_hex(strval)
                    g_intVal = binascii.unhexlify(val)
                
                    chwrite.write(g_strCOBID)
    #               val = struct.unpack('f', val)[0]
#                    print str(val)                    
                    g_exit_code = 1
                    f = open('/var/www/html/openWB/ramdisk/soc', 'w')
                    f.write(str(g_intVal))
                    f.close()
                except:
                    print("Oops!",sys.exc_info()[0],"occured.")

    except:
        print "Could not reach BT Module (",sys.exc_info()[0],")"
        p.disconnect()

print "SOC_BT used ", (int)(time.time()) - g_startTime, " seconds"
sys.exit(g_exit_code)


