'----------------------------------------------------------------
'   TITLE: TCP Server Example (meant to be run with TCP Client example)
'   AUTHOR: n00b
'   DATE: Dec 13, 2024
'
'   DESCRIPTION: This shows how to setup a tcp socket for networking
'----------------------------------------------------------------
Print "Simple TCP Chat Server (Requires RCBasic v4.0 or higher)"


'Setup a server in socket 0 on port 1234
server = TCP_OpenSocket("",8000)

txt$ = ""

client = -1

Print "Program will end when client sends quit"

while left$(txt$, 4) <> "quit"
	'get a client connection if one is available
	if client < 0 then
		'check if there is a client connection available
		client = TCP_AcceptSocket(server)
		
		if client >= 0 then
			Print "Found Client: "; client
		Else
			Continue
		end if
	end if
	
	'Checks all open sockets for activity
	CheckSockets(5000)

	'If there was activity in this socket then we will read the data sent
	if TCP_SocketReady(client) then
		Print "Recieving txt from client"
		txt$ = ""
		
		If TCP_GetData(client, 8, txt$) > 0 Then
			Print "Client Sent: "; txt$
		End If
		Print ""
	End If
			
wend

TCP_CloseSocket(server)

End




