OpenWindow("Keyboard/Mouse Test", 640, 480, 0, 1)
m_canvas = OpenCanvas(640, 480, 0, 0, 640, 480, 0)

SetColor(RGB(255,255,255))

x = 100
y = 100

m_font = LoadFont("FreeMono.ttf", 12)
SetFont(m_font)

Dim mouse_x
Dim mouse_y
Dim button1
Dim button2
Dim button3
Dim wheelx
Dim wheely

While Not Key(K_ESCAPE)
	ClearCanvas
	
	SetColor(RGB(255,255,255))
	DrawText("Use the arrow keys to move the box around", 10, 10)
	DrawText("Left Click to change box color", 10, 30)

	wheelx = 0
	wheely = 0
	GetMouseWheel(wheelx, wheely)
	GetMouse(mouse_x, mouse_y, button1, button2, button3)
	DrawText("Mouse Position: " + Str$(mouse_x) + ", " + Str$(mouse_y), 10, 50)
	DrawText("Mouse Button1 = " + Str$(button1), 10, 70)
	DrawText("Mouse Button2 = " + Str$(button2), 10, 90)
	DrawText("Mouse Button3 = " + Str$(button3), 10, 110)
	DrawText("MouseWheelX = " + Str$(wheelx), 10, 130)
	DrawText("MouseWheelY = " + Str$(wheely), 10, 150)
	
	DrawText("Press ESC to exit", 10, 170)
	
	DrawText("MouseXY: " + Str(MouseX) + ", " + Str(MouseY), 480, 10)
	
	If Key(K_UP) Then
		y = y - 1
	ElseIf Key(K_DOWN) Then
		y = y + 1
	End If
	
	If Key(K_LEFT) Then
		x = x - 1
	ElseIf Key(K_RIGHT) Then
		x = x + 1
	End If
	
	If MouseButton(1) Then
		SetColor(RGB(0,255,0))
	End If
	
	RectFill(x, y, 50, 50)
	Update
Wend

CloseWindow()
End
