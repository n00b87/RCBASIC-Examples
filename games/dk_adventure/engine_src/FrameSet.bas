MAX_IMAGES = 4096
MAX_TILESETS = 10
MAX_TILES = 512
MAX_ANIMATION_FRAMES = 8
MAX_FRAMESHEETS = 10
MAX_SPRITES = 10
MAX_SPRITE_ANIMATIONS = 100

Sprite_Dir$ = "sprite/"
Gfx_Dir$ = "gfx/"
Music_Dir$ = "music/"
Sfx_Dir$ = "sfx/"
TileSet_Dir$ = "tileset/"

'FrameSheets can be tilesheets or sprite sheets
NumFrameSheets = 0
Dim FrameSheet_File$[MAX_FRAMESHEETS]
Dim FrameSheet_Image[MAX_FRAMESHEETS]
Dim FrameSheet_NumFrames[MAX_FRAMESHEETS]
Dim FrameSheet_Width[MAX_FRAMESHEETS]
Dim FrameSheet_Height[MAX_FRAMESHEETS]
Dim FrameSheet_Frame_Width[MAX_FRAMESHEETS]
Dim FrameSheet_Frame_Height[MAX_FRAMESHEETS]

NumSprites = 0
Dim Sprite_Exists[MAX_SPRITES]
Dim Sprite_FrameSheet[MAX_SPRITES]
Dim Sprite_FPS[MAX_SPRITES]
Dim Sprite_NumAnimations[MAX_SPRITES]
Dim Sprite_NumAnimationFrames[MAX_SPRITES, MAX_SPRITE_ANIMATIONS]
Dim Sprite_Frames[MAX_SPRITES, MAX_SPRITE_ANIMATIONS, MAX_ANIMATION_FRAMES]

'Animation Control Stuff
Dim Sprite_StartTime[MAX_SPRITES]
Dim Sprite_FrameTime[MAX_SPRITES]
Dim Sprite_Animation_NumLoops[MAX_SPRITES]
Dim Sprite_Animation_CurrentLoop[MAX_SPRITES]
Dim Sprite_Animation_isPlaying[MAX_SPRITES]
Dim Sprite_Animation_isPaused[MAX_SPRITES]
Dim Sprite_CurrentAnimation[MAX_SPRITES]
Dim Sprite_Animation_CurrentFrame[MAX_SPRITES]
Dim Sprite_EndOfAnimation[MAX_SPRITES]

'Sprite Position, Rotation, and Scale
Dim Sprite_Pos[MAX_SPRITES,2]
Dim Sprite_Scale_Dim[MAX_SPRITES,2]
Dim Sprite_Angle[MAX_SPRITES]

NumTileSets = 0
Dim TileSet_FrameSheet[MAX_TILESETS]
Dim TileSet_FPS[MAX_TILESETS]
Dim TileSet_NumFrames[MAX_TILESETS, MAX_TILES]

Function LoadFrameSheet(img_file$, frame_width, frame_height)
	f_num = NumFrameSheets
	For i = 0 to MAX_IMAGES-1
		If Not ImageExists(i) Then
			LoadImage(i, Gfx_Dir$ + img_file$)
			ColorKey(i, -1)
			If Not ImageExists(i) Then
				Return -1
			End If
			FrameSheet_File$[f_num] = img_file$
			FrameSheet_Image[f_num] = i
			w = 0
			h = 0
			GetImageSize(i, w, h)
			FrameSheet_Width[f_num] = w
			FrameSheet_Height[f_num] = h
			FrameSheet_Frame_Width[f_num] = frame_width
			FrameSheet_Frame_Height[f_num] = frame_height
			NumFrameSheets = NumFrameSheets + 1
			Return f_num
		End If
	Next
	Return -1
End Function

Function Editor_LoadFrameSheet(img_file$, frame_width, frame_height)
	f_num = NumFrameSheets
	LoadImage(CurrentImage, Gfx_Dir$ + img_file$)
	If Not ImageExists(CurrentImage) Then
		Print "Could Not Load Image"
		Return -1
	End If
	'ColorKey(CurrentImage, -1)
	FrameSheet_File$[f_num] = img_file$
	FrameSheet_Image[f_num] = CurrentImage
	w = 0
	h = 0
	GetImageSize(CurrentImage, w, h)
	FrameSheet_Width[f_num] = w
	FrameSheet_Height[f_num] = h
	FrameSheet_Frame_Width[f_num] = frame_width
	FrameSheet_Frame_Height[f_num] = frame_height
	NumFrameSheets = NumFrameSheets + 1
	CurrentImage = CurrentImage + 1
	Return f_num
End Function

