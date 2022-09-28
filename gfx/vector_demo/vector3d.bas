'-3d Drawing demo-based on sdlBasic Demo- RC Basic version - Rodney Cunningham aka n00b
'- 3d Drawing demo - 040803 - sdlBasic version - Paulo Silva
'- (3d algorythms based on Michel Rousselet codes for zx-spectrum )
'- bug: xobs position value looks reverted (=*-1) (needs a deep review)
'- bugfix from Vroby: div0 error in angulo() function

LoadFont(0,"FreeMono.ttf",16)

dim xobs
dim yobs
dim zobs
dim xtgt
dim ytgt
dim ztgt
dim qdst
dim zoom
radiano=57.2957792

wdwd=1
xedge=512
yedge=384

WindowOpen(0, "3D Vector", 20, 20, xedge, yedge, WINDOW_VISIBLE, 1)
CanvasOpen(0, xedge, yedge, 0, 0, xedge, yedge, 0)
Canvas(0)
SetColor(rgb(32, 32,128))
ClearCanvas()
expctw=640
expctf=xedge/expctw

function absv(n)
	if n<0 then
		return n*(-1)
	end if
	return n
end function

function eucl(x1,y1,z1)
	x1=abs(x1)
	y1=abs(y1)
	z1=abs(z1)
	return sqrt((x1^2)+(y1^2)+(z1^2))
end function

function pitag(x2,y2)
	x2=abs(x2)
	y2=abs(y2)
	if ((x2^2)+(y2^2))<>0 then
		return sqrt((x2^2)+(y2^2))
	else
		return 0
	end if
end function

function angulo(xe,ye)
       tmprq=0
	if xe<=0 and ye<=0 then
		tmprq=3
	end if
	if xe<=0 and ye>=0 then
		tmprq=4
	end if
	if xe>=0 and ye>=0 then
		tmprq=1
	end if
	if xe>=0 and ye<=0 then
		tmprq=2
	end if
	quadt=tmprq
	dptg=pitag(xe,ye)
	dim v
	if dptg<>0 then
		v=asin(abs(xe)/dptg)
	else
		v=0
	end if
	tmpr=v*57.2957792
	tmpr2=tmpr
	if quadt=2 then
		tmpr2=180-tmpr
	end if
	if quadt=3 then
		tmpr2=180+tmpr
	end if
	if quadt=4 then
		tmpr2=360-tmpr
	end if
	return tmpr2
end function

function xfrom3d(x1,y1,z1)
	xdn=x1-xobs
	ydn=y1-yobs
	zdn=z1-zobs
	xvn=xtgt-xobs
	yvn=ytgt-yobs
	zvn=ztgt-zobs
	rdnang=angulo(xdn,ydn)
	rdndist=pitag(xdn,ydn)
	rvnang=angulo(xvn,yvn)
	rvndist=pitag(xvn,yvn)
	rdnang=rdnang-rvnang
	rvnang=0
	xdn=sin(rdnang/radiano)*rdndist
	ydn=cos(rdnang/radiano)*rdndist
	xvn=0
	yvn=rvndist
	rdnang=angulo(zdn,ydn)
	rdndist=pitag(zdn,ydn)
	rvnang=angulo(zvn,yvn)
	rvndist=pitag(zvn,yvn)
	rdnang=rdnang-rvnang
	rvnang=0
	zdn=sin(rdnang/radiano)*rdndist
	ydn=cos(rdnang/radiano)*rdndist
	xproj=(xedge/2)+(zoom*((qdst*xdn)/ydn))
	yproj=(yedge/2)+(zoom*((qdst*zdn)/ydn))
	return xproj
end function

function yfrom3d(x1,y1,z1)
	xdn=x1-xobs
	ydn=y1-yobs
	zdn=z1-zobs
	xvn=xtgt-xobs
	yvn=ytgt-yobs
	zvn=ztgt-zobs
	rdnang=angulo(xdn,ydn)
	rdndist=pitag(xdn,ydn)
	rvnang=angulo(xvn,yvn)
	rvndist=pitag(xvn,yvn)
	rdnang=rdnang-rvnang
	rvnang=0
	xdn=sin(rdnang/radiano)*rdndist
	ydn=cos(rdnang/radiano)*rdndist
	xvn=0
	yvn=rvndist
	rdnang=angulo(zdn,ydn)
	rdndist=pitag(zdn,ydn)
	rvnang=angulo(zvn,yvn)
	rvndist=pitag(zvn,yvn)
	rdnang=rdnang-rvnang
	rvnang=0
	zdn=sin(rdnang/radiano)*rdndist
	ydn=cos(rdnang/radiano)*rdndist
	xproj=(xedge/2)+(zoom*((qdst*xdn)/ydn))
	yproj=(yedge/2)+(zoom*((qdst*zdn)/ydn))
	return yproj
end function

Sub Rect3d_xy(xc1,yc1,xc2,yc2,zc1)
	x1=xfrom3d(xc1,yc1,zc1)
	y1=yfrom3d(xc1,yc1,zc1)
	x2=xfrom3d(xc2,yc1,zc1)
	y2=yfrom3d(xc2,yc1,zc1)
	x3=xfrom3d(xc2,yc2,zc1)
	y3=yfrom3d(xc2,yc2,zc1)
	x4=xfrom3d(xc1,yc2,zc1)
	y4=yfrom3d(xc1,yc2,zc1)
	line (x1,y1,x2,y2)
	line (x2,y2,x3,y3)
	line (x3,y3,x4,y4)
	line (x4,y4,x1,y1)
End Sub

Window(0)
xmouse = 0
ymouse = 0
t_delay = 10
t_mark = timer()


ReadInput_Start()


while true
	ClearCanvas()
	zoom=96*expctf
	mb = 0
	xms = 0
	yms = 0
	getmouse(xms, yms, mb, mb, mb)
	if (xms<>-1) and (yms<>-1) then
		xmouse = xms
		ymouse = yms
	end if
	xm1= (xmouse-(xedge/2))* (-1*(1/expctf) )
	ym1=(ymouse-(yedge/2))*(1/expctf)
	xobs=xm1
	yobs=150
	zobs=ym1
	xtgt=0
	ytgt=0
	ztgt=0
	qdst=10
	for zz=-20 to 20 step 5
		Rect3d_xy(-20,-20,20,20,zz)
	next
		drawText("User Input = " + ReadInput_Text() +";", 10, 10)

	if key(k_escape) then
		exit while
	end if
		update()
wend

ReadInput_Stop()

print "THE END"

waitkey()

windowClose(0)

end



