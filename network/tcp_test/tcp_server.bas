'Server
Print "Simple TCP Chat Server (Requires RCBasic v3.0.8 or higher)"


'Setup a server in socket 0 on port 1234
TCP_SocketOpen(0,"",1234)

txt$ = ""

'Some variables to track client connections and status
Dim client_count
Dim client[8]
client[0] = false
Dim client_msg$[8]
Dim client_msg_size$[8]
Dim client_name$[8]
Dim client_init[8]

client_count = 0

Dim broadcast_count
broadcast_count = 0


while true
	'get a client connection if one is available
	if not client[client_count] then
		'check if there is a client connection available
		client[client_count] = TCP_AcceptSocket(0,client_count+1)
		
		'if there was a client connection then increment client_count to next element in array
		'so we can store the status of the next connection we make
		if client[client_count] then
			client_count = client_count + 1
		end if
	end if
	
	'Checks all open sockets for activity
	CheckSockets(5000)
	
	'loop through all possible connections
	for i = 1 to 8
		'default client_msg_size to empty
		client_msg_size$[i-1] = ""
		'If there was activity in this socket then we will read the data sent
		if TCP_SocketReady(i) then
			c_txt$ = ""
			Print "Recieving txt from client";i
			n = 0
			txt$ = ""
			
			'If client_init is false then we know this is the first time getting data which we know should be the name of the client
			If Not client_init[i-1] Then
			
				'Get Size of Name
				If TCP_GetData(i, txt$, 4) > 0 Then
					n = Val(Trim(txt$))
					'If the size of the name is greater than 0 then we will store the name and set client_init to true so we
					'can start recieving messages
					If n > 0 Then
						TCP_GetData(i, txt$, n)
						client_name$[i-1] = left(trim(txt$),n)
						client_init[i-1] = True
					End If
				End If
			
			'Get Size of Message
			ElseIf TCP_GetData(i, txt$, 4) > 0 Then
				n = Val(Trim(txt$))
				
				txt$ = ""
				
				'If size of message is greater than 0 then get the message
				If n > 0 Then
					TCP_GetData(i, txt$, n)
				End If
				
				print "Client sent: "; txt$
				
				if Left(txt, 4) = "quit" then
					Exit While
				End If
				
				'set client message to broadcast to the name of the client and the message they sent
				client_msg$[i-1] = client_name$[i-1] + ": " + txt$
				
				'set the size of the client msg
				n = length(client_msg[i-1])
				client_msg_size$[i-1] = ""
				
				if n < 10 then
					client_msg_size$[i-1] = "000" + trim(str(n))
				elseif n < 100 then
					client_msg_size[i-1] = "00" + trim(str(n))
				elseif n < 1000 then
					client_msg_size[i-1] = "0" + trim(str(n))
				else
					client_msg_size[i-1] = trim(str(n))
				end if
				
				'increment the number of messages to broadcast
				broadcast_count = broadcast_count + 1
				
				'Send Size
				'TCP_SendData(i, "0011")
				'txt$ = "Hello World"
				'TCP_SendData(i, txt$)
			Else
				'If get data was less than 0 then the client is likely no longer connected so we will close the socket and
				'set the clients status to false
				TCP_SocketClose(i)
				client[i-1] = False
				client_msg_size$[i-1] = ""
			End If
		end if
	next
	
	'if number of messages to broadcast is greater than 0 then loop through clients and send the current messages to connected clients
	if broadcast_count > 0 then
		for i1 = 1 to 8
			'if client status is true then we will send the client messages to it
			If client[i1-1] Then
				
				'Send the broadcast count to the client
				TCP_SendData(i1, "000" + str(broadcast_count) )
				For i2 = 0 to 7
					If length(client_msg_size[i2]) > 0 Then
						'Send Size
						TCP_SendData(i1, client_msg_size$[i2])
						
						'Send Message
						TCP_SendData(i1, client_msg$[i2])
					End If
				Next
			End If
		Next
	end if
	
	'reset broadcast count to 0
	broadcast_count = 0
	
wend

TCP_SocketClose(0)

print "The End"

End