Sub store32(num, byref b_data)
	bit_cmp = 255
	b_data[0] = andBit(bit_cmp, num SHR 24)
	b_data[1] = andBit(bit_cmp, num SHR 16)
	b_data[2] = andBit(bit_cmp, num SHR 8)
	b_data[3] = andBit(bit_cmp, num)
End Sub

Function get32(byref b_data)
	num1 = b_data[0] SHL 24
	num2 = b_data[1] SHL 16
	num3 = b_data[2] SHL 8
	num4 = b_data[3]
	num_32 = num1 + num2 + num3 +num4
	cint64(num_32)
	return num_32
End Function	

Sub File_Write32(stream, num32)
	Dim bytes[4]
	store32(num32, bytes)
	WriteByte(stream, bytes[0])
	WriteByte(stream, bytes[1])
	WriteByte(stream, bytes[2])
	WriteByte(stream, bytes[3])
End Sub

Function File_Read32(stream)
	Dim bytes[4]
	bytes[0] = ReadByte(stream)
	bytes[1] = ReadByte(stream)
	bytes[2] = ReadByte(stream)
	bytes[3] = ReadByte(stream)
	Return cint32(get32(bytes))
End Function

Sub SaveSprite(sprite, spr_name$)
	f = FreeFile()
	FileOpen(f, Sprite_Dir$ + spr_name$ + ".spr", BINARY_OUTPUT)
	print "FPS = ";Sprite_FPS[sprite]
	File_Write32(f, Sprite_FPS[sprite])
	File_Write32(f, Sprite_NumAnimations[sprite])
	
	'Write the number of frames for each animation to the file
	If Sprite_NumAnimations[sprite] > 0 Then
		For i = 0 to Sprite_NumAnimations[sprite] - 1
			File_Write32(f, Sprite_NumAnimationFrames[sprite, i])
		Next
	End If
	
	'write the list of frame numbers for each animation to the file
	If Sprite_NumAnimations[sprite] > 0 Then
		For anim_num = 0 to Sprite_NumAnimations[sprite]-1
			If Sprite_NumAnimationFrames[sprite, anim_num] > 0 Then
				For frame_num = 0 to Sprite_NumAnimationFrames[sprite, anim_num]-1
					File_Write32(f, Sprite_Frames[sprite, anim_num, frame_num])
				Next
			End If
		Next
	End If
	
	FileClose(f)
	
	'Save FrameSheet Info
	FileOpen(f, Sprite_Dir$ + spr_name$ + ".fsi", TEXT_OUTPUT)
	WriteLine(f, FrameSheet_File$[Sprite_FrameSheet[sprite]]+"\n")
	WriteLine(f, Str$(FrameSheet_Frame_Width[Sprite_FrameSheet[sprite]])+"\n")
	WriteLine(f, Str$(FrameSheet_Frame_Height[Sprite_FrameSheet[sprite]])+"\n")
	FileClose(f)
End Sub

Function LoadSprite(spr_name$)
	sprite = -1
	If NumSprites > 0 Then
		For i = 0 to NumSprites-1
			If Not Sprite_Exists[i] Then
				sprite = i
				Exit For
			End If
		Next
	End If
	
	If sprite = -1 Then
		sprite = NumSprites
		NumSprites = NumSprites + 1
	End If
	
	f = FreeFile()
	FileOpen(f, Sprite_Dir$ + spr_name$ + ".spr", BINARY_INPUT)
	'print "first"
	Sprite_FPS[sprite] = File_Read32(f)
	Sprite_FrameTime[sprite] = 1000 / Sprite_FPS[sprite]
	'print "sec"
	Sprite_NumAnimations[sprite] = File_Read32(f)
	
	'Write the number of frames for each animation to the file
	'print "loop: " + Sprite_NumAnimations[sprite]
	If Sprite_NumAnimations[sprite] > 0 Then
		For i = 0 to Sprite_NumAnimations[sprite] - 1
			Sprite_NumAnimationFrames[sprite, i] = File_Read32(f)
		Next
	End If
	
	'write the list of frame numbers for each animation to the file
	'print "balls"
	If Sprite_NumAnimations[sprite] > 0 Then
		For anim_num = 0 to Sprite_NumAnimations[sprite]-1
			If Sprite_NumAnimationFrames[sprite, anim_num] > 0 Then
				For frame_num = 0 to Sprite_NumAnimationFrames[sprite, anim_num]-1
					Sprite_Frames[sprite, anim_num, frame_num] = File_Read32(f)
				Next
			End If
		Next
	End If
	
	FileClose(f)
	
	'Print "sprite fps = " + Sprite_FPS[sprite]
	'Print "num animations = " + Sprite_NumAnimations[sprite]
	'Print "num animation frames = " + Sprite_NumAnimationFrames[sprite, 0]
	'Print "frame 0 = " + Sprite_Frames[sprite, 0, 0]
	'Print "frame 0 = " + Sprite_Frames[sprite, 0, 1]
	'Print "frame 0 = " + Sprite_Frames[sprite, 0, 2]
	'Print "frame 0 = " + Sprite_Frames[sprite, 0, 3]
	
	'Save FrameSheet Info
	FileOpen(f, Sprite_Dir$ + spr_name$ + ".fsi", TEXT_INPUT)
	f_sheet$ = ReadLine$(f)
	f_width = Val(ReadLine$(f))
	f_height = Val(ReadLine$(f))
	FileClose(f)
	
	Sprite_FrameSheet[sprite] = LoadFrameSheet(f_sheet$, f_width, f_height)
	Sprite_Exists[sprite] = True
	
	Sprite_Scale_Dim[sprite,0] = 1
	Sprite_Scale_Dim[sprite,1] = 1
	
	'Print "Sprite sheet = " + f_sheet
	'Print "f_width = " + f_width
	'Print "f_height = " + f_height
	
	Return sprite
