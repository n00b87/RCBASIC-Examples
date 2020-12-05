'This program was converted from the sdlBasic port
'The original version was written by cbmeeks

'---------------------------------------------------------
'Shadow of the Beast Demo
'by cbmeeks of SignalDev.com
'cbm@signaldev.com


'Press Esc to exit.

'This was coded in Blitz Basic (Blitz Plus actually)
'http://www.blitzbasic.com

'Tell them cbmeeks sent ya!

'I love Amiga!!
'Commodore rocked!

'Please visit my sites:

'http://www.metroidclassic.com
'http://www.signaldev.com

'There are NO popups or banners EVER!!!

'-cbmeeks
'--------------------------------------------------------

display_width = 640
windowOpen(0,"Beast Demo", 30, 30, 640,480,0)
window(0)
CanvasOpen(0,640,480,0,0,640,480,1)
CanvasOpen(1,640,480,0,0,640,480,1)
hideMouse()
Canvas(0)

dim x[21]
dim y[21]
dim v[21]
dim l[21]

loadmusic ("beast_media/b-title.mod")

loadimage(0, "beast_media/background.png")
x[0]=0
y[0]=0
v[0]=0
l[0]=display_width
if not imageExists(0) then
	print "image not loaded"
	waitkey()
	end
end if

loadimage (1, "beast_media/beast01.png")
x[1]=0
y[1]=0
v[1]=0.1
l[1]=display_width
loadimage(2, "beast_media/blimp.png")
x[2]=display_width
y[2]=160
v[2]=0-0.5
l[2]=display_width
loadimage(3, "beast_media/blimp_small.png")
x[3]=0
y[3]=100
v[3]=0.1
l[3]=display_width
loadimage(4, "beast_media/clouds5.png")
x[4]=0
y[4]=200
v[4]=0.5
l[4]=display_width
loadimage(5, "beast_media/clouds4.png")
x[5]=0
y[5]=180
v[5]=1
l[5]=display_width
loadimage(6, "beast_media/clouds3.png")
x[6]=0
y[6]=140
v[6]=2
l[6]=display_width
loadimage(7, "beast_media/clouds2.png")
x[7]=0
y[7]=60
v[7]=3
l[7]=display_width
loadimage(8, "beast_media/clouds1.png")	
x[8]=0
y[8]=0
v[8]=8
l[8]=display_width
loadimage(9, "beast_media/mountains.png")
x[9]=0
y[9]=270
v[9]=1
l[9]=display_width
loadimage(10, "beast_media/grassall.png")
x[10]=0
y[10]=430
v[10]=2
l[10]=display_width
loadimage(11, "beast_media/grass4.png")
x[11]=0
y[11]=460
v[11]=32
l[11]=display_width
loadimage(12, "beast_media/grass3.png")
x[12]=0
y[12]=445
v[12]=16
l[12]=display_width
loadimage(13, "beast_media/grass2.png")
x[13]=0
y[13]=435
v[13]=8
l[13]=display_width
loadimage(14, "beast_media/grass1.png")
x[14]=0
y[14]=430
v[14]=4
l[14]=display_width
loadimage(15, "beast_media/tree.png")
x[15]=0
y[15]=160
v[15]=8
l[15]=display_width
loadimage(16, "beast_media/wall.png")
x[16]=0
y[16]=440
v[16]=32
l[16]=display_width
loadimage(17, "beast_media/moon.png")
x[17]=375
y[17]=40
v[17]=0
l[17]=display_width/10
loadimage(18, "beast_media/splash.png")
x[18]= display_width
y[18]=0
v[18]=1.5
l[18]=display_width
loadimage(19, "beast_media/splash2.png")

'rcbasic logo
logo_offset_x = 80
logo_offset_y = 170
logo_angle = 0
loadimage(20, "beast_media/rcbasic.png")

for i = 2 to 19
	colorKey(i, -1)
next

while y[1]<480
   drawImage(1,x[1],y[1])
    y[1]=y[1]+v[1]
    v[1]=v[1]+0.01
    update()
wend

drawImage(0,0,0)
drawImage(17,x[17],y[17])

playmusic(-1)

sprite_x = 0

sprite_y = 200
while true
	ClearCanvas()
	drawImage(0,0,0)
	i=2
	x[i]=x[i]-v[i]
	if x[i]< -1 * l[i] then
		x[i]=display_width
	end if
	drawImage(i,x[i],y[i])


	for i=3 to 14
		x[i]=x[i] - v[i]
		if x[i]< -1 * l[i] then
			x[i]=0
		end if
		drawImage(i,x[i],y[i])
		drawImage(i,x[i]+display_width,y[i])
	next

	for i=15 to 16
		x[i]=x[i]-v[i]
		if x[i]< -1 * l[i] then
			x[i]=display_width
		end if
		drawImage(i,x[i],y[i])
	next


	x[18]=x[18]-v[18]
	if x[18]< -1 * l[18]*2 then
		 v[18]= -1 * v[18]
	end if
	if x[18]>l[18] then
		 v[18]= -1 * v[18]
	end if


	drawImage(18,x[18],y[18])
	drawImage(19,x[18]+display_width+100,y[18])
	drawImage_rotate(20,x[18]+logo_offset_x,y[18]+logo_offset_y,logo_angle)
	
	logo_angle = (logo_angle + 2) mod 360

	if key(k_escape) then
		exit while
	end if

	if key(k_1) then
		loadmusic ("beast_media/b-title.mod")
		playmusic(-1)
	end if

	if key(k_2) then
		loadmusic ("beast_media/Beast1_2.mod")
		playmusic(-1)
	end if

	if key(k_3) then
		loadmusic ("beast_media/Beast1_3.mod")
		playmusic(-1)
	end if
	
	if key(k_r) then
		wait(100)
		waitkey()
	end if

	if key(k_4) then
		loadmusic ("beast_media/Beast1_4.mod")
		playmusic(-1)
	end if

	if key(k_5) then
		loadmusic ("beast_media/Beast1_5.mod")
		playmusic(-1)
	end if
	
	update()
	wait(7)
wend

