'Silently install PowerShell on XP with VBScript
'Authorish: obscuresec
'No checks for SP3 but will try and install .Net Framework first
'Uses DownloadFile: http://blog.netnerds.net/2007/01/vbscript-download-and-save-a-binary-file/

Function DownloadFile(DownloadUrl)
  Dim arURL, FileName, FileSaveLocation
  arURL = Split(DownloadUrl,"/",-1,1)
  filename = arURL(UBound(arURL))
  Dim oFS, TempDir
  Set oFS = CreateObject("Scripting.FileSystemObject")
  Set TempDir = oFS.getSpecialFolder(2)
  FileSaveLocation = TempDir & "\" & FileName
  Dim oXMLHTTP, oADOStream
  Set oXMLHTTP = CreateObject("MSXML2.XMLHTTP")
  oXMLHTTP.open "GET", DownloadUrl, false
  oXMLHTTP.send()
  If oXMLHTTP.Status = 200 Then
  Set oADOStream = CreateObject("ADODB.Stream")
  oADOStream.Open
  oADOStream.Type = 1 
  oADOStream.Write oXMLHTTP.ResponseBody
  oADOStream.Position = 0 
  If oFS.Fileexists(FileSaveLocation) Then oFS.DeleteFile FileSaveLocation
  Set oFS = Nothing
  oADOStream.SaveToFile FileSaveLocation
  oADOStream.Close
  Set oADOStream = Nothing
  End if
  Set oXMLHTTP = Nothing
End Function

DownloadFile("http://download.microsoft.com/download/0/8/c/08c19fa4-4c4f-4ffb-9d6c-150906578c9e/NetFx20SP1_x86.exe")
DownloadFile("http://download.microsoft.com/download/E/C/E/ECE99583-2003-455D-B681-68DB610B44A4/WindowsXP-KB968930-x86-ENG.exe")
Dim WshShell
Set WshShell = CreateObject("WScript.Shell")
ReturnCode = WshShell.run ("%temp%\NetFx20SP1_x86.exe /z /u /q", 1, True)
WshShell.run ("%temp%\WindowsXP-KB968930-x86-ENG.exe /z /u /q")
