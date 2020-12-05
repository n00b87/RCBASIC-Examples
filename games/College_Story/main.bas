'
'College Story
'
'by n00b on rcbasic forums
'@n00b on rcbasic.freeforums.net
'
'This was coded in RCBasic
'http://www.rcbasic.com
'
'This is a game I made for Ludum Dare 42
'The goal is to answer the question on the bottom by getting the correct letter
'
'The controls:
'Move - Arrow Keys
'
'--------------------------------------------------------  

Randomize(Timer)

NO_HIT = 255

Dim Error_SFX
Dim Score_SFX

Dim Title_Image
Dim Credits_Image

Dim Score_Sprite
Dim Score_Frame_Delay
Dim Score_Current_Frame
Dim Score_Current_Frame_Time

Dim Wrong_Sprite
Dim Wrong_Current_Frame_Time

Dim Explode_Sprite
Dim Explode_Frame_Delay
Dim Explode_Current_Frame

Dim Player[4] 'x, y, w, h
Dim Player_Sprite
Dim Player_Frame_W
Dim Player_Frame_H
Dim Player_Current_Frame
Dim Player_Current_Frame_Time
Dim Player_Frame_Delay

Dim Professor_Sprite

MAX_BULLETS = 20

Dim Bullet[MAX_BULLETS, 4] 'x, y, w, h for 20 bullets
Dim Bullet_InAction[MAX_BULLETS]
Dim Bullet_Value[MAX_BULLETS]
Dim Bullet_Speed
Dim Bullet_Sprite
Dim Bullet_Sprite_Offset[MAX_BULLETS]
Dim Bullet_Animation[MAX_BULLETS]
Dim Bullet_Animation_StartTime[MAX_BULLETS]
Dim Bullet_Animation_Current_Frame[MAX_BULLETS]
Dim Bullet_Animation_Current_Time[MAX_BULLETS]
Dim Bullet_Animation_X[MAX_BULLETS]
Dim Bullet_Animation_Y[MAX_BULLETS]

Dim Background_Image

Dim row_y[4]
Dim row_step[4]
Dim row_space[4]

Dim Safety_Bullet[4]

Dim Grade
Dim Chances
Dim Chance_Sprite

MAX_QUESTIONS = 9
Dim Question$[MAX_QUESTIONS]
Dim Choice$[MAX_QUESTIONS, 4]
Dim Answer[MAX_QUESTIONS]
Dim Question_Count
Dim Current_Question

CHOICE_A = 0
CHOICE_B = 1
CHOICE_C = 2
CHOICE_D = 3

Sub AddQuestion(q$, a$, b$, c$, d$, correct_answer)
	Question[Question_Count] = q$
	Choice[Question_Count, 0] = a
	Choice[Question_Count, 1] = b
	Choice[Question_Count, 2] = c
	Choice[Question_Count, 3] = d
	Answer[Question_Count] = correct_answer
	Question_Count = Question_Count + 1
End Sub

Sub DrawQuestion()
	Font(0)
	SetColor(RGB(255,255,255))
	DrawText(Question[Current_Question], 15, 382)
	DrawText("A. " + Choice[Current_Question, 0], 15, 408)
	DrawText("B. " + Choice[Current_Question, 1], 15, 442)
	DrawText("C. " + Choice[Current_Question, 2], 200, 408)
	DrawText("D. " + Choice[Current_Question, 3], 200, 442)
End Sub

AddQuestion("What is the Square Root of 25?", "25", "5", "4", "12.5", CHOICE_B)
AddQuestion("What is the capital of Alabama?","Huntsville","Selma","Montgomery","Tuskegee", CHOICE_C)
AddQuestion("What year did Ludum Dare 41 take place?","2018","2016","2017","2015", CHOICE_A)
AddQuestion("Which of these is closest to the Center of the Earth?","Mantle","Crust","Core","Hydrosphere", 	CHOICE_C)
AddQuestion("What is the base 2 number system used in computers called?", "Hexadecimal", "Octal", "Duey Decimal", "Binary", CHOICE_D)
AddQuestion("What was this game programmed in?","Love2d","LibGDX","RCBasic","Unity", CHOICE_C)
AddQuestion("Which one of the following was an emperor of Rome?","Stalin","Xerces","King Tut","Nero", CHOICE_D)
AddQuestion("Who was the engineer that built the first Apple Computer?","Steve Wozniak","Steve Jobs","Bill Gates","Steve Balmer", CHOICE_A)
AddQuestion("Which punctuation would you use to start a list?","Semi-Colon","Colon","Question Mark","Period", CHOICE_B)

