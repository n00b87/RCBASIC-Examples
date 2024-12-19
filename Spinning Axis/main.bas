'----------------------------------------------------------------
'   TITLE: Spinning Around Axis
'   AUTHOR: n00b
'   DATE: Dec 13, 2024
'
'   DESCRIPTION: Its just a dot spinning around an origin point
'                but this is the foundation of more complex systems
'----------------------------------------------------------------

Include "util.bas"

'Open a graphics window
OpenWindow( "Spinning", 640, 480, 0, 0 )

'Open a 3D canvas to view our scene in
'scene_canvas = OpenCanvas3D(0, 0, w, h, 1)
ui_canvas = OpenCanvas(640, 480, 0, 0, 640, 480, 1)
Canvas(ui_canvas)
ClearCanvas()
SetColor(RGB(255,255,255))

LoadFont("FreeMono.ttf", 12)

Circle(100, 100, 50)

Dim x, y
x = 100
y = 150

r = 0


While Not Key(K_ESCAPE)
	ClearCanvas()
	
	SetColor(RGB(255,255,255))
	Circle(100, 100, 50)
	
	
	Dim v As Vector2D
	v = RotatePoint2D(x, y, 100, 100, r)
	
	DrawText("Angle: " + Str(r), 10, 10)
	
	SetColor(RGB(0,255,0))
	RectFill(v.x-1, v.y-1, 4, 4)
	
	r = (r + 1) MOD 360
	
	Update()
	
	Wait(50)
Wend
