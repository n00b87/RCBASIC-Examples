dim squares[5000,5]
creation = false
current = -1
sub resetsquares()
for i = 0 to 4999
if squares[i,0] = 0 then
for j = 1 to 4
squares[i,j] = -1
next
end if
next
end sub
sub drawsquare()
for i = 0 to 4999
if squares[i,0] = 1 then
SetColor( RGB ( 255, 255, 255 ) )
box(squares[i,1],squares[i,2],squares[i,3],squares[i,4])
elseif squares[i,0] = 2 then
SetColor(RGB(255,50,50))
box(squares[i,1],squares[i,2],squares[i,3],squares[i,4])
end if
next
end sub
sub marksquare(mx,my,mb)
if mb then
for i = 0 to 4999
if squares[i,0] = 1 then
if mx >= squares[i,1] and mx <= squares[i,3] and my >= squares[i,2] and my <= squares[i,4] then
squares[i,0] = 2
end if
elseif squares[i,0] = 2 and ( mx <= squares[i,1] or mx >= squares[i,3] or my <= squares[i,2] or my > squares[i,4]) then
squares[i,0] = 1
end if
next
end if
end sub
sub createsquare(mx,my, byref acurrent)
for i = 0 to 4999
if squares[i,0] = 0 then
if not creation then
squares[i,0] = 1
acurrent = i
squares[i,1] = mx
squares[i,2] = my
squares[i,3] = squares[i,1]
squares[i,4] = squares[i,2]
creation = true
end if
end if
next
end sub
sub dragsquare(mx,my, acurrent)
if squares[current,1] > -1 then
if creation then
squares[acurrent,3] = mx
squares[acurrent,4] = my
end if
end if
end sub
WindowOpen ( 0, "TEST WINDOW", 100, 100, 640, 480, WINDOW_VISIBLE, 1 )
CanvasOpen ( 0, 640, 480, 0, 0, 640, 480, 0 )
dim mx
dim my
dim mb1
dim mb2
dim mb3
while true
clearcanvas
getmouse(mx,my,mb1,mb2,mb3)
resetsquares()
if not key(K_LSHIFT) then
marksquare(mx,my,mb1)
creation = false
else
if mb1 and not creation then
createsquare(mx,my,current)
elseif creation then
dragsquare(mx,my,current)
end if
if not mb1 then
print("Ending drawing")
creation = false
current = -1
end if
end if
drawsquare()
update()
wend
