'
'Gold Waves Wired  (Basic 256 Demo)
'
'converted to rcbasic by johnno56 on rcbasic forums
'@johnno56 on rcbasic.freeforums.net
'
'This was coded in RCBasic
'http://www.rcbasic.com

'--------------------------------------------------------  
WindowOpen(0,"Golden Waves",WINDOWPOS_CENTERED,WINDOWPOS_CENTERED,600,600,WINDOW_VISIBLE,1)
CanvasOpen(0,600,600,0,0,600,600,0)
Window(0)
CanvasOpen(1, 24, 16, 0, 0, 24, 16, 0)
SetCanvasVisible(1, false)
CanvasOpen(2, 24, 270, 0, 0, 24, 270, 0)
SetCanvasVisible(2, false)
quad_current_height = 0
sub initQuads()
	x = 0
	y = 5
	c = 0
	Canvas(1)
	For i = 0 to 255
		ClearCanvas()
		line(x,y,x+10,y+5)
		line(x+10,y+5,x+20,y)
		line(x+20,y,x+10,y-5)
		line(x+10,y-5,x,y)
		if i+50 > 255 then
			c = 255
		else
			c = i + 50
		end if
		setcolor(rgb(c, c, c))
		floodfill(x+10, y)
		CanvasClip(i, 0, 0, 20, 10, 1)
		ColorKey(i, -1)
	Next
	
	ix = 0
	iy = 0
	iw = 20
	ih = 0
	
	Canvas(2)
	
	For h = 0 to 255
		ClearCanvas()
		cz = -1*(y-h)
		ih = y+cz
		setColor(rgb(60,60,0))
		line(x,y-h+cz,x+10,y+5-h+cz)
		line(x+10,y+5-h+cz,x+10,y+cz)
		line(x+10,y+cz,x,y-5+cz)
		line(x,y-5+cz,x,y-h+cz)
		if h > 10 then
			floodfill(x+2, y-h+3+cz)
		end if
		
		setColor(rgb(150,150,0))
		line(x+10,y+5-h+cz,x+10,y+cz)
		line(x+10,y+cz,x+20,y-5+cz)
		line(x+20,y-5+cz,x+20,y-h+cz)
		line(x+20,y-h+cz,x+10,y+5-h+cz)
		if h > 10 then
			floodfill(x+16, y+4-h+cz)
		end if
		CanvasClip(256+h,0,0,iw,ih,1)
		Colorkey(256+h,RGB(0,0,0))
	Next
	
	Canvas(0)
end sub
sub quadSetHeight(h)
	If h < 0 Then
		h = 0
	ElseIf h >= 255 Then
		h = 255
	End If
	quad_current_height = h
end sub
sub quadFill(x, y, h)
	quadSetHeight(h)
	DrawImage(quad_current_height, x, y-5-quad_current_height)
	DrawImage(quad_current_height+256, x, y-quad_current_height)
end sub
initQuads()
darkred = rgb(64,0,0)
for t=1 to 60 step 0.3
ClearCanvas()
setColor(darkred)
rectFill(0,0,600,600)
	For y1 = 0 to 24
		For x1 = 0 to 24
			x = (12 * (24 - x1)) + (12 * y1)
			y = (0-6 * (24 - x1)) + (6 * y1) + 300
			d = ((10 - x1)^2 + (10 - y1)^2)^0.5
			h = 60 * sin(x1 / 4 + t) + 65
			if t > 10 and t < 20 then
				h = 60*sin(y1 / 4 + t) + 65
			end if
			if t > 20 and t < 30 then
				h = 60 * sin((x1 - y1) / 4 + t) + 65
			end if
			if t > 30 and t < 40 then
				h = 30 * sin(x1 / 2 + t) + 30 * sin(y1 / 2 + t) + 65
			end if
			if t > 40 and t < 50 then
				h = 60 * sin((x1 + y1) / 4 + t) + 65
			end if
			if t > 50 and t < 60 then
				h = 60 * sin(d * 0.3 + t) + 65
			end if

			quadFill(x, y, h)

			if key(27) then
				end
			end if
		next
	next
	update()
	wait(40)
next
