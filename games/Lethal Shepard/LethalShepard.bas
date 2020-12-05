'
'Lethal Shepard
'
'by n00b on rcbasic forums
'@n00b on rcbasic.freeforums.net
'
'This was coded in RCBasic
'http://www.rcbasic.com
'
'This is a game I made for Ludum Dare 46
'
'The controls:
'Move - Arrow Keys
'Shoot - SPACE
'
'--------------------------------------------------------  

Include "sprite.bas"

Dim Pallete[16]
Pallete[0] = HexVal("FF000000")
Pallete[1] = HexVal("FFFFFFFF")
Pallete[2] = HexVal("FF883932")
Pallete[3] = HexVal("FF67b6bd")
Pallete[4] = HexVal("FF8b3f96")
Pallete[5] = HexVal("FF55a049")
Pallete[6] = HexVal("FF40318d")
Pallete[7] = HexVal("FFbfce72")
Pallete[8] = HexVal("FF8b5429")
Pallete[9] = HexVal("FF574200")
Pallete[10] = HexVal("FFb86962") ''
Pallete[11] = HexVal("FF505050")
Pallete[12] = HexVal("FF787878")
Pallete[13] = HexVal("FF94e089")
Pallete[14] = HexVal("FF7869c4")
Pallete[15] = HexVal("FF9f9f9f")

bullet_sprite[0,0] = Pallete[1]
bullet_sprite[0,1] = Pallete[1]
bullet_sprite[1,0] = Pallete[1]
bullet_sprite[1,1] = Pallete[1]

Randomize(Timer)

WindowOpen(0, "Lethal Shepard", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 320, 200, 1)
CanvasOpen(0, 320, 200, 0, 0, 320, 200, 0)
SetClearColor(RGB(0,200,0))
LoadFont(0, "prstart.ttf", 10)

shepard_frame = 0
wolf_frame = 0
sheep_frame = 0

Dim shepard[2]
Dim wolf[2]
Dim sheep[2]

shepard[0] = 0
shepard[1] = 1

wolf[0] = 2
wolf[1] = 3

sheep[0] = 4
sheep[1] = 5

bullet = 6

ImageFromBuffer_Ex(shepard[0], 16, 16, shepard_frame1, 0)
ImageFromBuffer_Ex(shepard[1], 16, 16, shepard_frame2, 0)
ImageFromBuffer_Ex(wolf[0], 16, 16, wolf_frame1, 0)
ImageFromBuffer_Ex(wolf[1], 16, 16, wolf_frame2, 0)
ImageFromBuffer_Ex(sheep[0], 16, 16, sheep_frame1, 0)
ImageFromBuffer_Ex(sheep[1], 16, 16, sheep_frame2, 0)
ImageFromBuffer(bullet, 2, 2, bullet_sprite)

Dim Wolf_X[10]
Dim Wolf_Y[10]
Dim Wolf_Target[10]
Dim Wolf_Speed[10]
Dim Wolf_Status[10]
Dim Wolf_Status_Timer

Dim Sheep_X[3]
Dim Sheep_Y[3]
Dim Sheep_Status[3]
Dim Sheep_Speed[3]
Dim Sheep_Status_Timer

Dim Player_X
Dim Player_Y

Player_X = 10
Player_Y = 110
Player_Speed = 1

Dim Bullet_X[10]
Dim Bullet_Y[10]
Dim Bullet_Status[10]
Bullet_Time = 0

Dim Farm_X: Farm_X = 300
Dim Farm_Y: Farm_Y = 50
Dim Farm_W: Farm_W = 20
Dim Farm_H: Farm_H = 100

Frame_Timer = Timer
Frame_Swap = 1000/12
Frame = 0

DIFF_Time = 0
Wolf_Wait_Time = 2000

NUM_WOLVES = 5
NUM_SHEEP = 3
NUM_BULLETS = 10

Score = 0
Sheep_Killed = 0

Game_isOver = False

Sub GameOver()
	Game_isOver = True
End Sub

Sub GetFrame()
	If Timer - Frame_Timer >= Frame_Swap Then
		Frame = Not Frame
		Frame_Timer = Timer
	End If
End Sub

