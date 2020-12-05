'---------------------------------------------------------
'Tile Demo
'by eyfenna on rcbasic forums
'@eyfenna on rcbasic.freeforums.net

'Full Tutorial is available at 
'http://rcbasic.freeforums.net/thread/248/slight-refactoring-on-drawimage-blit

'Press Esc to exit.

'This was coded in RCBasic
'http://www.rcbasic.com

'--------------------------------------------------------  
    dim picslot[5000]
    dim picsx[5000]
    dim picsy[5000]
    dim picsw[5000]
    dim picsh[5000]
    dim pice[5000]
    dim picb[5000]
    sub addPic(picnum, slot, src_x,src_y,src_w, src_h, blockvalue)
    if pice[picnum] <> 0 then
    fprint("Already a picture at picnum ")
    print(picnum)
    else
    picslot[picnum] = slot
    picsx[picnum] = src_x
    picsy[picnum] = src_y
    picsw[picnum] = src_w
    picsh[picnum] = src_h
    pice[picnum] = 1
    picb[picnum] = blockvalue
    end if
    end sub
    sub modifiySourceXY(picnum, src_x, src_y)
    picsx[picnum] = src_x
    picsy[picnum] = src_y
    end sub
    sub drawblit(picnum, x,y)
    if pice[picnum] =0 then
    fprint("No picture at ")
    print(picnum)
    else
    DrawImage_Blit ( picslot[picnum], x, y, picsx[picnum], picsy[picnum], picsw[picnum], picsh[picnum])
    end if
    end sub
    dim field[100,102]
    dim fielde[100]
    sub drawField(fieldnum,windowsw, windowsh, offsetx, offsety)
    dim fieldx
    dim fieldy
    dim fieldedge[4]
    if fielde[fieldnum] <> 0 then
    fieldx = field[fieldnum,0]
    fieldy = field[fieldnum,1]
    piclength = picsw[field[fieldnum,2]]
    sidedimension = 10*piclength
    fieldedge[0] = fieldx
    fieldedge[1] = fieldx + sidedimension
    fieldedge[2] = fieldy
    fieldedge[3] = fieldy + sidedimension
    if fieldedge[0] > (offsetx - sidedimension) and fieldedge[1] < (windowsw + sidedimension+ offsetx) and fieldedge[2] > (offsety- sidedimension ) and fieldedge[3] < (windowsh + sidedimension + offsety) then
    for i = 2 to 101
    xpos = (i - 2) mod 10
    ypos = ((i - 2) / 10 ) mod 10
    drawx = fieldx + picsw[field[fieldnum,i]]*xpos
    drawy = fieldy + picsh[field[fieldnum,i]]*ypos
    picnum = field[fieldnum,i]
    drawblit(picnum,drawx,drawy)
    next
    end if
    end if
    end sub
    function findBeforeComma$(substr$)
    tv = true
    while(tv)
    if InStr(substr,",") <> -1 then
    strl = length(substr) -1
    substr = Left$(substr,strl)
    else
    tv = false
    end if
    wend
    return substr
    end function
    sub buildFieldfromFile(filename$)
    fileopen(1,filename,TEXT_INPUT)
    truth = true
    while(truth)
    if not EOF(1) then
    output$ = readline(1)
    pos = 2
    dim fieldpos$
    dim fieldval$
    if instr(output, "F") <> -1 then
    fieldval = findBeforeComma$(MId$(output,pos,6))
    pos = pos + length(fieldval)+1
    SN = VAL(fieldval)
    fielde[SN] = 1
    fieldpos = findBeforeComma$(Mid$(output,pos,6))
    pos = pos + length(fieldpos)+1
    field[SN,0] = VAL(fieldpos) -150
    fieldpos = findBeforeComma$(MId$(output,pos,6))
    field[SN,1] = VAL(fieldpos)-150
    pos = pos + length(fieldpos)+1
    for i = 2 to 101
    fieldval = findBeforeComma$(Mid$(output,pos,5))
    field[SN,i] = VAL(fieldval)
    pos = pos + length(fieldval)+1
    next
    end if
    else
    truth = false
    end if
    wend
    fileclose(1)
    end sub
    dim anime[1000]
    dim animp[1000]
    dim animf[1000]
    dim animr[1000]
    dim animt[1000]
    dim animfc[1000]
    dim animx[1000]
    dim animy[1000]
    dim animdx[1000]
    dim animdy[1000]
    sub registerAnimation(number, basepicture, maxframes, reversable, xdistance, ydistance)
    	anime[number] = 1
    	animp[number] = basepicture
    	animf[number] = maxframes
    	animr[number] = reversable
    	animx[number] = picsx[animp[number]]
    	animy[number] = picsy[animp[number]]
    	animdx[number] = xdistance
    	animdy[number] = ydistance
    end sub
    sub resetAnimation(number)
    	modifiySourceXY(animp[number],animx[number], animy[number])
    	animfc[number] = 0
    end sub
    sub playanimation(number, timing)
    	currtime =  timer - timing
    	animt[number] = animt[number] + currtime 
    	if animt[number] > 62 then
    		animfc[number] = animfc[number] + 1
    		animt[number] = 0
    	end if
    	if animfc[number] > animf[number] then
    		if animr[number] = 0 then
    			animfc[number] = animf[number]
    		elseif animr[number] = 1 then
    			animfc[number] = 0
    		end if
    	end if
    	x = (animfc[number]*animdx[number] + animx[number])
    	y =  (animfc[number]*animdy[number] + animy[number])
    	modifiySourceXY(animp[number],x ,y)
    end sub
    dim block[4]
    function fieldvalue(px,py)
    	dim fieldelem
    	dim fieldnum
    	for i = 0 to 99
    		if fielde[i] <> 0 then
    			fieldx = field[i,0]
    			fieldxs = field[i,0]+150
    			fieldy = field[i,1]
    			fieldys = field[i,1] + 150
    			if px > fieldx and px < fieldxs and py > fieldy and py < fieldys then
    				fieldnum = i
    				dx = px - fieldx
    				dy = py - fieldy
    				xfield = (dx / 15) mod 10
    				yfield = (dy / 15) mod 10
    				fieldelem = yfield*10 + xfield +2
    			end if
    		end if
    	next
    	return picb[field[fieldnum,fieldelem]]
    end function
    WindowOpen ( 0, "TEST WINDOW", 100, 100, 640, 480, 0 )
    CanvasOpen ( 0, 640, 480, 0, 0, 640, 480, 0 )
    loadImage(0,"ground2.png")
    addPic(0,0,1,1,15,15,0)
    addPic(1,0,1,17,15,15,0)
    addPic(2,0,17,1,15,15,0)
    addPic(3,0,17,17,15,15,0)
    addPic(4,0,1,33,15,15,0)
    addPic(5,0,33,1,15,15,1)
    addPic(6,0,33,17,15,15,1)
    addPic(7,0,33,33,15,15,1)
    addPic(8,0,33,49,15,15,1)
    addPic(9,0,33,65,15,15,1)
    addPic(10,0,49,1,15,15,1)
    addPic(11,0,49,17,15,15,1)
    addPic(12,0,49,33,15,15,1)
    addPic(13,0,49,49,15,15,1)
    addPic(14,0,65,1,15,15,1)
    addPic(15,0,65,17,15,15,1)
    addPic(16,0,65,33,15,15,1)
    addPic(17,0,65,49,15,15,1)
    addPic(18,0,81,1,15,15,0)
    addPic(19,0,81,17,15,15,0)
    addPic(20,0,97,1,15,15,0)
    addPic(21,0,97,17,15,15,0)
    addPic(22,0,97,33,15,15,0)
    addPic(23,0,97,49,15,15,0)
    loadImage(1,"tzir.png")
    addPic(24,1,1,1,30,30,0)
    addPic(25,1,1,32,30,30,0)
    addPic(26,1,1,63,30,30,0)
    addPic(27,1,1,94,30,30,0)
    registerAnimation(0,24,5,1,31,0)
    registerAnimation(1,25,5,1,31,0)
    registerAnimation(2,26,5,1,31,0)
    registerAnimation(3,27,5,1,31,0)
    buildFieldfromFile("level1.txt")
    fx = 0
    fy = 330
    direction = 0
    while Not Key(K_ESCAPE)
    clearcanvas
    timing = timer
    drawField(0,640,480,0,0)
    drawField(1,640,480,0,0)
    drawField(2,640,480,0,0)
    drawField(3,640,480,0,0)
    drawField(4,640,480,0,0)
    drawField(5,640,480,0,0)
    drawField(6,640,480,0,0)
    drawField(7,640,480,0,0)
    drawField(8,640,480,0,0)
    drawField(9,640,480,0,0)
    drawField(10,640,480,0,0)
    drawField(11,640,480,0,0)
    drawField(12,640,480,0,0)
    drawField(13,640,480,0,0)
    drawField(14,640,480,0,0)
    drawField(15,640,480,0,0)
    drawField(16,640,480,0,0)
    drawField(17,640,480,0,0)
    drawField(18,640,480,0,0)
    drawField(19,640,480,0,0)
    for i = 0 to 3
    		block[i] =0
    	next
    	block[0] = fieldvalue(fx +37,fy + 15)
    	block[1] = fieldvalue(fx+ 15,fy-7)
    	block[2] = fieldvalue(fx -7,fy + 15)
    	block[3] = fieldvalue(fx +15,fy+37)
    if (Key(K_RIGHT) Or Key(K_D)) and block[0] <>1 and fx < 610 then
    		direction = 0
    		fx = fx +0.5
    		playanimation(0,timing)
    elseif (Key(K_LEFT) Or Key(K_A)) and block[2] <> 1and fx > 0 then
    		direction = 2
    		fx = fx - 0.5
    		playanimation(1,timing)	
    elseif (Key(K_UP) Or Key(K_W)) and block[1] <> 1and fy > 0 then
    		direction = 1
    		fy = fy -0.5
    		playanimation(2,timing)
    elseif (Key(K_DOWN) Or Key(K_S)) and block[3] <> 1 and fy < 450 then
    		direction = 3
    		fy = fy + 0.5
    		playanimation(3,timing)
    else
    		resetAnimation(0)
    		resetAnimation(1)
    		resetAnimation(2)
    		resetAnimation(3)
    end if
    if direction = 0 then
    		drawblit(24,fx,fy)
    	elseif direction = 2 then
    		drawblit(25,fx,fy)
    	elseif direction = 1 then
    		drawblit(26,fx,fy)
    	elseif direction = 3 then
    		drawblit(27,fx,fy)
    	end if
    Update ( )
    wend