End Function

Function Editor_LoadSprite(spr_name$)
	sprite = -1
	If NumSprites > 0 Then
		For i = 0 to NumSprites-1
			If Not Sprite_Exists[i] Then
				sprite = i
				Exit For
			End If
		Next
	End If
	
	If sprite = -1 Then
		sprite = NumSprites
		NumSprites = NumSprites + 1
	End If
	
	f = FreeFile()
	FileOpen(f, Sprite_Dir$ + spr_name$ + ".spr", BINARY_INPUT)
	'print "first"
	Sprite_FPS[sprite] = File_Read32(f)
	Sprite_FrameTime[sprite] = 1000 / Sprite_FPS[sprite]
	'print "sec"
	Sprite_NumAnimations[sprite] = File_Read32(f)
	
	'Write the number of frames for each animation to the file
	'print "loop: " + Sprite_NumAnimations[sprite]
	If Sprite_NumAnimations[sprite] > 0 Then
		For i = 0 to Sprite_NumAnimations[sprite] - 1
			Sprite_NumAnimationFrames[sprite, i] = File_Read32(f)
		Next
	End If
	
	'write the list of frame numbers for each animation to the file
	'print "balls"
	If Sprite_NumAnimations[sprite] > 0 Then
		For anim_num = 0 to Sprite_NumAnimations[sprite]-1
			If Sprite_NumAnimationFrames[sprite, anim_num] > 0 Then
				For frame_num = 0 to Sprite_NumAnimationFrames[sprite, anim_num]-1
					Sprite_Frames[sprite, anim_num, frame_num] = File_Read32(f)
				Next
			End If
		Next
	End If
	
	FileClose(f)
	
	'Print "sprite fps = " + Sprite_FPS[sprite]
	'Print "num animations = " + Sprite_NumAnimations[sprite]
	'Print "num animation frames = " + Sprite_NumAnimationFrames[sprite, 0]
	'Print "frame 0 = " + Sprite_Frames[sprite, 0, 0]
	'Print "frame 0 = " + Sprite_Frames[sprite, 0, 1]
	'Print "frame 0 = " + Sprite_Frames[sprite, 0, 2]
	'Print "frame 0 = " + Sprite_Frames[sprite, 0, 3]
	
	'Save FrameSheet Info
	FileOpen(f, Sprite_Dir$ + spr_name$ + ".fsi", TEXT_INPUT)
	f_sheet$ = ReadLine$(f)
	f_width = Val(ReadLine$(f))
	f_height = Val(ReadLine$(f))
	FileClose(f)
	
	Sprite_FrameSheet[sprite] = Editor_LoadFrameSheet(f_sheet$, f_width, f_height)
	Sprite_Exists[sprite] = True
	
	Sprite_Scale_Dim[sprite,0] = 1
	Sprite_Scale_Dim[sprite,1] = 1
	
	'Print "Sprite sheet = " + f_sheet
	'Print "f_width = " + f_width
	'Print "f_height = " + f_height
	
	Return sprite
End Function

