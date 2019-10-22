
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
g_strCOBID = sys.argv[2]
g_strByteNo = sys.argv[3]
g_strOffset = sys.argv[4]
g_strFactor = sys.argv[5]
g_intVal = 0
g_exit_code = 0
g_intByteNo = 0

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
    print "soc_bt scanning..."
    scanner = Scanner()
    devices = scanner.scan(3.0)
    devaddr = 0

    for dev in devices:
    #    print("Device %s (%s), RSSI=%d dB" % (dev.addr, dev.addrType, dev.rssi))
        devName = dev.getValueText(9)
        if devName  == "SOC_BT" :
            print "found SOC_BT device with addr: " + dev.addr
            devaddr = dev.addr
    #    for (adtype, desc, value) in dev.getScanData():
    #        print("  %s = %s" % (desc, value))

    if(devaddr != 0):
        g_strMACAddress = devaddr
        
if(g_strMACAddress != "00:00:00:00:00:00"):
    #temp_uuid = UUID(0x2221)
    uuid_soc = UUID("D3EDE59D-0CEE-433D-85AD-81B40BC51C3E")
    uuid_cobid = UUID("54ED5C0A-8E0C-48D8-803C-7D20CE52DCA7")
    uuid_byteno = UUID("F82A561C-0259-49C0-A40D-63ADE522A7ff")
     
    #p = Peripheral("5D:44:A6:38:CB:E5", "random")
    #p = Peripheral(g_foundDevice.addr, "random")
    
    try:
        p = Peripheral()
        devaddr = g_strMACAddress
        
        print "try to open " + devaddr
        p.connect(devaddr, "public")
        
        chread_soc = p.getCharacteristics(uuid=uuid_soc)[0]
        chwrite_cobid = p.getCharacteristics(uuid=uuid_cobid)[0]
        chwrite_byteno = p.getCharacteristics(uuid=uuid_byteno)[0]
        print "characteristics done"
    
        #write cobid
        try:
            g_intCOBID = int(g_strCOBID, 16)
            lsb = "".join(chr(g_intCOBID & 0xFF))
            msb = "".join(chr((g_intCOBID & 0xFF00) >> 8))
            chwrite_cobid.write(lsb + msb)
        except:
            print "Error: False format in COBID string"


        #write byte no
        try:
            g_intByteNo = int(g_strByteNo)
            bin_byteno = "".join(chr(g_intByteNo))
#                print("byteno: ", bin_byteno)
            chwrite_byteno.write(bin_byteno)
        except:
            print "Error: False format of byte number string"

        strval = chread_soc.read()
        val = binascii.b2a_hex(strval)                        
#       g_intVal = binascii.unhexlify(val)
        print "success. read: " + str(val)
        
        g_exit_code = 1
        f = open('/var/www/html/openWB/ramdisk/soc', 'w')
        f.write(str(val))
        f.close()

    except Exception, e:
        print("SOC_BT exception: ",sys.exc_info()[0],"occured.")
        print str(e)

    finally:
        p.disconnect()
        

print "SOC_BT used ", (int)(time.time()) - g_startTime, " seconds"
sys.exit(g_exit_code)
