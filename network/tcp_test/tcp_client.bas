'Client
Print "Simple TCP Chat Client (Requires RCBasic v3.0.8 or higher)"

'Open Socket 1 and connect to this computer on port 1234 ( you can change the ip address to the ip address of another computer to try it out over a network )
TCP_SocketOpen(1, "127.0.0.1", 1234)

'Some variables we will use to track data sent and recieved and the state of the program
txt$ = ""
send_txt$ = ""
init = False
run = True

'loop while run variable is not false
While run
	
	'This will ask for the users name when the program first starts
	if not init then
		send_txt$ = input("Enter your name: ")
		
		if send_txt$ <> "" Then
			'the server will be expecting the first transmission to be a 4 digit number with the size of the message
			'so we pad the length with 0s to make if 4 characters
			n = length(send_txt$)
			t_size$ = ""
			if n < 10 Then
				t_size$ = "000" + trim(str(n))
			elseif n < 100 Then
				t_size$ = "00" + trim(str(n))
			elseif n < 1000 Then
				t_size$ = "0" + trim(str(n))
			else
				t_size$ = trim(str(n))
			end if
			
			'Send the message size
			TCP_SendData(1, t_size$ )
			
			'Send the message which in this case is our name
			TCP_SendData(1, send_txt$)
			
			'Set init so we can start sending messages to other clients
			init = True
		end if
	
	else
		
		'Get input for the message to send
		send_txt$ =  input("Enter something:")
		
		'if message is not blank then send it
		If trim(send_txt$) = "quit" Then
			run = false
		End If
		
		If send_txt$ <> "" Then
			
			'We get the size of the message and pad it with 0s just like we did for our name above
			n = length(send_txt$)
			t_size$ = ""
			if n < 10 Then
				t_size$ = "000" + trim(str(n))
			elseif n < 100 Then
				t_size$ = "00" + trim(str(n))
			elseif n < 1000 Then
				t_size$ = "0" + trim(str(n))
			else
				t_size$ = trim(str(n))
			end if
			
			'Send the size of the message
			TCP_SendData(1, t_size$ )
			
			'Send the actual message
			TCP_SendData(1, send_txt$)
			
			send_txt$ = ""
			n = 0
			incoming_msg_count = 0
			
			'Wait for 1 second to check for incoming messages
			If CheckSockets(1000) > 0 Then
			
				'Get the number of incoming messages to expect
				TCP_GetData(1, t_size$, 4)
				incoming_msg_count = Val(Trim(t_size$))
				
				'If we have incoming messages then read them and print them to the console
				If incoming_msg_count > 0 Then
					For i = 1 to incoming_msg_count				
						txt$ = ""
						'Get the size of the message
						TCP_GetData(1, t_size$, 4)
						
						'Get the message if its size is greater than 0
						If Val(Trim(t_size$)) > 0 Then
							TCP_GetData(1, txt$, Val(Trim(t_size$)) )
							txt$ = Left(txt$, Val(Trim(t_size$)) ) + chr(0)
						End If
						
						'output the message to the console
						print txt$
					Next
				End If
			End If
		end if
	end if
Wend

print "End"
TCP_SocketClose(1)

If OS = "WINDOWS" Then
	System("pause")
End If

end



