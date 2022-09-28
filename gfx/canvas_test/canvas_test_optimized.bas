/'visible = true
fullscreen = false
resizable = false
borderless = false
highDPI = false
'/

visible = true
fullscreen = false
resizable = false
borderless = false
highDPI = false

vsync = true

Dim sprite1_x[8], sprite1_y[8], sprite1_image : sprite1_image = 0

Dim sprite1_angle

Dim canvas1_offset_x[8], canvas1_offset_y[8]
Dim canvas2_offset_x[4], canvas2_offset_y[4]

freq = 0
format = 0
channels = 0
result = QueryAudioSpec(freq, format, channels)

print "audio spec: results=";result;"   freq=";freq;"   format=";format;"   channels=";channels

Print "BEFORE Canvas2 Offset ArrayDim = ";ArrayDim(canvas2_offset_x);" x ";ArrayDim(canvas2_offset_y) /' Multi-line comment on a single line'/
Print "BEFORE Canvas2 Offset ArraySize = ";ArraySize(canvas2_offset_x, 1);" x ";ArraySize(canvas2_offset_y, 1)

ReDim canvas2_offset_x[8], canvas2_offset_y[8] /'carrying multi-line comment over multiple lines

'/Print "AFTER Canvas2 Offset ArrayDim = ";ArrayDim(canvas2_offset_x);" x ";ArrayDim(canvas2_offset_y)
Print "AFTER Canvas2 Offset ArraySize = ";ArraySize(canvas2_offset_x, 1);" x ";ArraySize(canvas2_offset_y, 1)

sub init()
	LoadFont(0, "prstart.ttf", 16)
	LoadFont(1, "FreeMono.ttf", 12)
	For i = 0 to 7
		Window(i)
		CanvasOpen(0, 640, 480, 0, 0, 640, 480, 1)
		CanvasOpen(1, 400, 400, 100, 100, 200, 200, 1)
		CanvasOpen(2, 400, 400, 300, 300, 200, 200, 1)
		CanvasOpen(3, 640, 480, 0, 0, 640, 480, 1)
	Next
	LoadImage_Ex(sprite1_image, "sprite1.png", -1)
end sub

function test_window(win)
	If Not WindowExists(win) Then
		return -1
	End If
	Window(win)
	Canvas(0)
	ClearCanvas
	SetColor(RGB(255, 0, 0))
	Font(0)
	
	DrawText("ActiveWindow = " + Str(ActiveWindow), 100, 200)
	Locate(5, 10)
	SetColor(RGB(0,255,0))
	'PrintS("Testing \qPRINTS\q") 'test PRINTS along with escape character
	
	Canvas(1)
	ClearCanvas
	SetColor(RGB(255,255,255))
	Rect(canvas1_offset_x[win],canvas1_offset_y[win],200,200)
	SetColor(RGB(0, 0, 255))
	Font(1)
	DrawText("Scrolling", 10, 10)
	
	return win
end function

WindowOpen(0, "test", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480, WindowMode(visible, fullscreen, resizable, borderless, highDPI), vsync)
WindowOpen(1, "test", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480, WindowMode(visible, fullscreen, resizable, borderless, highDPI), vsync)
WindowOpen(2, "test", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480, WindowMode(visible, fullscreen, resizable, borderless, highDPI), vsync)
WindowOpen(3, "test", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480, WindowMode(visible, fullscreen, resizable, borderless, highDPI), vsync)
WindowOpen(4, "test", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480, WindowMode(visible, fullscreen, resizable, borderless, highDPI), vsync)
WindowOpen(5, "test", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480, WindowMode(visible, fullscreen, resizable, borderless, highDPI), vsync)
WindowOpen(6, "test", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480, WindowMode(visible, fullscreen, resizable, borderless, highDPI), vsync)
WindowOpen(7, "test", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480, WindowMode(visible, fullscreen, true, borderless, highDPI), vsync)

Print "visible_flags="; AndBit(WindowFlags(0), WINDOW_VISIBLE)
Print "fullscreen_flags="; AndBit(WindowFlags(0), WINDOW_FULLSCREEN)
Print "resizable_flags="; AndBit(WindowFlags(0), WINDOW_RESIZABLE)
Print "borderless_flags="; AndBit(WindowFlags(0), WINDOW_BORDERLESS)
Print "highDPI_flags="; AndBit(WindowFlags(0), WINDOW_HIGHDPI)