Sub Wolf_Act()
	If Timer - DIFF_Time > 10000 And NUM_WOLVES < 9 Then
		NUM_WOLVES = NUM_WOLVES + 1
		DIFF_Time = Timer
		Wolf_Wait_Time = Wolf_Wait_Time - 100
	End If
	
	For i = 0 to NUM_WOLVES-1
		If Wolf_Status[i] = 0 And Timer - Wolf_Status_Timer > Wolf_Wait_Time Then
			Wolf_Status[i] = 1
			Wolf_X[i] = Rand(10) * 27
			Wolf_Y[i] = Rand(2) * 216 - 16
			Wolf_Speed[i] = 0.5
			Wolf_Status_Timer = Timer
			Wolf_Target[i] = Int(Rand(3))
			'Return
		ElseIf Wolf_Status[i] Then
			If Not Sheep_Status[Wolf_Target[i]] Then
				Select Case Wolf_Target[i]
				Case 0: Wolf_Target[i] = 1
				Case 1: Wolf_Target[i] = 2
				Case 2: Wolf_Target[i] = 0
				End Select
			End If
			
			If Wolf_X[i] <  Sheep_X[Wolf_Target[i]] And Wolf_X[i]+Wolf_Speed[i] < Farm_X-16 Then
				Wolf_X[i] = Wolf_X[i] + Wolf_Speed[i]
			ElseIf Wolf_X[i] > Sheep_X[Wolf_Target[i]] Then
				Wolf_X[i] = Wolf_X[i] - Wolf_Speed[i]
			End If
			
			If Wolf_Y[i] <  Sheep_Y[Wolf_Target[i]] Then
				Wolf_Y[i] = Wolf_Y[i] + Wolf_Speed[i]
			ElseIf Wolf_Y[i] > Sheep_Y[Wolf_Target[i]] Then
				Wolf_Y[i] = Wolf_Y[i] - Wolf_Speed[i]
			End If
			
			For n = 0 to NUM_SHEEP-1
				If Sheep_Status[n] And Abs(Sheep_X[n] - Wolf_X[i]) <= 4 And Abs(Sheep_Y[n] - Wolf_Y[i]) <= 4 Then
					Sheep_Status[n] = 0
					Sheep_Killed = Sheep_Killed + 1
					If Sheep_Killed > 5 Then
						GameOver()
						Return
					End If
				End If
			Next
			
			DrawImage(wolf[Frame], Wolf_X[i],  Wolf_Y[i])
			
		End If
	Next
	
	
End Sub

Sub Sheep_Act()
	For i = 0 to NUM_SHEEP-1
		If Sheep_Status[i] = 0 And (Timer - Sheep_Status_Timer > 2000) Then
			Sheep_Status[i] = 1
			Sheep_X[i] = -16
			Sheep_Y[i] = Rand(100) + Farm_Y
			Sheep_Speed[i] = 1
			Sheep_Status_Timer = Timer
		ElseIf Sheep_Status[i] Then
		
			If Sheep_X[i] < Farm_X Then
				Sheep_X[i] = Sheep_X[i] + Sheep_Speed[i]
			Else
				Sheep_Status[i] = 0
				Score = Score + 10
			End If
			
			DrawImage(sheep[Frame], Sheep_X[i], Sheep_Y[i])
			
		End If
	Next
End Sub

Sub Player_Act()
	If Key(K_UP) And Player_Y - Player_Speed > 0 Then
		Player_Y = Player_Y - Player_Speed
	ElseIf Key(K_DOWN) And Player_Y + Player_Speed < 184 Then
		Player_Y = Player_Y + Player_Speed
	End If
	
	If Key(K_LEFT) And Player_X - Player_Speed > 0 Then
		Player_X = Player_X - Player_Speed
	ElseIf Key(K_RIGHT) And Player_X + Player_Speed < Farm_X Then
		Player_X = Player_X + Player_Speed
	End If
	
	If Key(K_SPACE) And (Timer - Bullet_Time) > 500 Then
		For i = 0 to NUM_BULLETS-1
			If Bullet_Status[i] = 0 Then
				Bullet_Status[i] = 1
				Bullet_X[i] = Player_X + 15
				Bullet_Y[i] = Player_Y + 6
				Bullet_Time = Timer
				Exit For
			End If
		Next
	End If
	
	SetColor(Pallete[13])
	
	dbg = 0
	
	For i = 0 to NUM_BULLETS-1
		If Bullet_Status[i] Then
			dbg = dbg + 1
			If Bullet_X[i] > Farm_X Then
				Bullet_Status[i] = 0
			Else
				Bullet_X[i] = Bullet_X[i] + 2
				For n = 0 to NUM_WOLVES-1
					If Wolf_Status[n] And (Bullet_X[i]>=Wolf_X[n] And Bullet_X[i]<Wolf_X[n]+16) And (Bullet_Y[i]>=Wolf_Y[n] And Bullet_Y[i]<Wolf_Y[n]+16) Then
						Wolf_Status[n] = 0
						Bullet_Status[i] = 0
						Score = Score + 5
					End If
				Next
			End If
			DrawImage(bullet, Bullet_X[i], Bullet_Y[i])
		End If
	Next
	'Print "Num Bullets on Screen: ";dbg
	DrawImage(shepard[Frame], Player_X, Player_Y)
	
End Sub

Sub DrawFarm()
	SetColor(Pallete[2])
	RectFill(Farm_X, Farm_Y, Farm_W, Farm_H)
End Sub

Sub DrawScore()
	SetColor(Pallete[1])
	DrawText("Num Killed: " + STR(Sheep_Killed), 10, 10)
	DrawText("SCORE: " + STR(SCORE), 200, 10)
End Sub

While Not Key(K_ESCAPE) And Not Game_isOver
	ClearCanvas
	
	GetFrame
	DrawFarm
	Player_Act
	Wolf_Act
	Sheep_Act
	DrawScore
	Update
	Wait(5)
Wend

ClearCanvas
SetColor(Pallete[1])
DrawText("GAME OVER", 100, 100)
DrawText("FINAL SCORE: "+STR(SCORE), 100, 130)
Update

Wait(500)
WaitKey

End
