'----------------------------------------------------------------
'   TITLE: TCP Client Example (meant to be run with TCP Server example)
'   AUTHOR: n00b
'   DATE: Dec 13, 2024
'
'   DESCRIPTION: This shows how to setup a tcp socket for networking
'----------------------------------------------------------------
Print "Simple TCP Chat Client (Requires RCBasic v4.0 or higher)"

'Open Socket and connect to this computer on port 8000 ( you can change the ip address to the ip address of another computer to try it out over a network )
remote = TCP_OpenSocket("127.0.0.1", 8000)

send_txt$ = ""

Print "Type quit to end program"

While send_txt$ <> "quit"
	
	send_txt$ = input("Type in up to 8 characters: ")
		
	if send_txt$ <> "" Then
		TCP_SendData(remote, left$(send_txt$+"........", 8))
	end if
Wend

TCP_CloseSocket(remote)

If OS = "WINDOWS" Then
	System("pause")
End If



