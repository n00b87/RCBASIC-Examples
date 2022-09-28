Sub pointer(ByRef x, ByRef y, ByRef b1, ByRef b2, ByRef b3)
	Select Case OS
	Case "ANDROID","IOS"
		GetTouchFinger(0, x, y, b1)
		b1 = b1 <> 0
	Default
		GetMouse(x, y, b1, b2, b3)
	End Select
End Sub

Sub waitRelease()
	Dim x
	Dim y
	Dim b1
	Dim b2
	Dim b3
	pointer(x, y, b1, b2, b3)
	While b1 Or b2 Or b3
		pointer(x, y, b1, b2, b3)
		Update
	Wend
End Sub

Dim Video_Canvas : Video_Canvas = 0
Dim Gui_Canvas : Gui_Canvas = 1

Dim video_length
Dim video_fps
Dim video_w
Dim video_h

Dim pbar_x
Dim pbar_y
Dim pbar_w
Dim pbar_h

Dim slider_x
Dim slider_y
Dim slider_w
Dim slider_h

ProgressBar_BKG_Color = RGB(0,0,120)
ProgressBar_Slider_Color = RGB(0, 120, 120)

Sub DrawProgressBar(x, y, w, h)
	SetColor(ProgressBar_BKG_Color)
	pbar_x = x
	pbar_y = y
	pbar_w = w
	pbar_h = h
	RectFill(x, y, w, h)
	SetColor(ProgressBar_Slider_Color)
	slider_x = x + (VideoPosition() / video_length) * (w-10)
	slider_y = y + 2
	slider_w = 10
	slider_h = h - 4
	RectFill(slider_x, slider_y, slider_w, slider_h)
End Sub

Sub ProgressBar_Events(x, y)
	If y >= pbar_y And y < (pbar_y + pbar_h) Then
		If ( x < slider_x Or x > (slider_x + slider_w) ) Then
			new_pos = ( (x - pbar_x) / pbar_w ) * video_length
			SetVideoPosition(new_pos)
		End If
	End If
End Sub

Dim button_image[3]
Dim button_image_w
Dim button_image_h
For i = 0 to 2
	button_image[i] = i
Next

Dim button_action$[3]

Dim button_x[3]
Dim button_y[3]

Dim button_w
Dim button_h

Sub LoadAssets()
	asset_dir$ = ""
	If OS = "WINDOWS" Then
		asset_dir$ = "assets\\"
	Else
		asset_dir$ = "assets/"
	End If
	LoadImage(button_image[0], asset_dir$ + "play.png")
	LoadImage(button_image[1], asset_dir$ + "pause.png")
	LoadImage(button_image[2], asset_dir$ + "stop.png")
	
	GetImageSize(button_image[0], button_image_w, button_image_h)
	
	button_w = 100
	button_h = 100
	
	button_action[0] = "play"
	button_action[1] = "pause"
	button_action[2] = "stop"
End Sub

Sub DrawButtons(x, y)
	For i = 0 to 2
		button_x[i] = x + (i*button_w)
		button_y[i] = y
		DrawImage_Blit_Ex(button_image[i], button_x[i], button_y[i], button_w, button_h, 0, 0, button_image_w, button_image_h)
	Next
End Sub

Dim STATUS_PLAYING : STATUS_PLAYING = 1
Dim STATUS_PAUSED : STATUS_PAUSED = 2
Dim STATUS_STOPPED : STATUS_STOPPED = 0

Dim button_current_status : button_current_status = STATUS_STOPPED

Sub Button_Events(x, y, ByRef current_status)
	If y >= button_y[0] And y < (button_y[0] + button_h) Then
		For i = 0 to 2
			If  x >= button_x[i] And x < (button_x[i] + button_w) Then
				Select Case button_action[i]
				Case "play"
					Select Case current_status
					Case STATUS_PAUSED
						ResumeVideo
						current_status = STATUS_PLAYING
					Case STATUS_STOPPED
						PlayVideo(1)
						current_status = STATUS_PLAYING
					Default
						Return
					End Select
				Case "pause"
					Select Case current_status
					Case STATUS_PLAYING
						PauseVideo
						current_status = STATUS_PAUSED
						Print "PAUSING"
					Default
						Return
					End Select
				Case "stop"
					StopVideo
					current_status = STATUS_STOPPED
					Print "STOP VIDEO"
				End Select
			End If
		Next
	End If
End Sub

Sub VideoPlayer_Update()
	Canvas(Gui_Canvas)
	ClearCanvas
	SetColor(RGB(160, 160, 160))
	RectFill(0, 320, 640, 160)
	DrawProgressBar(20, 320, 600, 20)
	DrawButtons(200, 350)
	
	Dim mx
	Dim my
	Dim mb1
	Dim mb2
	Dim mb3
	
	pointer(mx, my, mb1, mb2, mb3)
	
	If mb1 Then
		ProgressBar_Events(mx, my)
		Button_Events(mx, my, button_current_status)
	End If
	
	Canvas(Video_Canvas)
	Update()
End Sub

'440

WindowOpen(0, "Video Demo", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480, WINDOW_VISIBLE, 1)

LoadAssets

CanvasOpen(Video_Canvas, 640, 480, 0, 0, 640, 480, 0)
CanvasOpen(Gui_Canvas, 640, 480, 0, 0, 640, 480, 1)

SetCanvasZ(Video_Canvas, 7)
SetCanvasZ(Gui_Canvas, 6)

SetColor(RGB(255,255,255))

Canvas(0)
Prints("GET VIDEO INFO")
GetVideoStats("bunny.ogg", video_length, video_fps, video_w, video_h)
'video_length = 18000
'video_fps = 60
'video_w = 640
'video_h = 480
Prints("LOADING VIDEO")
LoadVideo("bunny.ogg")
Prints("STARTING PLAYER")
Wait(200)
Cls

SetVideoDrawRect(120, 10, 400, (400/640) * 480)

x = 0
y = 50

While Not Key(K_ESCAPE)

	VideoPlayer_Update

Wend

DeleteVideo
WindowClose(0)

