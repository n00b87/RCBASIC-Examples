'----------------------------------------------------------------
'   TITLE: Boundary Check
'   AUTHOR: n00b
'   DATE: Dec 13, 2024
'
'   DESCRIPTION: This is an example of checking for points within
'                geometric boundaries
'----------------------------------------------------------------

OpenWindow("Bound Check", 640, 480, 0, 0)
main_canvas = OpenCanvas(640, 480, 0, 0, 640, 480, 0)
ui_canvas = OpenCanvas(640, 480, 0, 0, 640, 480, 0)

'This was a function in RCBasic 3 but it was removed so I am
'just making it here for the sake of conversion
Sub BoxFill(x1, y1, x2, y2)
	w = x2-x1
	h= y2-y1
	RectFill(x1, y1, w, h)
End Sub

cx = 350
cy = 250
cr = 30

lx1 = 100
ly1 = 100
lx2 = 400
ly2 = 300


Dim ix1, iy1, ix2, iy2

qx1 = 130
qy1 = 50
qx2 = 240
qy2 = 70
qx3 = 350
qy3 = 300
qx4 = 90
qy4 = 270


tx1 = 130
ty1 = 50
tx2 = 240
ty2 = 70
tx3 = 350
ty3 = 300

DEMO_MODE_LINE_LINE = 0
DEMO_MODE_CIRCLE_LINE = 1
DEMO_MODE_POINT_QUAD = 2
DEMO_MODE_POINT_TRI = 3

demo_mode = 0

mono_font = LoadFont("FreeMono.ttf", 12)
SetFont(mono_font)

Canvas(ui_canvas)
ClearCanvas()
SetColor(RGB(255,255,255))
DrawText("Press 1 for LINE TO LINE COLLISION", 10, 10)
DrawText("Press 2 for CIRCLE TO LINE COLLISION", 10, 30)
DrawText("Press 3 for POINT IN QUAD", 10, 50)
DrawText("Press 4 for POINT IN TRIANGLE", 10, 70)


Canvas(main_canvas)

While Not Key(K_ESCAPE)
	ClearCanvas()
	
	If Key(K_LEFT) Then
		cx = cx - 1
	ElseIf Key(K_RIGHT) Then
		cx = cx + 1
	End If
	
	If Key(K_UP) Then
		cy = cy - 1
	ElseIf Key(K_DOWN) Then
		cy = cy + 1
	End If

	p0_x = cx
	p0_y = cy
	p1_x = p0_x + 200
	p1_y = p0_y + 90
	
	n = 0
	Select Case demo_mode
	Case DEMO_MODE_LINE_LINE
		n = GetLineIntersection(p0_x, p0_y, p1_x, p1_y, lx1, ly1, lx2, ly2, ix1, iy1)
	Case DEMO_MODE_CIRCLE_LINE
		n = GetCircleLineIntersection(cx, cy, cr, lx1, ly1, lx2, ly2, ix1, iy1, ix2, iy2)
	Case DEMO_MODE_POINT_QUAD
		n = PointInQuad(cx, cy, qx1, qy1, qx2, qy2, qx3, qy3, qx4, qy4)
	Case DEMO_MODE_POINT_TRI
		n = PointInTri(cx, cy, tx1, ty1, tx2, ty2, tx3, ty3)
	End Select
	
	
	If n Then
		SetColor(RGB(255,0,0))
	Else
		SetColor(RGB(0,255,0))
	End If
	
	If Key(K_M) Then
		Print "Line 1: ";p0_x;", "; p0_y;", "; p1_x;", "; p1_y
		Print "Line 2: "; lx1;", "; ly1;", "; lx2;", "; ly2
		Print "Intersect: "; ix1; ", "; iy1
		Print ""
		Wait(100)
		Waitkey()
	End If
	
	Select Case demo_mode
	Case DEMO_MODE_LINE_LINE
		BoxFill(p0_x-2, p0_y-2, p0_x+2, p0_y+2)
		BoxFill(p1_x-2, p1_y-2, p1_x+2, p1_y+2)
		Line(p0_x, p0_y, p1_x, p1_y)
		
		SetColor(RGB(255,255,255))
		Line(lx1, ly1, lx2, ly2)
		
	Case DEMO_MODE_CIRCLE_LINE
		BoxFill(cx-2, cy-2, cx+2, cy+2)
		Circle(cx, cy, cr)
		
		SetColor(RGB(255,255,255))
		Line(lx1, ly1, lx2, ly2)
	
	Case DEMO_MODE_POINT_QUAD
		BoxFill(cx-2, cy-2, cx+2, cy+2)
		Circle(cx, cy, cr)
		
		SetColor(RGB(255,255,255))
		Line(qx1, qy1, qx2, qy2)
		Line(qx2, qy2, qx3, qy3)
		Line(qx3, qy3, qx4, qy4)
		Line(qx4, qy4, qx1, qy1)
	
	Case DEMO_MODE_POINT_TRI
		BoxFill(cx-2, cy-2, cx+2, cy+2)
		Circle(cx, cy, cr)
	
		SetColor(RGB(255,255,255))
		Line(tx1, ty1, tx2, ty2)
		Line(tx2, ty2, tx3, ty3)
		Line(tx3, ty3, tx1, ty1)
		
	End Select

	If Key(K_1) Then
		demo_mode = DEMO_MODE_LINE_LINE
	ElseIf Key(K_2) Then
		demo_mode = DEMO_MODE_CIRCLE_LINE
	ElseIf Key(K_3) Then
		demo_mode = DEMO_MODE_POINT_QUAD
	ElseIf Key(K_4) Then
		demo_mode = DEMO_MODE_POINT_TRI
	End If
	
	Update()
Wend