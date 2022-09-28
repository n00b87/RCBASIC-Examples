Dim button[8]
button_size = 64
button_y = 400

Dim cmod[2]

current_cmod = 0
cmod_timer = Timer

MOBILE_BUTTONS_IMAGE = 1


Dim touch_status
Dim touch_x
Dim touch_y
Dim touch_dx
Dim touch_dy

Dim MB_UP : MB_UP = 1
Dim MB_DOWN : MB_DOWN = 2
Dim MB_LEFT : MB_LEFT = 0
Dim MB_RIGHT : MB_RIGHT = 3

Dim MB_W : MB_W = 5
Dim MB_A : MB_A = 4
Dim MB_S : MB_S = 6
Dim MB_D : MB_D = 7

function button_pressed(b)
	If touch_x >= button[b] And touch_x < (button[b] + button_size) And touch_y >= button_y And touch_y < (button_y + button_size) Then
		Return True
	End If
	Return False
end function


function mobile_button(b)
	GetTouch(touch_status, touch_x, touch_y, touch_dx, touch_dy)
	
	If touch_status Then
		return button_pressed(b)
	End If
end function



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

Print "BEFORE Canvas2 Offset ArrayDim = ";ArrayDim(canvas2_offset_x);" x ";ArrayDim(canvas2_offset_y) /' Multi-line comment on a single line'/
Print "BEFORE Canvas2 Offset ArraySize = ";ArraySize(canvas2_offset_x, 1);" x ";ArraySize(canvas2_offset_y, 1)

ReDim canvas2_offset_x[8], canvas2_offset_y[8] /'carrying multi-line comment over multiple lines

'/Print "AFTER Canvas2 Offset ArrayDim = ";ArrayDim(canvas2_offset_x);" x ";ArrayDim(canvas2_offset_y)
Print "AFTER Canvas2 Offset ArraySize = ";ArraySize(canvas2_offset_x, 1);" x ";ArraySize(canvas2_offset_y, 1)

sub init()
	LoadFont(0, "prstart.ttf", 16)
	LoadFont(1, "FreeMono.ttf", 12)
	CanvasOpen(0, 640, 480, 0, 0, 640, 480, 1)
	CanvasOpen(1, 400, 400, 100, 100, 200, 200, 1)
	CanvasOpen(2, 400, 400, 300, 300, 200, 200, 1)
	CanvasOpen(3, 640, 480, 0, 0, 640, 480, 1)
	LoadImage_Ex(sprite1_image, "sprite1.png", -1)
	
	'ColorKey(sprite1_image, RGB(127, 127, 127))
	'Locate(20,20)
	
	Canvas(3)
	'If UCase(OS) = "ANDROID" Or UCase(OS) = "IOS" Then
		LoadImage(MOBILE_BUTTONS_IMAGE, "mobile_buttons.png")
		For i = 0 to 7
			button[i] = 20 + (i*button_size) + (i*4)
			DrawImage_Blit(MOBILE_BUTTONS_IMAGE, button[i], button_y, i * button_size, 0, button_size, button_size)
		Next
	'End If
	Canvas(0)
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
	
	'Canvas(3)
	SetColor(RGB(255,255,255))
	Font(0)
	DrawText("Colorkey = " + Str_F(RGB(0, 162, 232)), 30, 400)
	
	Canvas(3)
	For i = 0 to 7
		button[i] = 20 + (i*button_size) + (i*4)
		DrawImage_Blit(MOBILE_BUTTONS_IMAGE, button[i], button_y, i * button_size, 0, button_size, button_size)
	Next
	
	update
	return win
end function

WindowOpen(0, "test", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480, WindowMode(visible, fullscreen, resizable, borderless, highDPI), vsync)
Cls

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

Canvas(3)
SetClearColor(0)
ClearCanvas

SetColor(RGB(255,0,0))
RectFill(450, 50, 50, 50)

SetColor(RGB(0,255,0))
RectFill(450, 150, 50, 50)

SetColor(RGB(0,0,255))
RectFill(450, 250, 50, 50)

Update()

c = GetPixel(455, 65)
SetColor(c)
Print "Color dbu = ";c
RectFill(550, 50, 50, 50)

c = GetPixel(455, 155)
SetColor(c)
RectFill(550, 150, 50, 50)

c = GetPixel(455, 255)
SetColor(c)
RectFill(550, 250, 50, 50)

Update()

sprite1_x[1] = 20
sprite1_y[1] = 20


While WindowExists(0)
	
	GetCanvasViewport(1, canvas1_vx, canvas1_vy, canvas1_vw, canvas1_vh)
	
	If mobile_button(MB_W) Then
		If canvas1_offset_y[current_window] - canvas1_move_speed >= 0 Then
			canvas1_offset_y[current_window] = canvas1_offset_y[current_window] - canvas1_move_speed
		End If
	ElseIf mobile_button(MB_A) Then
		If canvas1_offset_x[current_window] - canvas1_move_speed >= 0 Then
			canvas1_offset_x[current_window] = canvas1_offset_x[current_window] - canvas1_move_speed
		End If
	ElseIf mobile_button(MB_S) Then
		If canvas1_offset_y[current_window] + canvas1_move_speed < (canvas1_h - canvas1_vh) Then
			canvas1_offset_y[current_window] = canvas1_offset_y[current_window] + canvas1_move_speed
		End If
	ElseIf mobile_button(MB_D) Then
		If canvas1_offset_x[current_window] + canvas1_move_speed < (canvas1_w - canvas1_vw) Then
			canvas1_offset_x[current_window] = canvas1_offset_x[current_window] + canvas1_move_speed
		End If
	End If
	
	cvx1 = canvas1_vx
	cvy1 = canvas1_vy
	
	If mobile_button(MB_UP) Then
		cvy1 = canvas1_vy - 2
	ElseIf mobile_button(MB_DOWN) Then
		cvy1 = canvas1_vy + 2
	End If
	
	If mobile_button(MB_LEFT) Then
		cvx1 = canvas1_vx - 2
	ElseIf mobile_button(MB_RIGHT) Then
		cvx1 = canvas1_vx + 2
	End If
		
	SetCanvasViewport(1, cvx1, cvy1, canvas1_vw, canvas1_vh)
	SetCanvasOffset(1, canvas1_offset_x[current_window], canvas1_offset_y[current_window])
	
	test_window(0)
	
	
	Canvas(2)
	DrawImage(sprite1_image, sprite1_x[0], sprite1_y[0])
	
	sprite1_angle = (sprite1_angle+2) Mod 360
	
	Canvas(3)
	ClearCanvas
	DrawImage_Rotate(sprite1_image, sprite1_x[1], sprite1_y[1], sprite1_angle)
	
	
	
	If Key(K_F) Then
		Print "FPS = ";FPS
	End If
	
Wend

WindowClose(0)

End 44
