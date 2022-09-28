mode = WindowMode(1,0,1,0,0)
WindowOpen(0, "Mouse Test", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480, mode, 1)
SetWindowFullscreen(0,1)
CanvasOpen(0, 640, 480, 0, 0, 640, 480, 1)

LoadFont(0, "FreeMono.ttf", 12)

Dim mouse_x
Dim mouse_y
Dim button1
Dim button2
Dim button3
Dim wheelx
Dim wheely

SetColor(RGB(255,255,255))

While Not Key(K_ESCAPE)
	ClearCanvas()
	GetMouseWheel(wheelx, wheely)
	GetMouse(mouse_x, mouse_y, button1, button2, button3)
	DrawText("Mouse Position: " + Str$(mouse_x) + ", " + Str$(mouse_y), 10, 10)
	DrawText("Mouse Button1 = " + Str$(button1), 10, 20)
	DrawText("Mouse Button2 = " + Str$(button2), 10, 30)
	DrawText("Mouse Button3 = " + Str$(button3), 10, 40)
	DrawText("MouseWheelX = " + Str$(wheelx), 10, 60)
	DrawText("MouseWheelY = " + Str$(wheely), 10, 70)
	Update()
Wend

WindowClose(0)
End
