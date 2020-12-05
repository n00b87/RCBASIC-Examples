WindowOpen(0, "Video Demo", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480, 0)
CanvasOpen(0, 640, 480, 0, 0, 640, 480, 0)
CanvasOpen(1, 640, 480, 0, 0, 640, 480, 1)

SetCanvasZ(0, 7)
SetCanvasZ(1, 6)

Canvas(0)
LoadVideo("bus.ogg")
PlayVideo(1)

x = 0
y = 50

While Not VideoEnd

If Key(K_LEFT) Then
	x = x - 1
ElseIf Key(K_RIGHT) Then
	x = x + 1
End If

If Key(K_UP) Then
	y = y - 1
ElseIf Key(K_DOWN) Then
	y = y + 1
End If

If Key(K_SPACE) Then
	SetVideoPosition(13000)
ElseIf Key(K_P) Then
	PauseVideo
ElseIf Key(K_R) Then
	ResumeVideo
End If

Canvas(1)
ClearCanvas
SetColor(RGB(0,0,255))
RectFill(x, y, 50, 50)

Canvas(0)

Update()

'Print "VPOS = ";VideoPosition
Wend
WindowClose(0)