init()

current_window = 0
canvas1_vx = 0
canvas1_vy = 0
canvas1_vw = 0
canvas1_vh = 0

canvas1_w = 0
canvas1_h = 0

canvas1_move_speed = 2

GetCanvasViewport(1, canvas1_vx, canvas1_vy, canvas1_vw, canvas1_vh)
GetCanvasSize(1, canvas1_w, canvas1_h)

For i = 0 to 7
	Window(i)
	Canvas(3)
	
	SetColor(RGB(255,0,0))
	RectFill(450, 50, 50, 50)
	
	SetColor(RGB(0,255,0))
	RectFill(450, 150, 50, 50)
	
	SetColor(RGB(0,0,255))
	RectFill(450, 250, 50, 50)
	
	Update()
	
	c = GetPixel(455, 55)
	SetColor(c)
	RectFill(550, 50, 50, 50)
	
	c = GetPixel(455, 155)
	SetColor(c)
	RectFill(550, 150, 50, 50)
	
	c = GetPixel(455, 255)
	SetColor(c)
	RectFill(550, 250, 50, 50)
	
	Update()
Next

While WindowExists(0) And Not Key(K_ESCAPE)
	
	If Key(K_R) Then
		RestoreWindow(ActiveWindow)
	ElseIf Key(K_1) Then
		Cls
	End If
	
	for i = 0 to 7
		If WindowExists(i) Then
			If WindowHasInputFocus(i) Then
				current_window = i
				Exit For
			End If
		End If
	next
	
	If WindowExists(current_window) Then
		Window(current_window)
		GetCanvasViewport(1, canvas1_vx, canvas1_vy, canvas1_vw, canvas1_vh)
		Select Case Inkey()
		Case Asc("w")
			If canvas1_offset_y[current_window] - canvas1_move_speed >= 0 Then
				canvas1_offset_y[current_window] = canvas1_offset_y[current_window] - canvas1_move_speed
			End If
		Case Asc("a")
			If canvas1_offset_x[current_window] - canvas1_move_speed >= 0 Then
				canvas1_offset_x[current_window] = canvas1_offset_x[current_window] - canvas1_move_speed
			End If
		Case Asc("s")
			If canvas1_offset_y[current_window] + canvas1_move_speed < (canvas1_h - canvas1_vh) Then
				canvas1_offset_y[current_window] = canvas1_offset_y[current_window] + canvas1_move_speed
			End If
		Case Asc("d")
			If canvas1_offset_x[current_window] + canvas1_move_speed < (canvas1_w - canvas1_vw) Then
				canvas1_offset_x[current_window] = canvas1_offset_x[current_window] + canvas1_move_speed
			End If
		End Select
		
		cvx1 = canvas1_vx
		cvy1 = canvas1_vy
		
		If Key(K_UP) Then
			cvy1 = canvas1_vy - 2
		ElseIf Key(K_DOWN) Then
			cvy1 = canvas1_vy + 2
		End If
		
		If Key(K_LEFT) Then
			cvx1 = canvas1_vx - 2
		ElseIf Key(K_RIGHT) Then
			cvx1 = canvas1_vx + 2
		End If
		
		SetCanvasViewport(1, cvx1, cvy1, canvas1_vw, canvas1_vh)
		SetCanvasOffset(1, canvas1_offset_x[current_window], canvas1_offset_y[current_window])
	End If
	
	for i = 0 to 7
		test_window(i)
	next
	
	For i = 0 to 7 step 2
		If WindowExists(i) Then
			Window(i)
			Canvas(2)
			DrawImage(sprite1_image, sprite1_x[i], sprite1_y[i])
		End If
	Next
	
	sprite1_angle = (sprite1_angle+2) Mod 360
	
	For i = 1 to 7 step 2
		If WindowExists(i) Then
			Window(i)
			Canvas(2)
			ClearCanvas
			DrawImage_Rotate(sprite1_image, sprite1_x[i], sprite1_y[i], sprite1_angle)
		End If
	Next
	
	If Key(K_F) Then
		Print "FPS = ";FPS
	End If
	
	UpdateAllWindows
	
Wend

WindowClose(0)

End 44
