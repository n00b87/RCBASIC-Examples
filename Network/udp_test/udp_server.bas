'----------------------------------------------------------------
'   TITLE: UDP Server Example (meant to be run with UDP Client example)
'   AUTHOR: n00b
'   DATE: Dec 13, 2024
'
'   DESCRIPTION: This shows how to setup a udp socket for networking
'----------------------------------------------------------------

server = udp_opensocket(2000)

print "waiting for quit"
udata$ = ""

host$ = ""

port = 0


while true
	gotSomething = udp_getdata(server,host$,port,udata$)
	if udata$ = "quit" then
		exit while
	end if

	if length(udata$) > 0 then
		print "Data: "; udata$
	end if
wend

udp_closesocket(server)

If OS$() = "WINDOWS" Then
	System("PAUSE")
End If