Function PlayerHit() 'Return the enemy hit or NO_HIT if no collision
	'x1, y1 --- x2, y2
	'x3, y3 --- x4, y4
	'Add 13 for x
	'Add 22 to x for w
	px1 = Player[0] + 13
	py1 = Player[1]
	
	px2 = px1 + 22
	py2 = Player[1]
	
	px3 = px1
	py3 = Player[1] + Player[3]
	
	px4 = px2
	py4 = Player[1] + Player[3]
	
	For i = 0 to MAX_BULLETS-1
		bx = Bullet[i, 0]
		by = Bullet[i, 1]
		bw = Bullet[i, 2]
		bh = Bullet[i, 3]
		
		If Bullet_InAction[i] And Bullet_Animation[i] = NO_HIT Then
			'Check Player Top Left
			If px1 > bx And px1 < bx + bw And py1 > by And py1 < by + bh Then
				Return i
			'Check Player Top Right
			ElseIf px2 > bx And px2 < bx + bw And py2 > by And py2 < by + bh Then
				Return i
			'Check Player Bottom Left
			ElseIf px3 > bx And px3 < bx + bw And py3 > by And py3 < by + bh Then
				Return i
			'Check Player Bottom Right
			ElseIf px4 > bx And px4 < bx + bw And py4 > by And py4 < by + bh Then
				Return i
			End If
		End If
	Next
	Return NO_HIT
End Function

Function SafetyHit()
	sx1 = 72
	sy1 = row_y[0] + 4
	
	sx2 = 72
	sy2 = row_y[1] + 4
	
	sx3 = 72
	sy3 = row_y[2] + 4
	
	sx4 = 72
	sy4 = row_y[3] + 4
	
	r1 = 0
	r2 = 0
	r3 = 0
	r4 = 0
	
	
	For i = 0 to MAX_BULLETS-1
		bx = Bullet[i, 0]
		by = Bullet[i, 1]
		bw = Bullet[i, 2]
		bh = Bullet[i, 3]
		
		If Bullet_InAction[i] And Bullet_Animation[i] = NO_HIT Then
			'Check Row 1
			If sx1 > bx  And sy1 > by And sy1 < by + bh Then
				r1 = 1
				Safety_Bullet[0] = i
			'Check Row 2
			ElseIf sx2 > bx And sy2 > by And sy2 < by + bh Then
				r2 = 1
				Safety_Bullet[1] = i
			'Check Row 3
			ElseIf sx3 > bx And sy3 > by And sy3 < by + bh Then
				r3 = 1
				Safety_Bullet[2] = i
			'Check Row 4
			ElseIf sx4 > bx And sy4 > by And sy4 < by + bh Then
				r4 = 1
				Safety_Bullet[3] = i
			End If
		End If
	Next
	
	Return r1 And r2 And r3 And r4
	
End Function

Sub AddBullet(row)
	Dim v
	For i = 0 to MAX_BULLETS-1
		If Not Bullet_InAction[i] Then
			Bullet[i, 0] = 490
			Bullet[i, 1] = row_y[row]
			Bullet[i, 2] = 33
			Bullet[i, 3] = 33
			v = Int(rand(4))
			Select Case v
			Case 0
				Bullet_Value[i] = CHOICE_A
				Bullet_Sprite_Offset[i] = 0
			Case 1
				Bullet_Value$[i] = CHOICE_B
				Bullet_Sprite_Offset[i] = 32
			Case 2
				Bullet_Value$[i] = CHOICE_C
				Bullet_Sprite_Offset[i] = 64
			Default
				Bullet_Value$[i] = CHOICE_D
				Bullet_Sprite_Offset[i] = 96
			End Select
			Bullet_Animation[i] = NO_HIT
			Bullet_InAction[i] = True
			Return
		End If
	Next
End Sub