Function CreateSprite(f_sheet)
	sprite = -1
	If NumSprites > 0 Then
		For i = 0 to NumSprites-1
			If Not Sprite_Exists[i] Then
				sprite = i
				Exit For
			End If
		Next
	End If
	
	If sprite = -1 Then
		sprite = NumSprites
		NumSprites = NumSprites + 1
	End If
	
	Sprite_Scale_Dim[sprite,0] = 1
	Sprite_Scale_Dim[sprite,1] = 1
	
	'12 Frames per second by default
	Sprite_FPS[sprite] = 12
	Sprite_FrameTime[sprite] = 1000 / Sprite_FPS[sprite]
	
	'1 Animation by default
	Sprite_NumAnimations[sprite] = 1
	
	Sprite_NumAnimationFrames[sprite, 0] = 1
	
	Sprite_Frames[sprite, 0, 0] = 0
	
	Sprite_FrameSheet[sprite] = f_sheet
	Sprite_Exists[sprite] = True
	
	Return sprite
End Function

Sub DestroySprite(sprite)
	Sprite_Exists[sprite] = False
	Sprite_Animation_isPlaying[sprite] = False
	Sprite_Animation_isPaused[sprite] = False
End Sub

Sub DrawSpriteFrame(sprite, frame_num, x, y, angle, zx, zy)
	fsheet = Sprite_FrameSheet[sprite]
	image = FrameSheet_Image[ fsheet ]
	frames_per_row = FrameSheet_Width[fsheet] / FrameSheet_Frame_Width[fsheet]
	src_x = Int(frame_num MOD frames_per_row) * FrameSheet_Frame_Width[fsheet]
	src_y = Int(frame_num / frames_per_row) * FrameSheet_Frame_Height[fsheet]
	DrawImage_Rotozoom_Ex(image, x, y, src_x, src_y, FrameSheet_Frame_Width[fsheet], FrameSheet_Frame_Height[fsheet], angle, zx, zy)
	'DrawImage_Blit_Ex(image, x, y, w, h, src_x, src_y, FrameSheet_Frame_Width[image], FrameSheet_Frame_Height[image])
End Sub

Sub Sprite_GetFrame(sprite, frame_num, ByRef x, ByRef y, ByRef w, ByRef h)
	image = Sprite_FrameSheet[sprite]
	frames_per_row = FrameSheet_Width[image] / FrameSheet_Frame_Width[image]
	src_x = Int(frame_num MOD frames_per_row) * FrameSheet_Frame_Width[image]
	src_y = Int(frame_num / frames_per_row) * FrameSheet_Frame_Height[image]
	x = src_x
	y = src_y
	w = FrameSheet_Frame_Width[image]
	h = frameSheet_Frame_Height[image]
End Sub

Function Sprite_NewAnimation(sprite)
	anim_num = Sprite_NumAnimations[sprite]
	Sprite_NumAnimations[sprite] = Sprite_NumAnimations[sprite] + 1
	Return anim_num
End Function

Sub Sprite_SetAnimationFrame(sprite, anim_num, frame_num, frame)
	Sprite_Frames[sprite, anim_num, frame_num] = frame
End Sub

Sub Sprite_SetFPS(sprite, nfps)
	Sprite_FPS[sprite] = nfps
	Sprite_FrameTime[sprite] = 1000 / nfps
End Sub

Sub Sprite_Play(sprite, anim_num, anim_loops)
	If Not Sprite_Exists[sprite] Then
		Return
	End If
	Sprite_Animation_NumLoops[sprite] = anim_loops
	Sprite_Animation_CurrentLoop[sprite] = 0
	Sprite_Animation_isPlaying[sprite] = True
	Sprite_CurrentAnimation[sprite] = anim_num
	Sprite_Animation_CurrentFrame[sprite] = Sprite_Frames[sprite, anim_num, 0]
	Sprite_StartTime[sprite] = Timer()
End Sub

Sub Sprite_Stop(sprite)
	Sprite_Animation_isPlaying[sprite] = False
	Sprite_Animation_CurrentLoop[sprite] = 0
	Sprite_Animation_CurrentFrame[sprite] = Sprite_Frames[sprite, Sprite_CurrentAnimation[sprite], 0]
End Sub

Function Sprite_AnimationIsPlaying(sprite)
	Return Sprite_Animation_isPlaying[sprite]
End Function

Function Sprite_AnimationEnd(sprite)
	Return Sprite_EndOfAnimation[sprite]
End Function

Sub Sprite_SetAnimationFrameCount(sprite, anim_num, n)
	Sprite_NumAnimationFrames[sprite, anim_num] = n
End Sub

Sub Sprite_Position(sprite, x, y)
	Sprite_Pos[sprite,0] = x
	Sprite_Pos[sprite,1] = y
End Sub

Sub Sprite_Scale(sprite, zx, zy)
	Sprite_Scale_Dim[sprite, 0] = zx
	Sprite_Scale_Dim[sprite, 1] = zy
End Sub

