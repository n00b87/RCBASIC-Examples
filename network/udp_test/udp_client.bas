'UDP Client
quit = 0
dim s$
udp_socketopen(0, 0)
Print "Type quit to end"
while s$ <> "quit"
	print "Fill the buffer\n"
	s$ = input(">")
	udp_senddata(0, s, "127.0.0.1", 2000)
wend

print "test"
udp_socketclose(0)

If OS$() = "WINDOWS" Then
	System("pause")
End If