Sub GameInit()
	Error_SFX = 0
	Score_SFX = 1
	LoadSound(0, "Error.wav")
	LoadSound(1, "Item1A.wav")
	LoadMusic("one_0.mp3")

	LoadFont(0, "FreeMono.ttf", 16)
	SetFontStyle(0, 1)
	
	LoadFont(1, "FreeMono.ttf", 12)
	SetFontStyle(1, 1)
	
	Chances = 4
	Grade = 0
	
	Current_Question = rand(MAX_QUESTIONS)
	
	Player_Sprite = 0
	Bullet_Sprite = 1
	Background_Image = 2
	Explode_Sprite = 3
	Score_Sprite = 4
	Wrong_Sprite = 5
	Professor_Sprite = 6
	Chance_Sprite = 7
	Title_Image = 8
	Credits_Image = 9
	
	LoadImage(Score_Sprite, "score.png")
	LoadImage(Wrong_Sprite, "wrong.png")
	LoadImage(Explode_Sprite, "explode.png")
	LoadImage(Background_Image, "background.png")
	LoadImage(Professor_Sprite, "teacher.png")
	LoadImage(Chance_Sprite, "money.png")
	LoadImage(Title_Image, "title.png")
	LoadImage(Credits_Image, "credits.png")
	
	Score_Frame_Delay = 20
	
	Player_Frame_W = 32
	Player_Frame_H = 32
	LoadImage(Player_Sprite, "player.png")
	Player_Current_Frame_Time = Timer
	Player_Frame_Delay = 100
	
	A_Range = MAX_BULLETS / 4
	B_Range = A_Range + A_Range
	C_Range = B_Range + A_Range
	D_Range = MAX_BULLETS
	
	LoadImage(Bullet_Sprite, "letters.png")
	Bullet_Speed = 4
	For i = 0 to MAX_BULLETS-1
		Bullet_InAction[i] = 0
	Next
	
	row_y[0] = 52
	row_y[1] = 132
	row_y[2] = 210
	row_y[3] = 286
	
	Dim row_min_space
	Dim row_max_space
	Dim row_max
	Dim row_min
	
	row_min_space = 128
	row_max_space = 0
	
	row_max = 0
	row_min = 0
	
	For i = 0 to 3
		row_space[i] = rand(96)+32
		row_step[i] = 0
		If row_space[i] < row_min_space Then
			row_min_space = row_space[i]
			row_min = i
		End If
		If row_space[i] > row_max_space Then
			row_max_space = row_space[i]
			row_max = i
		End If
	Next
	
	If row_max_space - row_min_space < 96 Then
		row_space[row_max] = row_max_space + 64
	End If
	
	Player[0] = 18
	Player[1] = row_y[0]
	Player[2] = 32
	Player[3] = 32
End Sub

Sub GameReset()
	
	Chances = 4
	Grade = 0
	
	Current_Question = rand(MAX_QUESTIONS)
	
	Player_Current_Frame_Time = Timer
	
	Bullet_Speed = 4
	For i = 0 to MAX_BULLETS-1
		Bullet_InAction[i] = 0
	Next
	
	Dim row_min_space
	Dim row_max_space
	Dim row_max
	Dim row_min
	
	row_min_space = 128
	row_max_space = 0
	
	row_max = 0
	row_min = 0
	
	For i = 0 to 3
		row_space[i] = rand(96)+32
		row_step[i] = 0
		If row_space[i] < row_min_space Then
			row_min_space = row_space[i]
			row_min = i
		End If
		If row_space[i] > row_max_space Then
			row_max_space = row_space[i]
			row_max = i
		End If
	Next
	
	If row_max_space - row_min_space < 96 Then
		row_space[row_max] = row_max_space + 64
	End If
	
	Player[0] = 18
	Player[1] = row_y[0]
End Sub

Sub BulletUpdate()
	For i = 0 to 3
		If row_step[i] >= row_space[i] Then
			AddBullet(i)
			row_step[i] = 0
			row_space[i] = rand(96)+32
		Else
			row_step[i] = row_step[i] + 1
		End If
	Next
	
	Dim row_min_space
	Dim row_max_space
	Dim row_max
	Dim row_min
	
	row_min_space = 128
	row_max_space = 0
	
	row_max = 0
	row_min = 0
	
	For i = 0 to 3
		If row_space[i] < row_min_space Then
			row_min_space = row_space[i]
			row_min = i
		End If
		If row_space[i] > row_max_space Then
			row_max_space = row_space[i]
			row_max = i
		End If
	Next
	
	If row_max_space - row_min_space < 96 Then
		row_space[row_max] = row_max_space + 64
	End If
End Sub

