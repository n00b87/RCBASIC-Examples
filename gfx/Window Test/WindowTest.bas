WindowOpen(0, "Test 0", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480, WINDOW_VISIBLE, 1)
WindowOpen(1, "Test 1", 20, 20, 640, 480, WINDOW_VISIBLE, 1)

Window(0)
Cls
Update
CanvasOpen(0, 640, 480, 0, 0, 640, 480, 0)

Window(1)
Cls
Update
CanvasOpen(0, 640, 480, 0, 0, 640, 480, 0)


LoadFont(0, "FreeMono.ttf", 16)

'PRESS ENTER TO SEE TEXT IN SELECTED WINDOW

While true
	If WindowHasMouseFocus(0) Then
		Window(0)
		Canvas(0)
		ClearCanvas
		If Key(K_RETURN) Then
			SetColor(rgb(0,255,0))
			Locate(10,10)
			BoxFill(20, 20, 50, 50)
			DrawText("Window 0 Test", 100, 100)
		ElseIf Key(K_ESCAPE) Then
			Exit While
		End If
		
	End If
	If WindowHasMouseFocus(1) Then
		Window(1)
		Canvas(0)
		ClearCanvas
		If Key(K_RETURN) Then
			SetColor(RGB(255,0,0))
			Locate(10,10)
			BoxFill(20, 20, 50, 50)
			DrawText("Window 1 Test", 100, 100)
		ElseIf Key(K_ESCAPE) Then
			Exit While
		End If
	End If
	Update
Wend


WindowClose(1)
WindowClose(0)
End
