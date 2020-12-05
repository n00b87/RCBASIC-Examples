'
'Gold Waves Wired  (Basic 256 Demo)
'
'converted to rcbasic by johnno56 on rcbasic forums
'@johnno56 on rcbasic.freeforums.net
'
'This was coded in RCBasic
'http://www.rcbasic.com

'--------------------------------------------------------  

WindowOpen(0,"GoldenWaves",WINDOWPOS_CENTERED,WINDOWPOS_CENTERED,600,600,0)
CanvasOpen(0,600,600,0,0,600,600,0)
Window(0)
darkred=rgb(64,0,0)
for t = 1 to 60 step 0.3
	ClearCanvas()
	setColor(darkred)
	rectFill(0,0,600,600)
	For y1 = 0 to 24
		For x1 = 0 to 24
			x=(12*(24-x1))+(12*y1)
			y=(0-6*(24-x1))+(6*y1)+300
			d=((10-x1)^2+(10-y1)^2)^0.5
			h=60*sin(x1/4+t)+65
			if t > 10 and t < 20 then
				h=60*sin(y1/4+t)+65
			end if
			if t > 20 and t < 30 then
				h=60*sin((x1-y1)/4+t)+65
			end if
			if t > 30 and t < 40 then
				h=30*sin(x1/2+t)+30*sin(y1/2+t)+65
			end if
			if t > 40 and t < 50 then
				h=60*sin((x1+y1)/4+t)+65
			end if
			if t > 50 and t < 60 then
				h=60*sin(d*0.3+t)+65
			end if
			setColor(rgb(100+h,100+h,h))
			''polygon(x,y-h,x+10,y+5-h,x+20,y-h,x+10,y-5-h)	'	TOP
			line(x,y-h,x+10,y+5-h)
			line(x+10,y+5-h,x+20,y-h)
			line(x+20,y-h,x+10,y-5-h)
			line(x+10,y-5-h,x,y-h)
			'floodfill(x+10,y-h)
			setColor(rgb(60,60,0))
			''polygon(x,y-h,x+10,y+5-h,x+10,y,x,y-5)			'	FRONT-LEFT
			line(x,y-h,x+10,y+5-h)
			line(x+10,y+5-h,x+10,y)
			line(x+10,y,x,y-5)
			line(x,y-5,x,y-h)
			''paint(x+2,y-h+3)
			setColor(rgb(150,150,0))
			''polygon(x+10,y+5-h,x+10,y,x+20,y-5,x+20,y-h)	'	FRONT-RIGHT
			line(x+10,y+5-h,x+10,y)
			line(x+10,y,x+20,y-5)
			line(x+20,y-5,x+20,y-h)
			line(x+20,y-h,x+10,y+5-h)
			'paint(x+16,y+4-h)
			if key(27) then
				end
			end if
		next
	next
	update()
	wait(40)
next
