'Open a 640x480 Window in the middle of the screen
WindowOpen(0, "Simple GFX Example", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480, 0)

'Opens a 640x480 canvas with a 640x480 viewport that is positioned at (0,0) in the window
CanvasOpen(0, 640, 480, 0, 0, 640, 480, 0)

'Sets Current Drawing Canvas to 0
Canvas(0)

'Sets Drawing Color to Red
SetColor( RGB(255,0,0) )

'Draw a 70x40 rectangle at (20,30) in the Canvas
Rect(20,30,70,40)

'Updates all events and draw calls in the window
Update

'Waits for a key to be pressed, Update() is not needed with waitkey as it loops internally
'and polls events waiting for a key to be pressed
WaitKey
