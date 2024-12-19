'----------------------------------------------------------------
'   TITLE: UDP Client Example (meant to be run with UDP Server example)
'   AUTHOR: n00b
'   DATE: Dec 13, 2024
'
'   DESCRIPTION: This shows how to setup a udp socket for networking
'----------------------------------------------------------------
quit = 0
dim s$
socket = udp_opensocket(0)
Print "Type quit to end"
while s$ <> "quit"
	print "Fill the buffer\n"
	s$ = input(">")
	udp_senddata(socket, "127.0.0.1", 2000, s$)
wend

udp_closesocket(socket)

If OS$() = "WINDOWS" Then
	System("pause")
End If
