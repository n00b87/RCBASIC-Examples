'---------------------------------------------------------
'Tile Scrolling and Canvas Viewport Demo
'by n00b on rcbasic.freeforums.nent

'Press Esc to exit.

'This was coded in RCBasic
'http://www.rcbasic.com
'--------------------------------------------------------  

viewport_width_inPixels = 320
viewport_height_inPixels = 200

WindowOpen(0, "TILE", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480, WINDOW_VISIBLE, 1)

CanvasOpen(0, viewport_width_inPixels, viewport_height_inPixels, 100, 100, viewport_width_inPixels, viewport_height_inPixels, 0)

Dim tst_map[15, 10]

Dim x
Dim y

f = FreeFile
FileOpen(f, "tst_map.txt", TEXT_INPUT)

tst_map_line$ = ""

While Not EOF(f)
	tst_map_line$ = Trim(ReadLine(f))
	x = 0
	
	If tst_map_line$ = "" Then
		Exit While
	End If
	
	For i = 0 To Length(tst_map_line)-1
		If Mid(tst_map_line, i, 1) = " " Then
			x = x + 1
		Else
			tst_map[x, y] = Val(Mid(tst_map_line, i, 1))
		End If
	Next
	y = y + 1
Wend

LoadImage(0, "t1.png")
LoadImage(1, "t2.png")

map_width_inTiles = 15
map_height_inTiles = 10

tile_width_inPixels = 64
tile_height_inPixels = 64

viewport_width_inPixels = 320
viewport_height_inPixels = 200

map_width_inPixels = map_width_inTiles * tile_width_inPixels
map_height_inPixels = map_height_inTiles * tile_height_inPixels

viewport_width_inTiles = viewport_width_inPixels / tile_width_inPixels
viewport_height_inTiles = viewport_height_inPixels / tile_height_inPixels

camera_x_inPixels = 0
camera_y_inPixels = 0

sub render_map()
	start_tile_x = Int( camera_x_inPixels / tile_width_inPixels )
	start_tile_y = Int( camera_y_inPixels / tile_height_inPixels )
	
	start_tile_offset_x = camera_x_inPixels Mod tile_width_inPixels
	start_tile_offset_y = camera_y_inPixels Mod tile_height_inPixels
	
	For y = start_tile_y to (start_tile_y + viewport_height_inTiles)
		For x = start_tile_x to (start_tile_x + viewport_width_inTiles)
			screen_x = (x - start_tile_x) * tile_width_inPixels - start_tile_offset_x
			screen_y = (y - start_tile_y) * tile_height_inPixels - start_tile_offset_y
			
			If tst_map[x, y] = 1 Then
				DrawImage(0, screen_x, screen_y)
			ElseIf tst_map[x, y] = 2 Then
				DrawImage(1, screen_x, screen_y)
			End If
		Next
	Next
end sub

While Not Key(K_ESCAPE)
	ClearCanvas
	render_map
	
	If Key(K_RIGHT) And (camera_x_inPixels + 2) < (map_width_inPixels - viewport_width_inPixels) Then
		camera_x_inPixels = camera_x_inPixels + 2
	ElseIf Key(K_LEFT) And (camera_x_inPixels) >= 0 Then
		camera_x_inPixels = camera_x_inPixels - 2
	End IF
	
	If Key(K_DOWN) And (camera_y_inPixels + 2) < (map_height_inPixels - viewport_height_inPixels) Then
		camera_y_inPixels = camera_y_inPixels + 2
	ElseIf Key(K_UP) And (camera_y_inPixels) >= 0 Then
		camera_y_inPixels = camera_y_inPixels - 2
	End IF
	
	'Border
	SetColor(rgb(255,255,255))
	Rect(0, 0, 319, 199)
	
	Update
Wend