Sub DestroySafetyBullets()
	Dim x[4]
	Dim y[4]
	For i = 0 to 3
		Bullet_InAction[Safety_Bullet[i]] = False
		x[i] = Bullet[Safety_Bullet[i], 0]
		y[i] = Bullet[Safety_Bullet[i], 1]
	Next
	'Play Explode Animation
	t = timer
	explode_t = timer
	While timer - t < 800
		For i = 0 to 3
			DrawImage_Blit(Explode_Sprite, x[i], y[i], Explode_Current_Frame * 32, 0, 32, 32)
		Next
		If timer - explode_t > Explode_Frame_Delay Then
			explode_t = timer
			Explode_Current_Frame = Not Explode_Current_Frame
		End If
		DrawImage_Blit(Player_Sprite, Player[0], Player[1], Player_Current_Frame * Player_Frame_W, 0, Player_Frame_W, Player_Frame_H)
		Update
	Wend
End Sub

UP_PRESSED = 0
DOWN_PRESSED = 0

Function KeyPressed(k_code)
	If Key(k_code) Then
		If k_code = K_UP Then
			If Not UP_PRESSED Then
				UP_PRESSED = 1
				Return True
			Else
				Return False
			End If
		ElseIf k_code = K_DOWN Then
			If Not DOWN_PRESSED Then
				DOWN_PRESSED = 1
				Return True
			Else
				Return False
			End If
		End If
	Else
		If k_code = K_UP Then
			UP_PRESSED = 0
		ElseIf k_code = K_DOWN Then
			DOWN_PRESSED = 0
		End If
	End If
	Return False
End Function

Sub GameControl()
	If keyPressed(K_UP) Then
		Select Case Player[1]
		Case row_y[1]
			Player[1] = row_y[0]
		Case row_y[2]
			Player[1] = row_y[1]
		Case row_y[3]
			Player[1] = row_y[2]
		End Select
	ElseIf KeyPressed(K_DOWN) Then
		Select Case Player[1]
		Case row_y[0]
			Player[1] = row_y[1]
		Case row_y[1]
			Player[1] = row_y[2]
		Case row_y[2]
			Player[1] = row_y[3]
		End Select
	End If
	
	If Key(K_LEFT) And Player[0] > 18 Then
		Player[0] = Player[0] - 2
	ElseIf Key(K_RIGHT) And Player[0] < 460 Then
		Player[0] = Player[0] + 2
	End If
End Sub

Function PlayAnimation(b_num)
	If timer - Bullet_Animation_StartTime[b_num] > 200 Then
		Bullet_Animation[b_num] = NO_HIT
		Return 0
	End If
	Select Case Bullet_Animation[b_num]
	Case 0
		If timer - Bullet_Animation_Current_Time[b_num] > Score_Frame_Delay Then
			Bullet_Animation_Current_Frame[b_num] = Not Bullet_Animation_Current_Frame[b_num]
			Bullet_Animation_Current_Time[b_num] = timer
		End If
		DrawImage_Blit(Score_Sprite, Bullet_Animation_X[b_num], Bullet_Animation_Y[b_num], Bullet_Animation_Current_Frame[b_num]*32, 0, 32, 32)
	Case 1
		DrawImage(Wrong_Sprite, Bullet_Animation_X[b_num], Bullet_Animation_Y[b_num])
	End Select
	Return True
End Function

Function GameEnd()
	While True
		'Draw Score Box
		SetColor(rgb(120, 120, 120))
		RectFill(40, 150, 550, 150)
		
		SetColor(rgb(255,255,255))
		Font(1)
		DrawText("Your Final Credits was " + str(Grade), 210, 160)
		DrawText("Will you go back to school?", 210, 200)
		DrawText("Press Enter to go back to the title screen", 210, 220)
		DrawText("Press Escape to quit", 210, 240)
		
		If Key(K_ESCAPE) Then
			End
		ElseIf Key(K_RETURN) Then
			While Key(K_RETURN)
				Update
			Wend
			Return 0
		End If
		Update
	Wend
End Function

