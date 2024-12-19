hit_sound = LoadSound("Hit_01.wav")

OpenWindow("Sound Example", 640, 480, 0, 0)
m_canvas = OpenCanvas(640, 480, 0, 0, 640, 480, 0)

m_font = LoadFont("FreeMono.ttf", 12)
SetFont(m_font)

SetColor(RGB(255,255,255))
DrawText("Left Click to play sound", 200, 200)

While Not Key(K_ESCAPE)
	If MouseButton(1) Then
		PlaySound(hit_sound, 0, 0)
	End If
	Update
Wend