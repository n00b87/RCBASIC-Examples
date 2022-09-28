WindowOpen(0, "Keyboard Example", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480, WINDOW_VISIBLE, 1)
CanvasOpen(0, 640, 480, 0, 0, 640, 480, 0)

SetColor(RGB(255,255,255))

While Not Key(K_ESCAPE)
	Cls
	Locate(30, 20)
	K = Inkey
	C$ = ""	
	Select Case K
		Case K_SPACE
			C$ = "SPACE"
		Case K_LALT
			C$ = "LEFT ALT"
		Case K_RALT
			C$ = "RIGHT ALT"
		Case K_LCTRL
			C$ = "LEFT CTRL"
		Case K_RCTRL
			C$ = "RIGHT CTRL"		
		Case K_LSHIFT
			C$ = "LEFT SHIFT"
		Case K_RSHIFT
			C$ = "RIGHT SHIFT"
		Case K_TAB
			C$ = "TAB"
		Case K_RETURN
			C$ = "ENTER"
		Case K_BACKSPACE
			C$ = "BACKSPACE"
		Case K_UP
			C$ = "UP ARROW"
		Case K_LEFT
			C$ = "LEFT ARROW"
		Case K_RIGHT
			C$ = "RIGHT ARROW"
		Case K_DOWN
			C$ = "DOWN ARROW"
		Case K_DELETE
			C$ = "DELETE"
		Case K_INSERT
			C$ = "INSERT"
		Case K_HOME
			C$ = "HOME"
		Case K_END
			C$ = "END"
		Case K_PAGEUP
			C$ = "PAGE UP"
		Case K_PAGEDOWN
			C$ = "PAGEDOWN"
		Default
			C$ = Chr$(K)
	End Select
		
		
	PrintS("Key = " + C$)
	Update
Wend