Function GameUpdate()
	'Draw Questions and Choices
	DrawQuestion
	
	'Swap Player Frame and reset timer
	If Timer - Player_Current_Frame_Time > Player_Frame_Delay Then
		Player_Current_Frame_Time = Timer
		Player_Current_Frame = Not Player_Current_Frame
	End If
	
	'Check Safety Hit
	If SafetyHit And Player[0] < 30 Then
		DestroySafetyBullets
	End If
	
	'Draw Enemy Sprites
	BulletUpdate
	phit = PlayerHit
	dim p_color
	hit_animation = NO_HIT
	If phit <> NO_HIT Then
		'p_color = rgb(255,0,0)
		If Bullet_Value[phit] = Answer[Current_Question] Then
			Bullet_Animation[phit] = 0 'score
			Grade = Grade + 10
			PlaySound(Score_SFX, 0, 0)
		Else
			Bullet_Animation[phit] = 1 'wrong
			PlaySound(Error_SFX, 0, 0)
			If Chances > 1 Then
				Chances = Chances - 1
			Else
				Return GameEnd
			End If
		End If
		Bullet_Animation_X[phit] = Bullet[phit, 0]
		Bullet_Animation_Y[phit] = Bullet[phit, 1]
		Bullet_Animation_StartTime[phit] = timer
		Current_Question = rand(MAX_QUESTIONS)
	Else
		'p_color = rgb(255,255,255)
	End If
	
	For i = 0 to MAX_BULLETS-1
		SetColor(rgb(255,255,255))
		If i = phit Then
			SetColor(p_color)
		End If
		If Bullet_InAction[i] Then
			If Bullet[i, 0] < 0 Then
				Bullet_InAction[i] = 0
			Else
				'Rect(Bullet[i, 0], Bullet[i, 1], Bullet[i, 2], Bullet[i, 3])
				If Bullet_Animation[i] = NO_HIT Then
					DrawImage_Blit(Bullet_Sprite, Bullet[i, 0], Bullet[i, 1], Bullet_Sprite_Offset[i], 0, 32, 32)
					Bullet[i, 0] = Bullet[i, 0] - Bullet_Speed
				ElseIf Not PlayAnimation(i) Then
					Bullet_InAction[i] = False
				End IF
			End If
		End If
	Next
	
	'Grade
	Font(1)
	SetColor(rgb(255,255,255))
	DrawText("Credits: " + Str(Grade), 10, 5)
	DrawText("Tuition:", 10, 20)
	For i = 0 to Chances-1
		DrawImage(Chance_Sprite, 80 + (i*17), 20)
	Next
	'Draw Player Sprite
	DrawImage_Blit(Player_Sprite, Player[0], Player[1], Player_Current_Frame * Player_Frame_W, 0, Player_Frame_W, Player_Frame_H)
	
	Update
	Return True
End Function

Function GameCredits()
	ClearCanvas
	DrawImage(Credits_Image, 0, 0)
	Font(0)
	SetColor(rgb(255,255,255))
	DrawText("Programming/Graphics - n00b (Rodney Cunningham)", 40, 100)
	DrawText("Some of the sounds in this project were created by", 40, 160)
	DrawText("ViRiX Dreamcore (David McKee) soundcloud.com/virix", 40, 180)
	DrawText("Some of the sounds in this project were created by", 40, 230)
	DrawText("KillaMaaki (Alan Stagner) opengameart.org", 40, 250)
	DrawText("Music by pheonton at opengameart.org", 40, 300)
	DrawText("Press X to go back to title screen", 40, 420)
	While Not Key(K_X)
		Update
	Wend
	ClearCanvas
	DrawImage(Title_Image, 0, 0)
End Function

Function GameTitle()
	Canvas(0)
	ClearCanvas
	Canvas(1)
	ClearCanvas
	Canvas(0)
	DrawImage(Title_Image, 0, 0)
	While True
		If Key(K_RETURN) Then
			Return True
		ElseIf Key(K_C) Then
			GameCredits
		ElseIf Key(K_ESCAPE) Then
			Return False
		End If
		Update
	Wend
End Function

WindowOpen(0, "College Story", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480, 0)
CanvasOpen(0, 640, 480, 0, 0, 640, 480, 0)
CanvasOpen(1, 640, 480, 0, 0, 640, 480, 1)

GameInit

Function GameLoop()
	
	If Not GameTitle Then
		Return 0
	End If
	
	SetCanvasZ(0, 2)
	Canvas(0)
	DrawImage(Background_Image, 0, 0)
	DrawImage(Professor_Sprite, 550, 108)
	
	PlayMusic(-1)

	Canvas(1)


	p_color = rgb(255,255,255)

	While Not Key(K_ESCAPE)
		ClearCanvas
		GameControl
		If Not GameUpdate Then
			Exit While
		End If
	Wend
	StopMusic
	
	Return True
End Function

While GameLoop
	GameReset
Wend
