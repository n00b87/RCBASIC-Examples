WindowOpen(0, "Key Test", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480, 0)
CanvasOpen(0, 640, 480, 0, 0, 640, 480, 0)

SetColor(RGB(255,255,255))

x = 100
y = 100

PrintS("Use the arrow keys to move the box around")
PrintS("Press ESC to exit")

While Not Key(K_ESCAPE)
	ClearCanvas
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
	
	RectFill(x, y, 50, 50)
	Update
Wend

WindowClose(0)
End