Sub Sprite_Rotate(sprite, angle)
	Sprite_Angle[sprite] = angle
End Sub

Sub UpdateSprites()
	currentTime = timer()
	For sprite = 0 to NumSprites-1
		If currentTime - Sprite_StartTime[sprite] >= Sprite_FrameTime[sprite] Then
			Sprite_StartTime[sprite] = currentTime
			Sprite_Animation_CurrentFrame[sprite] = Sprite_Animation_CurrentFrame[sprite] + 1
			If Sprite_Animation_CurrentFrame[sprite] >= Sprite_NumAnimationFrames[sprite, Sprite_CurrentAnimation[sprite]] Then
				Sprite_Animation_CurrentLoop[sprite] = Sprite_Animation_CurrentLoop[sprite] + 1
				Sprite_Animation_CurrentFrame[sprite] = 0
				If Sprite_Animation_CurrentLoop[sprite] = Sprite_Animation_NumLoops[sprite]-1 Then
					Sprite_Animation_isPlaying[sprite] = False
					Sprite_Animation_CurrentLoop[sprite] = 0
				End If
			End If
		End If
	Next
End Sub

Sub Render()
	ClearCanvas()
	If NumSprites > 0 Then
		UpdateSprites()
		anim_num = 0
		frame_num = 0
		x = 0
		y = 0
		w = 0
		h = 0
		angle = 0
		zx = 0
		zy = 0
		For sprite = 0 to NumSprites-1
			If Sprite_Exists[sprite] And Sprite_Animation_isPlaying[sprite] Then
				x = Sprite_Pos[sprite,0]
				y = Sprite_Pos[sprite,1]
				angle = Sprite_Angle[sprite]
				zx = Sprite_Scale_Dim[sprite,0]
				zy = Sprite_Scale_Dim[sprite,1]
				anim_num = Sprite_CurrentAnimation[sprite]
				frame_num = Sprite_Animation_CurrentFrame[sprite]
				DrawSpriteFrame(sprite, Sprite_Frames[sprite, anim_num, frame_num], x, y, angle, zx, zy)
			End If
		Next
	End If
	Update()
End Sub

Sub Preview_ImageClip_Grab(id, img, src_x, src_y, src_w, src_h)
	i_num = -1
	For i = 0 to NumImageClips-1
		If ImageClip_Id[i] = id Then
			i_num = i
			Exit For
		End If
	Next
	If i_num = -1 Then
		Return
	End If
	If ImageExists(ImageClip_Image[i_num]) Then
		DeleteImage(ImageClip_Image[i_num])
	End If
	Canvas(CANVAS_OVERLAY)
	SetColor(RGB(1,1,1))
	RectFill(0,0,ImageClip_Size[i_num,0], ImageClip_Size[i_num,1])
	DrawImage_Blit_Ex(img, 0, 0, ImageClip_Size[i_num,0], ImageClip_Size[i_num,1], src_x, src_y, src_w, src_h)
	CanvasClip(ImageClip_Image[i_num], 0, 0, ImageClip_Size[i_num,0], ImageClip_Size[i_num,1], 1)
	Canvas(CANVAS_PANEL)
End Sub

Sub Preview_DrawSpriteFrame(preview_clip, sprite, frame_num)
	fsheet = Sprite_FrameSheet[sprite]
	image = FrameSheet_Image[ fsheet ]
	frames_per_row = FrameSheet_Width[fsheet] / FrameSheet_Frame_Width[fsheet]
	src_x = Int(frame_num MOD frames_per_row) * FrameSheet_Frame_Width[fsheet]
	src_y = Int(frame_num / frames_per_row) * FrameSheet_Frame_Height[fsheet]
	Preview_ImageClip_Grab(preview_clip, FrameSheet_Image[fsheet], src_x, src_y, FrameSheet_Frame_Width[fsheet], FrameSheet_Frame_Height[fsheet])
End Sub

Sub Preview_Render(preview_clip, sprite)
	'ClearCanvas()
	If NumSprites > 0 Then
		UpdateSprites()
		anim_num = 0
		frame_num = 0
		x = 0
		y = 0
		w = 0
		h = 0
		angle = 0
		zx = 0
		zy = 0
		If Sprite_Exists[sprite] And Sprite_Animation_isPlaying[sprite] Then
			anim_num = Sprite_CurrentAnimation[sprite]
			frame_num = Sprite_Animation_CurrentFrame[sprite]
			Preview_DrawSpriteFrame(preview_clip, sprite, Sprite_Frames[sprite, anim_num, frame_num])
			'Sprite_Frames[sprite, anim_num, frame_num])
		End If
	End If
End Sub

