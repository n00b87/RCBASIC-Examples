    '
    'Gold Waves Wired  (Basic 256 Demo)
    '
    'converted to rcbasic by johnno56 on rcbasic forums
    '@johnno56 on rcbasic.freeforums.net
    '
    'This was coded in RCBasic
    'http://www.rcbasic.com
    '--------------------------------------------------------  
    OpenWindow("GoldenWaves",600,600,0,1)
    m_canvas = OpenCanvas(600,600,0,0,600,600,0)
    Canvas(m_canvas)
    Sub polygon(x1, y1, x2, y2, x3, y3, x4, y4, flip)
    	Canvas(m_canvas)
    	If flip Then
    		tmp_x = x1
    		tmp_y = y1
    		x1 = x3
    		y1 = y3
    		x3 = tmp_x
    		y3 = tmp_y
    		'print "flip"
    	End If
    	Triangle(x1, y1, x2, y2, x3, y3)
    	'print "TRI: "; x1; ", "; y1; ", "; x2; ", "; y2; ", "; x3; ", "; y3
    	Triangle(x3, y3, x4, y4, x1, y1)
    End Sub
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
    			polygon(x,y-h,x+10,y+5-h,x+20,y-h,x+10,y-5-h, true) '	TOP
    			setColor(rgb(60,60,0))
    			polygon(x,y-h,x+10,y+5-h,x+10,y,x,y-5, false)			'	FRONT-LEFT
    			setColor(rgb(150,150,0))
    			polygon(x+10,y+5-h,x+10,y,x+20,y-5,x+20,y-h, true)	'	FRONT-RIGHT
    			if key(27) then
    				end
    			end if
    			'Update()
    			'WaitKey()
    		next
    	next
    	update()
    	wait(40)
    next