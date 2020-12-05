include "start_menu.bas"

MAX_IMAGES = 4096
MAX_TILESETS = 2
MAX_TILES = 512
MAX_TILE_FRAMES = 4
MAX_ANIMATION_FRAMES = 8
MAX_FRAMESHEETS = 10
MAX_SPRITES = 200
MAX_SPRITE_ANIMATIONS = 100

Sprite_Dir$ = "sprite/"
Gfx_Dir$ = "gfx/"
Music_Dir$ = "music/"
Sfx_Dir$ = "sfx/"
TileSet_Dir$ = "tileset/"
Video_Dir$ = "video/"
Map_Dir$ = "map/"
Font_Dir$ = "font/"

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
Dim Sprite_Prev_Pos[MAX_SPRITES, 2]
Dim Sprite_Layer[MAX_SPRITES]

'Sprite HitBoxes
HITBOX_NULL = 0
HITBOX_RECT = 1
HITBOX_CIRCLE = 2

Dim Sprite_HitBox_Pos[MAX_SPRITES, 2]
Dim Sprite_HitBox_Size[MAX_SPRITES, 2]
Dim Sprite_HitBox_Shape[MAX_SPRITES]

Dim Sprite_Parent[MAX_SPRITES]
Dim Sprite_Child_Offset[MAX_SPRITES, 2]
Dim Sprite_isChild[MAX_SPRITES]

NUM_HIT_TYPES = 2
MAX_HITS = 10

HIT_TYPE_SPRITE = 0
HIT_TYPE_WORLD = 1

Dim Sprite_Hits[MAX_SPRITES, NUM_HIT_TYPES, MAX_HITS]
Dim Sprite_Hits_Count[MAX_SPRITES, NUM_HIT_TYPES]
Dim Sprite_isSolid[MAX_SPRITES]

'Keeps track of where sprite hits at
Dim Sprite_Hits_Pos[MAX_SPRITES, MAX_HITS, 2]

NumTiles = 0
Dim TileSet_Name$
Dim TileSet_FrameSheet
Dim TileSet_FramesPerRow
Dim TileSet_FPS
Dim TileSet_StartTime
Dim TileSet_FrameTime
Dim TileSet_Frames[MAX_TILES, MAX_TILE_FRAMES]
Dim TileSet_NumFrames[MAX_TILES]
Dim TileSet_CurrentFrame[MAX_TILES]
TileSet_Init = 0

'Canvas 0 to 7 will be dedicated to the layers
MAX_LAYERS = 8
MAX_MAP_WIDTH = 512
MAX_MAP_HEIGHT = 512
MAX_GEOMETRIES = 1000
MAX_GEOMETRIES_PER_SECTOR = 50
MAX_SECTORS = 200

Dim Map_Width
Dim Map_Height
Dim Map_Width_InPixels
Dim Map_Height_InPixels
Dim Map_NumSectors
Dim Map_Viewport_X
Dim Map_Viewport_Y
Dim Map_Viewport_Width
Dim Map_Viewport_Height
Dim Map_Offset_X[MAX_LAYERS]
Dim Map_Offset_Y[MAX_LAYERS]
Dim Map_Offset_Interval[MAX_LAYERS]
Dim Map_Max_Offset_X
Dim Map_Max_Offset_Y
Dim Map_Tiles[MAX_LAYERS, MAX_MAP_WIDTH, MAX_MAP_HEIGHT]
Dim Map_Layer_Alpha[MAX_LAYERS]
Dim Map_Layer_isVisible[MAX_LAYERS]

Dim Map_Bkg_File$[MAX_LAYERS]
Dim Map_Bkg_Image[MAX_LAYERS]
Dim Map_Bkg_Width[MAX_LAYERS]
Dim Map_BKg_Height[MAX_LAYERS]

GEOMETRY_LINE = 1
GEOMETRY_RECT = 2
GEOMETRY_CIRCLE = 3

Dim Map_Geometries[MAX_LAYERS, MAX_SECTORS, MAX_GEOMETRIES_PER_SECTOR]
Dim Map_NumSectorGeometries[MAX_LAYERS, MAX_SECTORS]
Map_CurrentSector = 0

Dim Geometry[MAX_GEOMETRIES, 4]
Dim Geometry_Type[MAX_GEOMETRIES]
Dim NumGeometries
Dim Map_GeometrySector[MAX_GEOMETRIES]
'A sector will be the a total width and height of the screen that is viewable
'used for making map geometry collision faster
Dim Map_Sector_Pos[MAX_SECTORS,2]
Dim Map_Sector_Width
Dim Map_Sector_Height
Dim Map_Sector_Across
Dim Map_Sector_Down

'Not setting any flag constants to 0 or 1 because of the conflict with TRUE and FALSE
TILE_FLAG = 3
IMAGE_FLAG = 4
VIDEO_FLAG = 5
GEOMETRY_FLAG = 6
DRAW_FLAG = 7

Dim Layer_Flag_Tiles[MAX_LAYERS]
Dim Layer_Flag_Image[MAX_LAYERS]
Dim Layer_Flag_Video[MAX_LAYERS]
Dim Layer_Flag_Draw[MAX_LAYERS]
Dim Video_Layer
Dim Layer_Flag_Geometry[MAX_LAYERS]
Layer_GeometryColor = RGB(255,0,0)

Dim Layer_Sprites[MAX_LAYERS, MAX_SPRITES]
Dim Layer_Sprites_Count[MAX_LAYERS]

Map_CurrentLayer = 0

TileSet_Image = -1
TileSet_FS_Flag = 0

DRAW_CMD_SPRITE = 1
DRAW_CMD_IMAGE = 2

MAX_DRAW_COMMANDS = 30
Dim Render_Draw_Command[MAX_DRAW_COMMANDS,5] '0 = CMD
num_draw_commands = 0


Function LoadBkg(bkg_image$)
	For i = 0 to MAX_IMAGES-1
		If Not ImageExists(i) Then
			LoadImage(i, gfx_dir$ + bkg_image)
			If ImageExists(i) Then
				Return i
			Else
				Return -1
			End If
		End If
	Next
	Return -1
End Function

Function LoadFrameSheet(img_file$, frame_width, frame_height)
	f_num = -1
	
	For i = 0 to MAX_FRAMESHEETS-1
		If Not ImageExists(FrameSheet_Image[i]) Then
			f_num = i
			Exit For
		End If
	Next
	If f_num = -1 Then
		Print "Could not load framesheet"
		Return -1
	End If
	For i = 0 to MAX_IMAGES-1
		If Not ImageExists(i) Then
			LoadImage(i, Gfx_Dir$ + img_file$)
			If Not TileSet_FS_Flag Then
				'ColorKey(i, -1)
			End If
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

Sub ClearFrameSheet(f_num)
	DeleteImage(FrameSheet_Image[f_num])
	
	FrameSheet_File$[f_num] = ""
End Sub

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
	if bytes[0] = 255 and bytes[1] = 255 and bytes[2] = 255 and bytes[3] = 255 then
		return -1
	end if
	Return cint32(get32(bytes))
End Function

'----------------COLLISION DETECTION--------------------------

Sub Sprite_SetHitBox(sprite, hb_shape, x, y, w_r, h)
	Sprite_HitBox_Pos[sprite, 0] = x
	Sprite_HitBox_Pos[sprite, 1] = y
	Sprite_HitBox_Size[sprite, 0] = w_r
	Sprite_HitBox_Size[sprite, 1] = h
	Sprite_HitBox_Shape[sprite] = hb_shape
End Sub

Function GetLineIntersect(p0_x, p0_y, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, ByRef i_x, ByRef i_y)
    'Return 0
	
	s1_x = p1_x - p0_x
	s1_y = p1_y - p0_y
    s2_x = p3_x - p2_x
	s2_y = p3_y - p2_y
	
	n = ( (-1 * s2_x) * s1_y + s1_x * s2_y)
	
	If n = 0 Then
		Return 0
	End If
	
    s = ( (-1 * s1_y) * (p0_x - p2_x) + s1_x * (p0_y - p2_y)) / n
    t = ( s2_x * (p0_y - p2_y) - s2_y * (p0_x - p2_x)) / n

    If s >= 0 And s <= 1 And t >= 0 And t <= 1 Then
        ' Collision detected
        i_x = p0_x + (t * s1_x)
        
        i_y = p0_y + (t * s1_y)
        return 1
    End If
	
	' No collision
    return 0
End Function

Function Sprite_GetHit(sprite1, sprite2)
	'return 0
	x1 = Sprite_Pos[sprite1, 0] + Sprite_HitBox_Pos[sprite1, 0]
	y1 = Sprite_Pos[sprite1, 1] + Sprite_HitBox_Pos[sprite1, 1]
	w1 = Sprite_HitBox_Size[sprite1, 0]
	h1 = Sprite_HitBox_Size[sprite1, 1]
	
	x2 = Sprite_Pos[sprite2, 0] + Sprite_HitBox_Pos[sprite2, 0]
	y2 = Sprite_Pos[sprite2, 1] + Sprite_HitBox_Pos[sprite2, 1]
	w2 = Sprite_HitBox_Size[sprite2, 0]
	h2 = Sprite_HitBox_Size[sprite2, 1]
	
	hit_x = 0
	hit_y = 0
	
	Select Case Sprite_HitBox_Shape[sprite1]
	Case HITBOX_RECT
		Select Case Sprite_HitBox_Shape[sprite2]
		Case HITBOX_RECT
			l1_x1 = x1
			l1_y1 = y1
			l1_x2 = x1 + w1
			l1_y2 = y1 + h1
			
			l2_x1 = x2
			l2_y1 = y2
			l2_x2 = x2 + w2
			l2_y2 = y2
			
			If GetLineIntersect(l1_x1, l1_y1, l1_x2, l1_y2, l2_x1, l2_y1, l2_x2, l2_y2, hit_x, hit_y) Then
				'Print "top: Line 1 = " + l1_x1 + ", " + l1_y1 + " to " + l1_x2 + ", " + l1_y2
				'Print "top: Line 2 = " + l2_x1 + ", " + l2_y1 + " to " + l2_x2 + ", " + l2_y2
				Sprite_Hits_Pos[sprite1, Sprite_Hits_Count[sprite1, HIT_TYPE_SPRITE], 0] = hit_x
				Sprite_Hits_Pos[sprite1, Sprite_Hits_Count[sprite1, HIT_TYPE_SPRITE], 1] = hit_y
				Sprite_Hits_Pos[sprite2, Sprite_Hits_Count[sprite2, HIT_TYPE_SPRITE], 0] = hit_x
				Sprite_Hits_Pos[sprite2, Sprite_Hits_Count[sprite2, HIT_TYPE_SPRITE], 1] = hit_y
				Return True
			End If
			
			l2_x1 = x2
			l2_y1 = y2
			l2_x2 = x2
			l2_y2 = y2 + h2
			
			If GetLineIntersect(l1_x1, l1_y1, l1_x2, l1_y2, l2_x1, l2_y1, l2_x2, l2_y2, hit_x, hit_y) Then
				'Print "left: Line 1 = " + l1_x1 + ", " + l1_y1 + " to " + l1_x2 + ", " + l1_y2
				'Print "left: Line 2 = " + l2_x1 + ", " + l2_y1 + " to " + l2_x2 + ", " + l2_y2
				Sprite_Hits_Pos[sprite1, Sprite_Hits_Count[sprite1, HIT_TYPE_SPRITE], 0] = hit_x
				Sprite_Hits_Pos[sprite1, Sprite_Hits_Count[sprite1, HIT_TYPE_SPRITE], 1] = hit_y
				Sprite_Hits_Pos[sprite2, Sprite_Hits_Count[sprite2, HIT_TYPE_SPRITE], 0] = hit_x
				Sprite_Hits_Pos[sprite2, Sprite_Hits_Count[sprite2, HIT_TYPE_SPRITE], 1] = hit_y
				Return True
			End If
			
			l2_x1 = x2
			l2_y1 = y2 + h2
			l2_x2 = x2 + w2
			l2_y2 = y2 + h2
			
			If GetLineIntersect(l1_x1, l1_y1, l1_x2, l1_y2, l2_x1, l2_y1, l2_x2, l2_y2, hit_x, hit_y) Then
				'Print "bottom: Line 1 = " + l1_x1 + ", " + l1_y1 + " to " + l1_x2 + ", " + l1_y2
				'Print "bottom: Line 2 = " + l2_x1 + ", " + l2_y1 + " to " + l2_x2 + ", " + l2_y2
				Sprite_Hits_Pos[sprite1, Sprite_Hits_Count[sprite1, HIT_TYPE_SPRITE], 0] = hit_x
				Sprite_Hits_Pos[sprite1, Sprite_Hits_Count[sprite1, HIT_TYPE_SPRITE], 1] = hit_y
				Sprite_Hits_Pos[sprite2, Sprite_Hits_Count[sprite2, HIT_TYPE_SPRITE], 0] = hit_x
				Sprite_Hits_Pos[sprite2, Sprite_Hits_Count[sprite2, HIT_TYPE_SPRITE], 1] = hit_y
				Return True
			End If
			
			l2_x1 = x2 + w2
			l2_y1 = y2
			l2_x2 = x2 + w2
			l2_y2 = y2 + h2
			
			If GetLineIntersect(l1_x1, l1_y1, l1_x2, l1_y2, l2_x1, l2_y1, l2_x2, l2_y2, hit_x, hit_y) Then
				'Print "right: Line 1 = " + l1_x1 + ", " + l1_y1 + " to " + l1_x2 + ", " + l1_y2
				'Print "right: Line 2 = " + l2_x1 + ", " + l2_y1 + " to " + l2_x2 + ", " + l2_y2
				Sprite_Hits_Pos[sprite1, Sprite_Hits_Count[sprite1, HIT_TYPE_SPRITE], 0] = hit_x
				Sprite_Hits_Pos[sprite1, Sprite_Hits_Count[sprite1, HIT_TYPE_SPRITE], 1] = hit_y
				Sprite_Hits_Pos[sprite2, Sprite_Hits_Count[sprite2, HIT_TYPE_SPRITE], 0] = hit_x
				Sprite_Hits_Pos[sprite2, Sprite_Hits_Count[sprite2, HIT_TYPE_SPRITE], 1] = hit_y
				Return True
			End If
			
			Return False
		End Select
	End Select
	
	Return False
End Function

WORLDHIT_TOP = 0
WORLDHIT_BOTTOM = 0
WORLDHIT_LEFT = 0
WORLDHIT_RIGHT = 0

WORLD_RECT_HIT_TOP = -1
WORLD_RECT_HIT_BOTTOM = -1
WORLD_RECT_HIT_LEFT = -1
WORLD_RECT_HIT_RIGHT = -1

WORLD_LINE_HIT = -1

FROM_TOP = 0
FROM_BOTTOM = 1
FROM_LEFT = 2
FROM_RIGHT = 3

ON_GROUND = 0
HEAD_BUMP = 0
WALL_LEFT = 0
WALL_RIGHT = 0

Dim Sprite_Hits_From[MAX_HITS]

Sub SetSpriteHit(sprite, hitbox_line, rect_line, hit_x, hit_y)
	If Sprite_Hits_Count[sprite, HIT_TYPE_WORLD] < MAX_HITS Then
		Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 0] = hit_x
		Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 1] = hit_y
		
		Select Case hitbox_line
		Case FROM_TOP
			WORLDHIT_TOP = True
			Sprite_Hits_From[Sprite_Hits_Count[sprite, HIT_TYPE_WORLD]] = FROM_TOP
		Case FROM_BOTTOM
			WORLDHIT_BOTTOM = True
			Sprite_Hits_From[Sprite_Hits_Count[sprite, HIT_TYPE_WORLD]] = FROM_BOTTOM
		Case FROM_LEFT
			WORLDHIT_LEFT = True
			Sprite_Hits_From[Sprite_Hits_Count[sprite, HIT_TYPE_WORLD]] = FROM_LEFT
		Case FROM_RIGHT
			WORLDHIT_RIGHT = True
			Sprite_Hits_From[Sprite_Hits_Count[sprite, HIT_TYPE_WORLD]] = FROM_RIGHT
		End Select
		
		Select Case rect_line
		Case FROM_TOP
			WORLD_RECT_HIT_TOP = Sprite_Hits_Count[sprite, HIT_TYPE_WORLD]
			If hitbox_line = FROM_BOTTOM Then
				ON_GROUND = WORLD_RECT_HIT_TOP
			End If
		Case FROM_BOTTOM
			WORLD_RECT_HIT_BOTTOM = Sprite_Hits_Count[sprite, HIT_TYPE_WORLD]
			If hitbox_line = FROM_TOP Then
				HEAD_BUMP = WORLD_RECT_HIT_BOTTOM
			End If
		Case FROM_LEFT
			WORLD_RECT_HIT_LEFT = Sprite_Hits_Count[sprite, HIT_TYPE_WORLD]
			If hitbox_line = FROM_RIGHT Then
				WALL_LEFT = WORLD_RECT_HIT_LEFT
			End If
		Case FROM_RIGHT
			WORLD_RECT_HIT_RIGHT = Sprite_Hits_Count[sprite, HIT_TYPE_WORLD]
			If hitbox_line = FROM_LEFT Then
				WALL_RIGHT = WORLD_RECT_HIT_RIGHT
			End If
		End Select
		
		Sprite_Hits_Count[sprite, HIT_TYPE_WORLD] = Sprite_Hits_Count[sprite, HIT_TYPE_WORLD] + 1
	End If
End Sub

Sub GetSpriteHit(sprite, from, ByRef x, ByRef y)
	If Sprite_Hits_Count[sprite, HIT_TYPE_WORLD] > 0 Then
		For hit = 0 to Sprite_Hits_Count[sprite, HIT_TYPE_WORLD]-1
			If Sprite_Hits_From[hit] = from Then
				x = Sprite_Hits_Pos[sprite, hit, 0]
				y = Sprite_Hits_Pos[sprite, hit, 1]
				Return
			End If
		Next
	End If
End Sub

Sub GetSpriteHitFromWorld(sprite, from, ByRef x, ByRef y)
	Select Case from
	Case ON_GROUND
		If ON_GROUND >= 0 Then
			x = Sprite_Hits_Pos[sprite, ON_GROUND, 0]
			y = Sprite_Hits_Pos[sprite, ON_GROUND, 1]
		End If
	Case HEAD_BUMP
		If HEAD_BUMP >= 0 Then
			x = Sprite_Hits_Pos[sprite, HEAD_BUMP, 0]
			y = Sprite_Hits_Pos[sprite, HEAD_BUMP, 1]
		End If
	Case WALL_LEFT
		If WALL_LEFT >= 0 Then
			x = Sprite_Hits_Pos[sprite, WALL_LEFT, 0]
			y = Sprite_Hits_Pos[sprite, WALL_LEFT, 1]
		End If
	Case WALL_RIGHT
		If WALL_RIGHT >= 0 Then
			x = Sprite_Hits_Pos[sprite, WALL_RIGHT, 0]
			y = Sprite_Hits_Pos[sprite, WALL_RIGHT, 1]
		End If
	End Select
End Sub

Function Sprite_GetWorldHit(sprite, x, y)
	WORLDHIT_TOP = False
	WORLDHIT_BOTTOM = False
	WORLDHIT_LEFT = False
	WORLDHIT_RIGHT = False
	
	WORLD_RECT_HIT_TOP = -1
	WORLD_RECT_HIT_BOTTOM = -1
	WORLD_RECT_HIT_LEFT = -1
	WORLD_RECT_HIT_RIGHT = -1

	WORLD_LINE_HIT = -1
	
	ON_GROUND = -1
	HEAD_BUMP = -1
	WALL_LEFT = -1
	WALL_RIGHT = -1
	
	Sprite_Hits_Count[sprite, HIT_TYPE_WORLD] = 0
	
	wh_value = False
	
	sect = Map_CurrentSector
	layer = Sprite_Layer[sprite]
	
	'sprite_x1 = Sprite_Pos[sprite,0] + Sprite_HitBox_Pos[sprite,0]
	'sprite_y1 = Sprite_Pos[sprite,1] + Sprite_HitBox_Pos[sprite,1]
	'sprite_x2 = sprite_x1 + Sprite_HitBox_Size[sprite,0]
	'sprite_y2 = sprite_y1 + Sprite_HitBox_Size[sprite,1]
	
	'top left
	sprite_x1 = x + Sprite_HitBox_Pos[sprite,0]
	sprite_y1 = y + Sprite_HitBox_Pos[sprite,1]
	
	'top right
	sprite_x2 = sprite_x1 + Sprite_HitBox_Size[sprite,0]
	sprite_y2 = sprite_y1
	
	'bottom left
	sprite_x3 = sprite_x1
	sprite_y3 = sprite_y1 + Sprite_HitBox_Size[sprite,1]
	
	'bottom right
	sprite_x4 = sprite_x2
	sprite_y4 = sprite_y3
	
	world_x1 = 0
	world_y1 = 0
	world_x2 = 0
	world_y2 = 0
	
	hit_x = 0
	hit_y = 0
	
	'If Map_NumSectorGeometries[layer, sect] > 0 Then
	If NumGeometries > 0 Then
		'For g = 0 to Map_NumSectorGeometries[layer, sect]-1
		For g = 0 to NumGeometries-1	
			'g_num = Map_Geometries[layer, sect, g]
			g_num = g
			Select Case Geometry_Type[g_num]
			Case GEOMETRY_RECT
				world_x1 = Geometry[g_num,0]
				world_y1 = Geometry[g_num,1]
				world_x2 = world_x1 + Geometry[g_num,2]
				world_y2 = world_y1
				
				'top
				If GetLineIntersect(sprite_x1, sprite_y1, sprite_x2, sprite_y2, world_x1, world_y1, world_x2, world_y2, hit_x, hit_y) Then
					'Print "top: Line 1 = " + l1_x1 + ", " + l1_y1 + " to " + l1_x2 + ", " + l1_y2
					'Print "top: Line 2 = " + l2_x1 + ", " + l2_y1 + " to " + l2_x2 + ", " + l2_y2
					
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 0] = hit_x
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 1] = hit_y
					'WORLDHIT_TOP = True
					'WORLD_RECT_HIT_TOP = Sprite_Hits_Count[sprite, HIT_TYPE_WORLD]
					'Sprite_Hits_Count[sprite, HIT_TYPE_WORLD] = Sprite_Hits_Count[sprite, HIT_TYPE_WORLD] + 1
					
					SetSpriteHit(sprite, FROM_TOP, FROM_TOP, hit_x, hit_y)
					
					wh_value = True
				'left
				ElseIf GetLineIntersect(sprite_x1, sprite_y1, sprite_x3, sprite_y3, world_x1, world_y1, world_x2, world_y2, hit_x, hit_y) Then
					'Print "top: Line 1 = " + l1_x1 + ", " + l1_y1 + " to " + l1_x2 + ", " + l1_y2
					'Print "top: Line 2 = " + l2_x1 + ", " + l2_y1 + " to " + l2_x2 + ", " + l2_y2
					
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 0] = hit_x
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 1] = hit_y
					'WORLDHIT_LEFT = True
					
					SetSpriteHit(sprite, FROM_LEFT, FROM_TOP, hit_x, hit_y)
					
					wh_value = True
				'bottom
				ElseIf GetLineIntersect(sprite_x3, sprite_y3, sprite_x4, sprite_y4, world_x1, world_y1, world_x2, world_y2, hit_x, hit_y) Then
					'Print "top: Line 1 = " + l1_x1 + ", " + l1_y1 + " to " + l1_x2 + ", " + l1_y2
					'Print "top: Line 2 = " + l2_x1 + ", " + l2_y1 + " to " + l2_x2 + ", " + l2_y2
					
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 0] = hit_x
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 1] = hit_y
					'WORLDHIT_BOTTOM = True
					
					SetSpriteHit(sprite, FROM_BOTTOM, FROM_TOP, hit_x, hit_y)
					
					wh_value = True
				'right
				ElseIf GetLineIntersect(sprite_x2, sprite_y2, sprite_x4, sprite_y4, world_x1, world_y1, world_x2, world_y2, hit_x, hit_y) Then
					'Print "top: Line 1 = " + l1_x1 + ", " + l1_y1 + " to " + l1_x2 + ", " + l1_y2
					'Print "top: Line 2 = " + l2_x1 + ", " + l2_y1 + " to " + l2_x2 + ", " + l2_y2
					
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 0] = hit_x
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 1] = hit_y
					'WORLDHIT_RIGHT = True
					
					SetSpriteHit(sprite, FROM_RIGHT, FROM_TOP, hit_x, hit_y)
					
					wh_value = True
				End If
				
				world_x1 = Geometry[g_num,0]
				world_y1 = Geometry[g_num,1]
				world_x2 = world_x1
				world_y2 = world_y1 + Geometry[g_num,3]
				
				'top
				If GetLineIntersect(sprite_x1, sprite_y1, sprite_x2, sprite_y2, world_x1, world_y1, world_x2, world_y2, hit_x, hit_y) Then
					'Print "top: Line 1 = " + l1_x1 + ", " + l1_y1 + " to " + l1_x2 + ", " + l1_y2
					'Print "top: Line 2 = " + l2_x1 + ", " + l2_y1 + " to " + l2_x2 + ", " + l2_y2
					
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 0] = hit_x
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 1] = hit_y
					'WORLDHIT_TOP = True
					
					SetSpriteHit(sprite, FROM_TOP, FROM_LEFT, hit_x, hit_y)
					
					wh_value = True
				'left
				ElseIf GetLineIntersect(sprite_x1, sprite_y1, sprite_x3, sprite_y3, world_x1, world_y1, world_x2, world_y2, hit_x, hit_y) Then
					'Print "top: Line 1 = " + l1_x1 + ", " + l1_y1 + " to " + l1_x2 + ", " + l1_y2
					'Print "top: Line 2 = " + l2_x1 + ", " + l2_y1 + " to " + l2_x2 + ", " + l2_y2
					
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 0] = hit_x
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 1] = hit_y
					'WORLDHIT_LEFT = True
					
					SetSpriteHit(sprite, FROM_LEFT, FROM_LEFT, hit_x, hit_y)
					
					wh_value = True
				'bottom
				ElseIf GetLineIntersect(sprite_x3, sprite_y3, sprite_x4, sprite_y4, world_x1, world_y1, world_x2, world_y2, hit_x, hit_y) Then
					'Print "top: Line 1 = " + l1_x1 + ", " + l1_y1 + " to " + l1_x2 + ", " + l1_y2
					'Print "top: Line 2 = " + l2_x1 + ", " + l2_y1 + " to " + l2_x2 + ", " + l2_y2
					
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 0] = hit_x
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 1] = hit_y
					'WORLDHIT_BOTTOM = True
					
					SetSpriteHit(sprite, FROM_BOTTOM, FROM_LEFT, hit_x, hit_y)
					
					wh_value = True
				'right
				ElseIf GetLineIntersect(sprite_x2, sprite_y2, sprite_x4, sprite_y4, world_x1, world_y1, world_x2, world_y2, hit_x, hit_y) Then
					'Print "top: Line 1 = " + l1_x1 + ", " + l1_y1 + " to " + l1_x2 + ", " + l1_y2
					'Print "top: Line 2 = " + l2_x1 + ", " + l2_y1 + " to " + l2_x2 + ", " + l2_y2
					
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 0] = hit_x
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 1] = hit_y
					'WORLDHIT_RIGHT = True
					
					SetSpriteHit(sprite, FROM_RIGHT, FROM_LEFT, hit_x, hit_y)
					
					wh_value = True
				End If
				
				world_x1 = Geometry[g_num,0]
				world_y1 = Geometry[g_num,1] + Geometry[g_num,3]
				world_x2 = world_x1 + Geometry[g_num,2]
				world_y2 = world_y1
				
				'top
				If GetLineIntersect(sprite_x1, sprite_y1, sprite_x2, sprite_y2, world_x1, world_y1, world_x2, world_y2, hit_x, hit_y) Then
					'Print "top: Line 1 = " + l1_x1 + ", " + l1_y1 + " to " + l1_x2 + ", " + l1_y2
					'Print "top: Line 2 = " + l2_x1 + ", " + l2_y1 + " to " + l2_x2 + ", " + l2_y2
					
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 0] = hit_x
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 1] = hit_y
					'WORLDHIT_TOP = True
					
					SetSpriteHit(sprite, FROM_TOP, FROM_BOTTOM, hit_x, hit_y)
					
					wh_value = True
				'left
				ElseIf GetLineIntersect(sprite_x1, sprite_y1, sprite_x3, sprite_y3, world_x1, world_y1, world_x2, world_y2, hit_x, hit_y) Then
					'Print "top: Line 1 = " + l1_x1 + ", " + l1_y1 + " to " + l1_x2 + ", " + l1_y2
					'Print "top: Line 2 = " + l2_x1 + ", " + l2_y1 + " to " + l2_x2 + ", " + l2_y2
					
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 0] = hit_x
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 1] = hit_y
					'WORLDHIT_LEFT = True
					
					SetSpriteHit(sprite, FROM_LEFT, FROM_BOTTOM, hit_x, hit_y)
					
					wh_value = True
				'bottom
				ElseIf GetLineIntersect(sprite_x3, sprite_y3, sprite_x4, sprite_y4, world_x1, world_y1, world_x2, world_y2, hit_x, hit_y) Then
					'Print "top: Line 1 = " + l1_x1 + ", " + l1_y1 + " to " + l1_x2 + ", " + l1_y2
					'Print "top: Line 2 = " + l2_x1 + ", " + l2_y1 + " to " + l2_x2 + ", " + l2_y2
					
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 0] = hit_x
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 1] = hit_y
					'WORLDHIT_BOTTOM = True
					
					SetSpriteHit(sprite, FROM_BOTTOM, FROM_BOTTOM, hit_x, hit_y)
					
					wh_value = True
				'right
				ElseIf GetLineIntersect(sprite_x2, sprite_y2, sprite_x4, sprite_y4, world_x1, world_y1, world_x2, world_y2, hit_x, hit_y) Then
					'Print "top: Line 1 = " + l1_x1 + ", " + l1_y1 + " to " + l1_x2 + ", " + l1_y2
					'Print "top: Line 2 = " + l2_x1 + ", " + l2_y1 + " to " + l2_x2 + ", " + l2_y2
					
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 0] = hit_x
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 1] = hit_y
					'WORLDHIT_RIGHT = True
					
					SetSpriteHit(sprite, FROM_RIGHT, FROM_BOTTOM, hit_x, hit_y)
					
					wh_value = True
				End If
				
				world_x1 = Geometry[g_num,0] + Geometry[g_num,2]
				world_y1 = Geometry[g_num,1]
				world_x2 = world_x1
				world_y2 = world_y1 + Geometry[g_num,3]
				
				'top
				If GetLineIntersect(sprite_x1, sprite_y1, sprite_x2, sprite_y2, world_x1, world_y1, world_x2, world_y2, hit_x, hit_y) Then
					'Print "top: Line 1 = " + l1_x1 + ", " + l1_y1 + " to " + l1_x2 + ", " + l1_y2
					'Print "top: Line 2 = " + l2_x1 + ", " + l2_y1 + " to " + l2_x2 + ", " + l2_y2
					
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 0] = hit_x
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 1] = hit_y
					'WORLDHIT_TOP = True
					
					SetSpriteHit(sprite, FROM_TOP, FROM_RIGHT, hit_x, hit_y)
					
					wh_value = True
				'left
				ElseIf GetLineIntersect(sprite_x1, sprite_y1, sprite_x3, sprite_y3, world_x1, world_y1, world_x2, world_y2, hit_x, hit_y) Then
					'Print "top: Line 1 = " + l1_x1 + ", " + l1_y1 + " to " + l1_x2 + ", " + l1_y2
					'Print "top: Line 2 = " + l2_x1 + ", " + l2_y1 + " to " + l2_x2 + ", " + l2_y2
					
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 0] = hit_x
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 1] = hit_y
					'WORLDHIT_LEFT = True
					
					SetSpriteHit(sprite, FROM_LEFT, FROM_RIGHT, hit_x, hit_y)
					
					wh_value = True
				'bottom
				ElseIf GetLineIntersect(sprite_x3, sprite_y3, sprite_x4, sprite_y4, world_x1, world_y1, world_x2, world_y2, hit_x, hit_y) Then
					'Print "top: Line 1 = " + l1_x1 + ", " + l1_y1 + " to " + l1_x2 + ", " + l1_y2
					'Print "top: Line 2 = " + l2_x1 + ", " + l2_y1 + " to " + l2_x2 + ", " + l2_y2
					
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 0] = hit_x
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 1] = hit_y
					'WORLDHIT_BOTTOM = True
					
					SetSpriteHit(sprite, FROM_BOTTOM, FROM_RIGHT, hit_x, hit_y)
					
					wh_value = True
				'right
				ElseIf GetLineIntersect(sprite_x2, sprite_y2, sprite_x4, sprite_y4, world_x1, world_y1, world_x2, world_y2, hit_x, hit_y) Then
					'Print "top: Line 1 = " + l1_x1 + ", " + l1_y1 + " to " + l1_x2 + ", " + l1_y2
					'Print "top: Line 2 = " + l2_x1 + ", " + l2_y1 + " to " + l2_x2 + ", " + l2_y2
					
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 0] = hit_x
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 1] = hit_y
					'WORLDHIT_RIGHT = True
					
					SetSpriteHit(sprite, FROM_RIGHT, FROM_RIGHT, hit_x, hit_y)
					
					wh_value = True
				End If
			Case GEOMETRY_LINE
				world_x1 = Geometry[g_num,0]
				world_y1 = Geometry[g_num,1]
				world_x2 = Geometry[g_num,2]
				world_y2 = Geometry[g_num,3]
				
				'top
				If GetLineIntersect(sprite_x1, sprite_y1, sprite_x2, sprite_y2, world_x1, world_y1, world_x2, world_y2, hit_x, hit_y) Then
					'Print "top: Line 1 = " + l1_x1 + ", " + l1_y1 + " to " + l1_x2 + ", " + l1_y2
					'Print "top: Line 2 = " + l2_x1 + ", " + l2_y1 + " to " + l2_x2 + ", " + l2_y2
					
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 0] = hit_x
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 1] = hit_y
					'WORLDHIT_TOP = True
					
					SetSpriteHit(sprite, FROM_TOP, FROM_TOP, hit_x, hit_y)
					
					wh_value = True
				'left
				ElseIf GetLineIntersect(sprite_x1, sprite_y1, sprite_x3, sprite_y3, world_x1, world_y1, world_x2, world_y2, hit_x, hit_y) Then
					'Print "top: Line 1 = " + l1_x1 + ", " + l1_y1 + " to " + l1_x2 + ", " + l1_y2
					'Print "top: Line 2 = " + l2_x1 + ", " + l2_y1 + " to " + l2_x2 + ", " + l2_y2
					
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 0] = hit_x
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 1] = hit_y
					'WORLDHIT_LEFT = True
					
					SetSpriteHit(sprite, FROM_LEFT, FROM_TOP, hit_x, hit_y)
					
					wh_value = True
				'bottom
				ElseIf GetLineIntersect(sprite_x3, sprite_y3, sprite_x4, sprite_y4, world_x1, world_y1, world_x2, world_y2, hit_x, hit_y) Then
					'Print "top: Line 1 = " + l1_x1 + ", " + l1_y1 + " to " + l1_x2 + ", " + l1_y2
					'Print "top: Line 2 = " + l2_x1 + ", " + l2_y1 + " to " + l2_x2 + ", " + l2_y2
					
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 0] = hit_x
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 1] = hit_y
					'WORLDHIT_BOTTOM = True
					
					SetSpriteHit(sprite, FROM_BOTTOM, FROM_TOP, hit_x, hit_y)
					
					wh_value = True
				'right
				ElseIf GetLineIntersect(sprite_x2, sprite_y2, sprite_x4, sprite_y4, world_x1, world_y1, world_x2, world_y2, hit_x, hit_y) Then
					'Print "top: Line 1 = " + l1_x1 + ", " + l1_y1 + " to " + l1_x2 + ", " + l1_y2
					'Print "top: Line 2 = " + l2_x1 + ", " + l2_y1 + " to " + l2_x2 + ", " + l2_y2
					
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 0] = hit_x
					'Sprite_Hits_Pos[sprite, Sprite_Hits_Count[sprite, HIT_TYPE_WORLD], 1] = hit_y
					'WORLDHIT_RIGHT = True
					
					SetSpriteHit(sprite, FROM_RIGHT, FROM_TOP, hit_x, hit_y)
					
					wh_value = True
				End If
			Case GEOMETRY_CIRCLE
				Return 0
			End Select
		Next
	End If
	
	return wh_value
	
End Function


Sub Sprite_CheckCollisions(layer)
	If Layer_Sprites_Count[layer] > 1 Then
		For s1 = 0 to Layer_Sprites_Count[layer]-1
			sprite1 = Layer_Sprites[layer, s1]
			Sprite_Hits_Count[sprite1, HIT_TYPE_SPRITE] = 0
			Sprite_Hits[sprite1, HIT_TYPE_SPRITE, 0] = -1
			
			If Sprite_isSolid[sprite1] And (s1+1) < Layer_Sprites_Count[layer] Then
				For s2 = (s1+1) To Layer_Sprites_Count[layer]-1
					sprite2 = Layer_Sprites[layer, s2]
					If Sprite_isSolid[sprite2] Then
						If Sprite_GetHit(sprite1, sprite2) Then
							'Print "Collision"
							If Sprite_Hits_Count[sprite2, HIT_TYPE_SPRITE] < MAX_HITS Then
								Sprite_Hits[sprite2, HIT_TYPE_SPRITE, Sprite_Hits_Count[sprite2, HIT_TYPE_SPRITE]] = sprite1
								Sprite_Hits_Count[sprite2, HIT_TYPE_SPRITE] = Sprite_Hits_Count[sprite2, HIT_TYPE_SPRITE] + 1
							End If
							Sprite_Hits[sprite1, HIT_TYPE_SPRITE, Sprite_Hits_Count[sprite1, HIT_TYPE_SPRITE]] = sprite2
							Sprite_Hits_Count[sprite1, HIT_TYPE_SPRITE] = Sprite_Hits_Count[sprite1, HIT_TYPE_SPRITE] +1
							If Sprite_Hits_Count[sprite1, HIT_TYPE_SPRITE] = MAX_HITS Then
								Exit For
							End If
						End If
					End If
				Next
			End If
		Next
	End If
End Sub




'-----------------SPRITES----------------------------

Sub SaveSprite(sprite, spr_name$)
	f = FreeFile()
	FileOpen(f, Sprite_Dir$ + spr_name$ + ".spr", BINARY_OUTPUT)
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
	
	'Print "sprite n_fps = " + Sprite_FPS[sprite]
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
	
	Sprite_HitBox_Shape[sprite] = HITBOX_RECT
	Sprite_HitBox_Pos[sprite, 0] = 0
	Sprite_HitBox_Pos[sprite, 1] = 0
	Sprite_HitBox_Size[sprite, 0] = FrameSheet_Frame_Width[Sprite_FrameSheet[sprite]]
	Sprite_HitBox_Size[sprite, 1] = FrameSheet_Frame_Height[Sprite_FrameSheet[sprite]]
	
	Sprite_isSolid[sprite] = True
	
	'Print "Sprite sheet = " + f_sheet
	'Print "f_width = " + f_width
	'Print "f_height = " + f_height
	
	Return sprite
End Function

Function Sprite_Instance(src_sprite)
	print "src = ";src_sprite
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
	
	Sprite_FPS[sprite] = Sprite_FPS[src_sprite]
	Sprite_FrameTime[sprite] = Sprite_FrameTime[src_sprite]
	Sprite_NumAnimations[sprite] = Sprite_NumAnimations[src_sprite]
	
	If Sprite_NumAnimations[sprite] > 0 Then
		For i = 0 to Sprite_NumAnimations[sprite] - 1
			
			Sprite_NumAnimationFrames[sprite, i] = Sprite_NumAnimationFrames[src_sprite,i]
			
			If Sprite_NumAnimationFrames[sprite, i] > 0 Then
				For frame_num = 0 to Sprite_NumAnimationFrames[sprite, i]-1
					Sprite_Frames[sprite, i, frame_num] = Sprite_Frames[src_sprite, i, frame_num]
				Next
			End If
			
		
		Next
	End If
	
	Sprite_FrameSheet[sprite] = Sprite_FrameSheet[src_sprite]
	Sprite_Exists[sprite] = Sprite_Exists[src_sprite]
	
	Sprite_Scale_Dim[sprite,0] = Sprite_Scale_Dim[src_sprite,0]
	Sprite_Scale_Dim[sprite,1] = Sprite_Scale_Dim[src_sprite,1]
	
	Sprite_HitBox_Shape[sprite] = Sprite_HitBox_Shape[src_sprite]
	Sprite_HitBox_Pos[sprite, 0] = Sprite_HitBox_Pos[src_sprite,0]
	Sprite_HitBox_Pos[sprite, 1] = Sprite_HitBox_Pos[src_sprite,1]
	Sprite_HitBox_Size[sprite, 0] = Sprite_HitBox_Size[src_sprite,0]
	Sprite_HitBox_Size[sprite, 1] = Sprite_HitBox_Size[src_sprite,1]
	
	Sprite_isSolid[sprite] = Sprite_isSolid[src_sprite]
	
	Return sprite
End Function

Sub ClearSprite(sprite)	
	Sprite_FPS[sprite] = 0
	Sprite_FrameTime[sprite] = 0
	Sprite_NumAnimations[sprite] = 0
	
	f_sheet$ = ""
	f_width = 0
	f_height = 0
	
	ClearFrameSheet(Sprite_FrameSheet[sprite])
	Sprite_Exists[sprite] = False
	Sprite_isSolid[sprite] = False
End Sub

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
	
	Sprite_HitBox_Shape[sprite] = HITBOX_RECT
	Sprite_HitBox_Pos[sprite, 0] = 0
	Sprite_HitBox_Pos[sprite, 1] = 0
	Sprite_HitBox_Size[sprite, 0] = FrameSheet_Frame_Width[f_sheet]
	Sprite_HitBox_Size[sprite, 1] = FrameSheet_Frame_Height[f_sheet]
	
	Sprite_isSolid[sprite] = True
	
	Return sprite
End Function

Sub KillSprite(sprite)
	Sprite_Exists[sprite] = False
	Sprite_Animation_isPlaying[sprite] = False
	Sprite_Animation_isPaused[sprite] = False
	
	'Remove sprite from any layer it is currently on
	For layer = 0 to MAX_LAYERS-1
		If Layer_Sprites_Count[layer] > 0 Then
			For s = 0 to Layer_Sprites_Count[layer]-1
				If Layer_Sprites[layer, s] = sprite Then
					Layer_Sprites[layer, s] = -1
				End If
			Next
		End If
	Next
	
End Sub

Sub Sprite_SetChild(parent_sprite, child_sprite, child_offset_x, child_offset_y)
	Sprite_Parent[child_sprite] = parent_sprite
	Sprite_Child_Offset[child_sprite, 0] = child_offset_x
	Sprite_Child_Offset[child_sprite, 1] = child_offset_y
	Sprite_isChild[child_sprite] = True
End Sub

Sub Sprite_ReleaseChild(child_sprite)
	Sprite_isChild[child_sprite] = False
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

Sub Sprite_SetFPS(sprite, n_fps)
	Sprite_FPS[sprite] = n_fps
	Sprite_FrameTime[sprite] = 1000 / n_fps
End Sub

Sub Sprite_Play(sprite, anim_num, anim_loops)
	If Not Sprite_Exists[sprite] Then
		Return
	End If
	Sprite_Animation_NumLoops[sprite] = anim_loops
	Sprite_Animation_CurrentLoop[sprite] = 0
	Sprite_Animation_isPlaying[sprite] = True
	Sprite_CurrentAnimation[sprite] = anim_num
	Sprite_Animation_CurrentFrame[sprite] = 0
	'Sprite_Frames[sprite, anim_num, 0]
	Sprite_StartTime[sprite] = Timer()
End Sub

Function Sprite_GetAnimation(sprite)
	Return Sprite_CurrentAnimation[sprite]
End Function

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
	If Not Sprite_isSolid[sprite] Then
		Sprite_Pos[sprite,0] = x
		Sprite_Pos[sprite,1] = y
		Return
	End If
	If Not Sprite_GetWorldHit(sprite, x, y) Then
		Sprite_Pos[sprite,0] = x
		Sprite_Pos[sprite,1] = y
	End If
End Sub

Function Sprite_Move(sprite, x, y)
	nx = Sprite_Pos[sprite,0] + x
	ny = Sprite_Pos[sprite,1] + y
	If Not Sprite_isSolid[sprite] Then
		Sprite_Pos[sprite,0] = nx
		Sprite_Pos[sprite,1] = ny
		Return True
	End If
	If Not Sprite_GetWorldHit(sprite, nx, ny) Then
		Sprite_Pos[sprite,0] = nx
		Sprite_Pos[sprite,1] = ny
		Return True
	End If
	Return False
End Function

Sub Sprite_Scale(sprite, zx, zy)
	Sprite_Scale_Dim[sprite, 0] = zx
	Sprite_Scale_Dim[sprite, 1] = zy
End Sub

Sub Sprite_Rotate(sprite, angle)
	Sprite_Angle[sprite] = angle
End Sub

Sub Sprite_SetLayer(sprite, spr_layer)
	If Layer_Sprites_Count[spr_layer] <= 0 Then
		Layer_Sprites_Count[spr_layer] = 1
	End If
	
	'Remove sprite from any layer it is currently on
	For layer = 0 to MAX_LAYERS-1
		If Layer_Sprites_Count[layer] > 0 Then
			For s = 0 to Layer_Sprites_Count[layer]-1
				If Layer_Sprites[layer, s] = sprite Then
					Layer_Sprites[layer, s] = -1
				End If
			Next
		End If
	Next
	
	'Add sprite to spr_layer
	spr_set = False
	For s = 0 to Layer_Sprites_Count[spr_layer]-1
		If Layer_Sprites[spr_layer, s] = -1 Then
			Layer_Sprites[spr_layer, s] = sprite
			spr_set = True
			Exit For
		End If
	Next
	
	If Not spr_set Then
		Layer_Sprites[spr_layer, Layer_Sprites_Count[spr_layer]] = sprite
		Layer_Sprites_Count[spr_layer] = Layer_Sprites_Count[spr_layer] + 1
	End If
	
	Sprite_Layer[sprite] = spr_layer
End Sub

'----------------MAPS AND TILES--------------------
Sub TileSet_GetFrame(frame_num, ByRef x, ByRef y, ByRef w, ByRef h)
	tset = TileSet_FrameSheet
	frames_per_row = FrameSheet_Width[tset] / FrameSheet_Frame_Width[tset]
	src_x = Int(frame_num MOD frames_per_row) * FrameSheet_Frame_Width[tset]
	src_y = Int(frame_num / frames_per_row) * FrameSheet_Frame_Height[tset]
	x = src_x
	y = src_y
	w = FrameSheet_Frame_Width[tset]
	h = frameSheet_Frame_Height[tset]
End Sub

Sub CreateTileSet(img_file$, tile_width, tile_height)
	TileSet_Name$ = ""
	If TileSet_Init Then
		If ImageExists(TileSet_Image) Then
			DeleteImage(TileSet_Image)
		End If
	End If
	If Length(img_file$) > 0 Then
		For i = 0 to Length(img_file$)-1
			If Mid$(img_file$, i, 1) <> "." Then
				TileSet_Name$ = TileSet_Name$ + Mid$(img_file$, i, 1)
			Else
				Exit For
			End If
		Next
	End If
	TileSet_FS_Flag = 1
	TileSet_FrameSheet = LoadFrameSheet(img_file$, tile_width, tile_height)
	TileSet_FS_Flag = 0
	TileSet_Image = FrameSheet_Image[TileSet_FrameSheet]
	NumTiles = (FrameSheet_Width[ TileSet_FrameSheet ] / tile_width) * (FrameSheet_Height[ TileSet_FrameSheet ] / tile_height)
	TileSet_FPS = 16
	TileSet_FrameTime = 1000/TileSet_FPS
	For i = 0 to MAX_TILES-1
		TileSet_NumFrames[i] = 1
		TileSet_Frames[i, 0] = i
	Next
	TileSet_FramesPerRow = FrameSheet_Width[ TileSet_FrameSheet ] / FrameSheet_Frame_Width[ TileSet_FrameSheet ]
	TileSet_Init = 1
End Sub

Sub Tile_AddFrame(tile, t_frame)
	If TileSet_NumFrames[tile] < MAX_TILE_FRAMES Then
		TileSet_Frames[tile, TileSet_NumFrames[tile]] = t_frame
		TileSet_NumFrames[tile] = TileSet_NumFrames[tile] + 1
	End If
End Sub

Sub Tile_SetFrame(tile, frame_num, t_frame)
	If frame_num >= 0 And frame_num < MAX_TILE_FRAMES Then
		TileSet_Frames[tile, frame_num] = t_frame
	End If
End Sub

Sub Tile_RemoveFrame(tile)
	If TileSet_NumFrames[tile] > 0 Then
		TileSet_NumFrames[tile] = TileSet_NumFrames[tile] - 1
		TileSet_Frames[tile, TileSet_NumFrames[tile]] = 0
	End If
End Sub

Sub TileSet_SetFPS( t_fps )
	TileSet_FPS = t_fps
	TileSet_FrameTime = 1000 / t_fps
End Sub

Function Round_Up( n )
	If Frac(n) > 0 Then
		Return Int(n+1)
	Else
		Return Int(n)
	End If
End Function

Sub CreateMap(width_in_tiles, height_in_tiles, vpx, vpy, vpw, vph, sect_w, sect_h)
	Map_Width = width_in_tiles
	Map_Height = height_in_tiles
	Map_Width_InPixels = Map_Width * FrameSheet_Frame_Width[ TileSet_FrameSheet ]
	Map_Height_InPixels = Map_Height * FrameSheet_Frame_Height[ TileSet_FrameSheet ]
	Map_Viewport_X = vpx
	Map_Viewport_Y = vpy
	Map_Viewport_Width = vpw
	Map_Viewport_Height = vph
	
	Video_Layer = -1
	
	dim win_w
	dim win_h
	GetWindowSize(0, win_w, win_h)
	
	cw = win_w + (FrameSheet_Frame_Width[ TileSet_FrameSheet ]*2)
	ch = win_h + (FrameSheet_Frame_Height[ TileSet_FrameSheet ]*2)
	
	Layer_Flag_Tiles[0] = True
	'Empty Tiles
	For i = 0 to MAX_LAYERS-1
		CanvasClose(i)
		CanvasOpen(i, cw, ch, vpx, vpy, vpw, vph, 1)
		Canvas(i)
		SetCanvasZ(i, i)
		SetCanvasVisible(i, FALSE)
		Map_Layer_isVisible[i] = FALSE
		Map_Layer_Alpha[i] = 255
		Map_Offset_X[i] = 0
		Map_Offset_Y[i] = 0
		Map_Offset_Interval[i] = 1
		For x = 0 to MAX_MAP_WIDTH-1
			For y = 0 to MAX_MAP_HEIGHT-1
				Map_Tiles[i, x, y] = -1
			Next
		Next
	Next
	
	SetCanvasVisible(0, TRUE)
	Map_Layer_isVisible[0] = TRUE
	
	'Dimension Sectors
	Map_Sector_Width = sect_w
	Map_Sector_Height = sect_h
	tile_w = FrameSheet_Frame_Width[ TileSet_FrameSheet ]
	tile_h = FrameSheet_Frame_Height[ TileSet_FrameSheet ]
	
	total_sects_across = Round_Up(Map_Width_InPixels / sect_w)
	total_sects_down = Round_Up(Map_Height_InPixels / sect_h)
	Map_Sector_Across = total_sects_across
	Map_Sector_Down = total_sects_down
	
	Map_NumSectors =  total_sects_across * total_sects_down
	
	'Set Sector Positions
	For row = 0 to total_sects_down-1
		For col = 0 to total_sects_across-1
			Map_Sector_Pos[(row * total_sects_across) + col, 0] = col * sect_w
			Map_Sector_Pos[(row * total_sects_across) + col, 1] = row * sect_h
		Next
	Next
	
	NumGeometries = 0
	Layer_GeometryColor = RGB(255,255,255)
	'Empty Sectors
	For i = 0 to MAX_LAYERS-1
		For s = 0 to MAX_SECTORS-1
			Map_NumSectorGeometries[i, s] = 0
			For g = 0 to MAX_GEOMETRIES_PER_SECTOR-1
				Map_Geometries[i, s, g] = 0
			Next
		Next
	Next
End Sub

Sub SaveTileSet()
	f = FreeFile()
	
	FileOpen(f, Gfx_Dir$ + TileSet_Name$ + ".fsi", TEXT_OUTPUT)
	WriteLine(f, FrameSheet_File$[ TileSet_FrameSheet ] + "\n")
	WriteLine(f, Str$(FrameSheet_Frame_Width[ TileSet_FrameSheet ]) +"\n")
	WriteLine(f, Str$(FrameSheet_Frame_Height[ TileSet_FrameSheet ]) +"\n")
	FileClose(f)
	
	FileOpen(f, Gfx_Dir$ + TileSet_Name$ + ".ts", BINARY_OUTPUT)
	File_Write32(f, TileSet_FramesPerRow)
	File_Write32(f, TileSet_FPS)
	If NumTiles > 0 Then
		For t = 0 to NumTiles-1
			File_Write32(f, TileSet_NumFrames[t])
			If TileSet_NumFrames[t] > 0 Then
				For frame = 0 to TileSet_NumFrames[t]-1
					File_Write32(f, TileSet_Frames[t, frame])
				Next
			End If
		Next
	End If
	FileClose(f)
End Sub

Sub LoadTileSet(tset$)
	If ImageExists(FrameSheet_Image[TileSet_FrameSheet]) Then
		DeleteImage(FrameSheet_Image[TileSet_FrameSheet])
	End If
	
	TileSet_Name$ = tset$
	
	If (Not FileExists(Gfx_Dir$ + TileSet_Name$ + ".fsi") ) Or (Not FileExists(Gfx_Dir$ + TileSet_Name$ + ".ts") ) Then
		Print "Could not load Tileset: " + Gfx_Dir$ + TileSet_Name$
		Return
	End If
	
	f = FreeFile()
	
	FileOpen(f, Gfx_Dir$ + TileSet_Name$ + ".fsi", TEXT_INPUT)
	fs_file$ = ReadLine$(f)
	fw = Val(ReadLine$(f))
	fh = Val(ReadLine$(f))
	FileClose(f)
	
	TileSet_FS_Flag = 1
	TileSet_FrameSheet = LoadFrameSheet(fs_file$, fw, fh)
	TileSet_FS_Flag = 0
	NumTiles = Int(FrameSheet_Width[ TileSet_FrameSheet ] / fw) * Int(FrameSheet_Height[ TileSet_FrameSheet ] / fh)
	TileSet_Image = FrameSheet_Image[TileSet_FrameSheet]
	
	FileOpen(f, Gfx_Dir$ + TileSet_Name$ + ".ts", BINARY_INPUT)
	TileSet_FramesPerRow = File_Read32(f)
	TileSet_FPS = File_Read32(f)
	TileSet_FrameTime = 1000 / TileSet_FPS
	
	If NumTiles > 0 Then
		For t = 0 to NumTiles-1
			TileSet_NumFrames[t] = File_Read32(f)
			If TileSet_NumFrames[t] > 0 Then
				For frame = 0 to TileSet_NumFrames[t]-1
					TileSet_Frames[t, frame] = File_Read32(f)
				Next
			End If
		Next
	End If
	FileClose(f)
	TileSet_Init = 1
End Sub

Sub ClearTileSet()
	DeleteImage(FrameSheet_Image[TileSet_FrameSheet])
	
	
	TileSet_Name$ = ""
	
	
	TileSet_FS_Flag = 1
	ClearFrameSheet(TileSet_FrameSheet)
	TileSet_FS_Flag = 0
	NumTiles = 0
	
	TileSet_FramesPerRow = 0
	TileSet_FPS = 0
	TileSet_FrameTime = 0
	
	TileSet_Init = 0
End Sub

Sub SaveMap(map_name$)
	SaveTileSet()
	f = FreeFile()
	
	FileOpen(f, Map_Dir$ + map_name$ + ".mfi", TEXT_OUTPUT)
	WriteLine(f, TileSet_Name$)
	FileClose(f)
	
	FileOpen(f, Map_Dir$ + map_name$ + ".map", BINARY_OUTPUT)
	File_Write32(f, Map_Width)
	File_Write32(f, Map_Height)
	File_Write32(f, Map_Width_InPixels)
	File_Write32(f, Map_Height_InPixels)
	File_Write32(f, Map_NumSectors)
	File_Write32(f, Map_Sector_Width)
	File_Write32(f, Map_Sector_Height)
	File_Write32(f, Map_Sector_Across)
	File_Write32(f, Map_Sector_Down)
	File_Write32(f, NumGeometries)
	
	For i = 0 to MAX_LAYERS-1
		File_Write32(f, Map_Layer_Alpha[i])
		File_Write32(f, Map_Layer_isVisible[i])
		File_Write32(f, Map_Offset_Interval[i] * 1000)
		File_Write32(f, Layer_Flag_Tiles[i])
		File_Write32(f, Layer_Flag_Image[i])
		File_Write32(f, Layer_Flag_Video[i])
		File_Write32(f, Layer_Flag_Draw[i])
		File_Write32(f, Layer_Flag_Geometry[i])
		'
		For x = 0 to Map_Width-1
			For y = 0 to Map_Height-1
				File_Write32(f, Map_Tiles[i, x, y])
			Next
		Next
		If Map_NumSectors > 0 Then
			For s = 0 to Map_NumSectors-1
				File_Write32(f, Map_NumSectorGeometries[i, s])
				If Map_NumSectorGeometries[i, s] > 0 Then
					File_Write32(f, Map_Sector_Pos[s, 0])
					File_Write32(f, Map_Sector_Pos[s, 1])
					For g = 0 to Map_NumSectorGeometries[i,s]-1
						File_Write32(f, Map_Geometries[i, s, g])
					Next
				End If
			Next
		End If	
	Next
	
	If NumGeometries > 0 Then
		For i = 0 to NumGeometries-1
			File_Write32(f, Geometry[i,0])
			File_Write32(f, Geometry[i,1])
			File_Write32(f, Geometry[i,2])
			File_Write32(f, Geometry[i,3])
			File_Write32(f, Geometry_Type[i])
			File_Write32(f, Map_GeometrySector[i])
		Next
	End If
	
	FileClose(f)
End Sub

Sub LoadMap(map_name$, vpx, vpy, vpw, vph)
	f = FreeFile()
	
	FileOpen(f, Map_Dir$ + map_name$ + ".mfi", TEXT_INPUT)
	tset$ = ReadLine$(f)
	FileClose(f)
	
	LoadTileSet(tset$)
	
	FileOpen(f, Map_Dir$ + map_name$ + ".map", BINARY_INPUT)
	Map_Width = File_Read32(f)
	Map_Height = File_Read32(f)
	Map_Width_InPixels = File_Read32(f)
	Map_Height_InPixels = File_Read32(f)
	Map_NumSectors = File_Read32(f)
	Map_Sector_Width = File_Read32(f)
	Map_Sector_Height = File_Read32(f)
	Map_Sector_Across = File_Read32(f)
	Map_Sector_Down = File_Read32(f)
	NumGeometries = File_Read32(f)
	
	Map_Viewport_X = vpx
	Map_Viewport_Y = vpy
	Map_Viewport_Width = vpw
	Map_Viewport_Height = vph
	
	Video_Layer = -1
	
	cw = vpw + (FrameSheet_Frame_Width[ TileSet_FrameSheet ]*2)
	ch = vph + (FrameSheet_Frame_Height[ TileSet_FrameSheet ]*2)
	
	'Empty Tiles
	For i = 0 to MAX_LAYERS-1
		Map_Layer_Alpha[i] = File_Read32(f)
		Map_Layer_isVisible[i] = File_Read32(f)
		Map_Offset_Interval[i] = File_Read32(f) / 1000
		Layer_Flag_Tiles[i] = File_Read32(f)
		Layer_Flag_Image[i] = File_Read32(f)
		Layer_Flag_Video[i] = File_Read32(f)
		Layer_Flag_Draw[i] = File_Read32(f)
		Layer_Flag_Geometry[i] = File_Read32(f)
		
		CanvasClose(i)
		CanvasOpen(i, cw, ch, vpx, vpy, vpw, vph, 1)
		Canvas(i)
		SetCanvasZ(i,(MAX_LAYERS-1)-i)
		SetCanvasVisible(i, Map_Layer_isVisible[i])
		Map_Offset_X[i] = 0
		Map_Offset_Y[i] = 0
		
		For x = 0 to Map_Width-1
			For y = 0 to Map_Height-1
				Map_Tiles[i, x, y] = File_Read32(f)
			Next
		Next
		
		If Map_NumSectors > 0 Then
			For s = 0 to Map_NumSectors-1
				Map_NumSectorGeometries[i, s] = File_Read32(f)
				If Map_NumSectorGeometries[i, s] > 0 Then
					Map_Sector_Pos[s, 0] = File_Read32(f)
					Map_Sector_Pos[s, 1] = File_Read32(f)
					For g = 0 to Map_NumSectorGeometries[i,s]-1
						Map_Geometries[i, s, g] = File_Read32(f)
					Next
				End If
			Next
		End If
	Next
	
	SetCanvasVisible(7, True)
	'SetCanvasZ(7, 1)
	
	'CanvasOpen(8, 640, 480, 0, 0, 640, 480, 1)
	'SetCanvasZ(8,8)
	
	'CanvasOpen(9, 640, 480, 0, 0, 640, 480, 1)
	'SetCanvasZ(9,9)
	
	
	If NumGeometries > 0 Then
		For i = 0 to NumGeometries-1
			Geometry[i,0] = File_Read32(f)
			Geometry[i,1] = File_Read32(f)
			Geometry[i,2] = File_Read32(f)
			Geometry[i,3] = File_Read32(f)
			Geometry_Type[i] = File_Read32(f)
			Map_GeometrySector[i] = File_Read32(f)
		Next
	End If
	
	FileClose(f)
	
End Sub

Sub ClearMap()
	
	'Empty Tiles
	ClearTileSet()
	
	For i = 0 to MAX_LAYERS-1
		DeleteImage(Map_Bkg_Image[i])
		Map_Layer_Alpha[i] = 0
		Map_Layer_isVisible[i] = 0
		Map_Offset_Interval[i] = 0
		Layer_Flag_Tiles[i] = 0
		Layer_Flag_Image[i] = 0
		Layer_Flag_Video[i] = 0
		Layer_Flag_Draw[i] = 0
		Layer_Flag_Geometry[i] = 0
		
		Map_Offset_X[i] = 0
		Map_Offset_Y[i] = 0
		
		For x = 0 to Map_Width-1
			For y = 0 to Map_Height-1
				Map_Tiles[i, x, y] = -1
			Next
		Next
		
		If Map_NumSectors > 0 Then
			For s = 0 to Map_NumSectors-1
				If Map_NumSectorGeometries[i, s] > 0 Then
					Map_Sector_Pos[s, 0] = 0
					Map_Sector_Pos[s, 1] = 0
					For g = 0 to Map_NumSectorGeometries[i,s]-1
						Map_Geometries[i, s, g] = 0
					Next
				End If
				Map_NumSectorGeometries[i, s] = 0
			Next
		End If
	Next
	
	If NumGeometries > 0 Then
		For i = 0 to NumGeometries-1
			Geometry[i,0] = 0
			Geometry[i,1] = 0
			Geometry[i,2] = 0
			Geometry[i,3] = 0
			Geometry_Type[i] = 0
			Map_GeometrySector[i] = 0
		Next
	End If
	
	tset$ = ""
	
	Map_Width = 0
	Map_Height = 0
	Map_Width_InPixels = 0
	Map_Height_InPixels = 0
	Map_NumSectors = 0
	Map_Sector_Width = 0
	Map_Sector_Height = 0
	Map_Sector_Across = 0
	Map_Sector_Down = 0
	NumGeometries = 0
	
	Map_Viewport_X = 0
	Map_Viewport_Y = 0
	Map_Viewport_Width = 0
	Map_Viewport_Height = 0
	
	Video_Layer = -1
	
End Sub

Sub Map_SetOffset(x, y)
	For i = 0 to MAX_LAYERS-1
		If (x*Map_Offset_Interval[i]) + Map_Viewport_Width >= Map_Width_InPixels Then
			Map_Offset_X[i] = (Map_Width_InPixels - Map_Viewport_Width) - 1
		ElseIf x < 0 Then
			Map_Offset_X[i] = 0
		Else
			Map_Offset_X[i] = (x * Map_Offset_Interval[i])
		End If
		
		If (y*Map_Offset_Interval[i]) + Map_Viewport_Height >= Map_Height_InPixels Or y < 0 Then
			Map_Offset_Y[i] = (Map_Height_InPixels - Map_Viewport_Height) - 1
		ElseIf y < 0 Then
			Map_Offset_Y[i] = 0
		Else
			Map_Offset_Y[i] = (y * Map_Offset_Interval[i])
		End If
	Next
End Sub

Sub Map_Scroll(x, y)
	For i = 0 to MAX_LAYERS-1
		If Map_Offset_X[i] + (x*Map_Offset_Interval[i]) < Map_Width_InPixels - Map_Viewport_Width And Map_Offset_X[i] + (x*Map_Offset_Interval[i]) >= 0 Then
			Map_Offset_X[i] = Map_Offset_X[i] + (x*Map_Offset_Interval[i])
		End If
		
		If Map_Offset_Y[i] + (y*Map_Offset_Interval[i]) < Map_Height_InPixels - Map_Viewport_Height And Map_Offset_Y[i] + (y*Map_Offset_Interval[i]) >= 0 Then
			Map_Offset_Y[i] = Map_Offset_Y[i] + (y*Map_Offset_Interval[i])
		End If
	Next
End Sub

Sub Map_ScreenToWorld(ByRef x, ByRef y)
	x = Int((x - Map_Viewport_X) + Map_Offset_X[Map_CurrentLayer])
	y = Int((y - Map_Viewport_Y) + Map_Offset_Y[Map_CurrentLayer])
End Sub

Sub Map_WorldToScreen(ByRef x, ByRef y)
	x = (x - Map_Offset_X[Map_CurrentLayer]) + Map_Viewport_X
	y = (y - Map_Offset_Y[Map_CurrentLayer]) + Map_Viewport_Y
End Sub

Sub Map_ScreenToWorldGrid(ByRef x, ByRef y)
	fw = FrameSheet_Frame_Width[ TileSet_FrameSheet ]
	fh = FrameSheet_Frame_Height[ TileSet_FrameSheet ]
	mt_offset_x = Map_Offset_X[Map_CurrentLayer] / fw
	mt_offset_y = Map_Offset_Y[Map_CurrentLayer] / fh
	
	x = Int(  ((x-Map_Viewport_X) / fw) + mt_offset_x)
	y = Int( ( (y-Map_Viewport_Y) / fh) + mt_offset_y)
End Sub

Sub Map_ShowLayer(layer)
	SetCanvasVisible(layer, TRUE)
	Map_Layer_isVisible[layer] = TRUE
End Sub

Sub Map_HideLayer(layer)
	SetCanvasVisible(layer, FALSE)
	Map_Layer_isVisible[layer] = FALSE
End Sub

Sub Map_SetLayer(layer)
	Map_CurrentLayer = layer
	Canvas(layer)
End Sub

Sub Map_SetOffsetInterval(layer, i)
	Map_Offset_Interval[layer] = i
End Sub

Sub Map_SetTile(tile_num, x, y)
	Map_Tiles[Map_CurrentLayer, x, y] = tile_num
End Sub

Sub Map_SetBkg(image)
	dim w
	dim h
	GetImageSize(image, w, h)
	Map_Bkg_Width[Map_CurrentLayer] = w
	Map_Bkg_Height[Map_CurrentLayer] = h
	Map_Bkg_Image[Map_CurrentLayer] = image
End Sub

Sub Map_ShowBkg(layer)
	Layer_Flag_Image[layer] = true
end sub

Sub Map_HideBkg(layer)
	Layer_Flag_Image[layer] = false
end sub

Sub Map_QuickSetBkg(layer, bkg_image)
	Map_SetLayer(layer)
	Map_ShowLayer(layer)
	Map_SetBkg(bkg_image)
	Map_ShowBkg(layer)
End Sub

Sub Map_PlayVideo(vloops)
	If VideoExists() And Video_Layer >= 0 Then
		PlayVideo(vloops)
	End If
End Sub

Function Map_Geometry_AddRect(x, y, w, h)
	Geometry[NumGeometries, 0] = x
	Geometry[NumGeometries, 1] = y
	Geometry[NumGeometries, 2] = w
	Geometry[NumGeometries, 3] = h
	Geometry_Type[NumGeometries] = GEOMETRY_RECT
	
	For i = 0 to Map_NumSectors-1
		If x >= Map_Sector_Pos[i,0] And x < (Map_Sector_Pos[i,0]+Map_Sector_Width) Then
			If y >= Map_Sector_Pos[i,1] And y < (Map_Sector_Pos[i,1]+Map_Sector_Height) Then
				Map_GeometrySector[NumGeometries] = i
				Map_Geometries[Map_CurrentLayer, i, Map_NumSectorGeometries[Map_CurrentLayer, i]] = NumGeometries
				Map_NumSectorGeometries[Map_CurrentLayer, i] = Map_NumSectorGeometries[Map_CurrentLayer, i] + 1
				Exit For
			End If
		End If
	Next
	
	g = NumGeometries
	NumGeometries = NumGeometries + 1
	Return g
End Function

Function Map_Geometry_AddLine(x1, y1, x2, y2)
	Geometry[NumGeometries, 0] = x1
	Geometry[NumGeometries, 1] = y1
	Geometry[NumGeometries, 2] = x2
	Geometry[NumGeometries, 3] = y2
	Geometry_Type[NumGeometries] = GEOMETRY_LINE
	
	For i = 0 to Map_NumSectors-1
		If x1 >= Map_Sector_Pos[i,0] And x1 < (Map_Sector_Pos[i,0]+Map_Sector_Width) Then
			If y1 >= Map_Sector_Pos[i,1] And y1 < (Map_Sector_Pos[i,1]+Map_Sector_Height) Then
				Map_GeometrySector[NumGeometries] = i
				Map_Geometries[Map_CurrentLayer, i, Map_NumSectorGeometries[Map_CurrentLayer, i]] = NumGeometries
				Map_NumSectorGeometries[Map_CurrentLayer, i] = Map_NumSectorGeometries[Map_CurrentLayer, i] + 1
				Exit For
			End If
		End If
	Next
	
	g = NumGeometries
	NumGeometries = NumGeometries + 1
	Return g
End Function

Function Map_Geometry_AddCircle(x, y, r)
	Geometry[NumGeometries, 0] = x
	Geometry[NumGeometries, 1] = y
	Geometry[NumGeometries, 2] = r
	Geometry_Type[NumGeometries] = GEOMETRY_CIRCLE
	
	For i = 0 to Map_NumSectors-1
		If x >= Map_Sector_Pos[i,0] And x < (Map_Sector_Pos[i,0]+Map_Sector_Width) Then
			If y >= Map_Sector_Pos[i,1] And y < (Map_Sector_Pos[i,1]+Map_Sector_Height) Then
				Map_GeometrySector[NumGeometries] = i
				Map_Geometries[Map_CurrentLayer, i, Map_NumSectorGeometries[Map_CurrentLayer, i]] = NumGeometries
				Map_NumSectorGeometries[Map_CurrentLayer, i] = Map_NumSectorGeometries[Map_CurrentLayer, i] + 1
				Exit For
			End If
		End If
	Next
	
	g = NumGeometries
	NumGeometries = NumGeometries + 1
	Return g
End Function

Sub Map_Geometry_Edit(g_num, g_type, n1, n2, n3, n4)
	Geometry[g_num, 0] = n1
	Geometry[g_num, 1] = n2
	Geometry[g_num, 2] = n3
	Geometry[g_num, 3] = n4
	Geometry_Type[g_num] = g_type
End Sub

Sub Map_Geometry_Remove()
	If NumGeometries > 0 Then
		sect = Map_GeometrySector[NumGeometries-1]
		Map_NumSectorGeometries[ Map_CurrentLayer, sect ] = Map_NumSectorGeometries[ Map_CurrentLayer, sect ] - 1
		NumGeometries = NumGeometries - 1
	End If
End Sub

Sub Map_SetLayerFlag(flag, n)
	Select Case flag
	Case TILE_FLAG
		Layer_Flag_Tiles[Map_CurrentLayer] = n
	Case IMAGE_FLAG
		Layer_Flag_Image[Map_CurrentLayer] = n
	Case VIDEO_FLAG
		If n Then
			Video_Layer = Map_CurrentLayer
			Canvas(Map_CurrentLayer)
			SetVideoDrawRect(0, 0, Map_Viewport_Width, Map_Viewport_Height)
			For i = 0 to MAX_LAYERS-1
				Layer_Flag_Video[i] = False
			Next
			Layer_Flag_Video[Map_CurrentLayer] = n
		
			Layer_Flag_Tiles[Map_CurrentLayer] = False
			Layer_Flag_Image[Map_CurrentLayer] = False
			Layer_Flag_Geometry[Map_CurrentLayer] = False
		Else
			Layer_Flag_Video[Map_CurrentLayer] = n
		End If
	Case DRAW_FLAG
		Layer_Flag_Draw[Map_CurrentLayer] = n
	Case GEOMETRY_FLAG
		Layer_Flag_Geometry[Map_CurrentLayer] = n
	End Select
End Sub

Sub DrawTileFrame(frame_num, x, y)
	image = FrameSheet_Image[ TileSet_FrameSheet ]
	src_x = Int(frame_num MOD TileSet_FramesPerRow) * FrameSheet_Frame_Width[ TileSet_FrameSheet ]
	src_y = Int(frame_num / TileSet_FramesPerRow) * FrameSheet_Frame_Height[ TileSet_FrameSheet ]
	DrawImage_Blit(TileSet_Image, x, y, src_x, src_y, FrameSheet_Frame_Width[ TileSet_FrameSheet ], FrameSheet_Frame_Height[TileSet_FrameSheet])
End Sub

Sub DrawGeometry( g_num, layer, mx, my )
	x_off = Map_Offset_X[layer]-mx
	y_off = Map_Offset_Y[layer]-my
	Select Case Geometry_Type[g_num]
	Case GEOMETRY_LINE
		Line(Geometry[g_num,0]-x_off, Geometry[g_num,1]-y_off, Geometry[g_num,2]-x_off, Geometry[g_num,3]-y_off)
	Case GEOMETRY_RECT
		Rect(Geometry[g_num,0]-x_off, Geometry[g_num,1]-y_off, Geometry[g_num,2], Geometry[g_num,3])
	Case GEOMETRY_CIRCLE
		Circle(Geometry[g_num,0]-x_off, Geometry[g_num,1]-y_off, Geometry[g_num,2])
	End Select
End Sub

Sub UpdateTiles()
	currentTime = timer()
	If currentTime - TileSet_StartTime >= TileSet_FrameTime And NumTiles > 0 Then
		For tile = 0 to NumTiles-1
			TileSet_CurrentFrame[tile] = TileSet_CurrentFrame[tile] + 1
			If TileSet_CurrentFrame[tile] >= TileSet_NumFrames[tile] Then
				TileSet_CurrentFrame[tile] = 0
			End If
		Next
		TileSet_StartTime = currentTime
	End If
End Sub

Sub UpdateSprites()
	currentTime = timer()
	For sprite = 0 to NumSprites-1
		If Sprite_Animation_isPlaying[sprite] Then
			If currentTime - Sprite_StartTime[sprite] >= Sprite_FrameTime[sprite] Then
				Sprite_StartTime[sprite] = currentTime
				Sprite_Animation_CurrentFrame[sprite] = Sprite_Animation_CurrentFrame[sprite] + 1
				If Sprite_Animation_CurrentFrame[sprite] >= Sprite_NumAnimationFrames[sprite, Sprite_CurrentAnimation[sprite]] Then
					Sprite_Animation_CurrentLoop[sprite] = Sprite_Animation_CurrentLoop[sprite] + 1
					Sprite_Animation_CurrentFrame[sprite] = 0
					If Sprite_Animation_CurrentLoop[sprite] = Sprite_Animation_NumLoops[sprite] Then
						Sprite_Animation_isPlaying[sprite] = False
						Sprite_Animation_CurrentLoop[sprite] = 0
					End If
				End If
			End If
		End If
	Next
	'Print "Update Sprites Complete"
End Sub

Dim Sprite_IsTopLayer[MAX_SPRITES]

Sub Sprite_RenderTopLayer(sprite, top_value)
	Sprite_IsTopLayer[sprite] = top_value
End Sub

Sub OrderSprites()
	spr_num_a = 0
	spr_num_b = 0
	For layer = 0 to MAX_LAYERS-1
		If Layer_Sprites_Count[layer] > 0 Then
			For sprite_a = 0 to Layer_Sprites_Count[layer]-1
				spr_num_a = Layer_Sprites[layer, sprite_a]
				If spr_num_a >= 0 Then
					For sprite_b = sprite_a to Layer_Sprites_Count[layer]-1
						spr_num_b = Layer_Sprites[layer, sprite_b]
						If Sprite_Pos[spr_num_b,1] < Sprite_Pos[spr_num_a,1] And (spr_num_b >= 0) Then
							Layer_Sprites[layer, sprite_a] = spr_num_b
							Layer_Sprites[layer, sprite_b] = spr_num_a
						End If
					Next
				End If
			Next
		End If
	Next
	'Print "Order Sprites Complete"
End Sub

l_dbg = 0

Refresh_rate = (1000 - (5*60))/60 '5 is the wait time after update and 30 is the target n_fps
Refresh_timer = timer

fps_start = Refresh_timer
fps_frame = 0
n_fps = 0

Sub Render()
	Cls()
	sect_across = Int(Map_Offset_X[0] / Map_Sector_Width) 
	sect_down = Int(Map_Offset_Y[0] / Map_Sector_Height)
	'dbg_sector = Map_CurrentSector
	Map_CurrentSector = (sect_down * Map_Sector_Across) + sect_across
	
	'If dbg_sector <> Map_CurrentSector Then
	'	Print "Sector = " + Map_CurrentSector
	'	Print "sect_down = " + sect_down
	'	Print "sect_across = " + sect_across
	'	Print "Map_Sector_Across = " + Map_Sector_Across
	'	Print "Map_Sector_Down = " + Map_Sector_Down
	'	Print "Map_Offset_X[0] = " + Map_Offset_X[0]
	'	Print "Map_Offset_Y[0] = " + Map_Offset_Y[0]
	'	Print "Map_Sector_Width = " + Map_Sector_Width
	'	Print "Map_Sector_Height = " + Map_Sector_Height
	'End If
	
	If NumTiles > 0 Then
		UpdateTiles()
	End If
	fw = FrameSheet_Frame_Width[ TileSet_FrameSheet ]
	fh = FrameSheet_Frame_Height[ TileSet_FrameSheet ]
	
	
	If Not ImageExists(FrameSheet_Image[ TileSet_FrameSheet ]) Then
		Return
	End If
	
	'print "Dw = " + draw_width
	'print "Dh = " + draw_height
	
	If NumSprites > 0 Then
		OrderSprites()
		UpdateSprites()
	End If
	If timer - Refresh_timer > Refresh_rate Then
	
		For i = 0 to MAX_LAYERS-2
			If Map_Layer_isVisible[i] And i <> Video_Layer Then
				Canvas(i)
				ClearCanvas()
				draw_width = (Map_Viewport_Width / fw) + 1
				draw_height = (Map_Viewport_Height / fh) + 1
				
				If Map_Offset_X[i] + Map_Viewport_Width >= Map_Width_InPixels Then
					draw_width = draw_width - 1
				End If
				
				If Map_Offset_Y[i] + Map_Viewport_Height >= Map_Height_InPixels Then
					draw_height = draw_height - 1
				End If
				
				mt_offset_x = Map_Offset_X[i] / fw
				mt_offset_y = Map_Offset_Y[i] / fh
				
				map_canvas_offset_x = Map_Offset_X[i] MOD fw
				map_canvas_offset_y = Map_Offset_Y[i] MOD fh
				SetCanvasOffset(i, map_canvas_offset_x, map_canvas_offset_y)
				
				
				If Layer_Flag_Image[i] And ImageExists(Map_Bkg_Image[i]) Then
					DrawImage_Blit_Ex(Map_Bkg_Image[i], map_canvas_offset_x, map_canvas_offset_y, Map_Viewport_Width, Map_Viewport_Height, 0, 0, Map_Bkg_Width[i], Map_Bkg_Height[i])
				End If
				
				If Layer_Flag_Tiles[i] Then
					For ty = 0 to draw_height-1
						For tx = 0 to draw_width-1
							'Draw Frame
							tile = Map_Tiles[i, mt_offset_x + tx, mt_offset_y + ty]
							If tile >= 0 Then
								tile_frame = TileSet_Frames[ tile, TileSet_CurrentFrame[tile] ]
								DrawTileFrame(tile_frame, tx*fw, ty*fh)
							End If
						Next
					Next
				End If
				
				If Layer_Sprites_Count[i] > 0 Then
					'Print "Sprite Layer = " + i
					'Print "Layer_Sprites_Count = " + Layer_Sprites_Count[i]
					anim_num = 0
					frame_num = 0
					x = 0
					y = 0
					w = 0
					h = 0
					angle = 0
					zx = 0
					zy = 0
					x_off = Map_Offset_X[i] - map_canvas_offset_x
					y_off = Map_Offset_Y[i] - map_canvas_offset_y
					Num_TopSprites = 0
					For spr = 0 to Layer_Sprites_Count[i]-1
						sprite = Layer_Sprites[i, spr]
						'Print "Sprite = " + sprite
						If sprite <> -1 Then
							If Sprite_IsTopLayer[sprite] Then
								Push_N(sprite)
								Num_TopSprites = Num_TopSprites + 1
							ElseIf Sprite_Exists[sprite] And Sprite_Animation_isPlaying[sprite] Then
								
								If Sprite_isChild[sprite] Then
									parent_sprite = Sprite_Parent[sprite]
									'print "parent " + parent_sprite
									x = (Sprite_Pos[parent_sprite,0] - x_off) + Sprite_Child_Offset[sprite, 0]
									y = (Sprite_Pos[parent_sprite,1] - y_off) + Sprite_Child_Offset[sprite, 1]
								Else
									x = Sprite_Pos[sprite,0] - x_off
									y = Sprite_Pos[sprite,1] - y_off
								End If
								
								angle = Sprite_Angle[sprite]
								zx = Sprite_Scale_Dim[sprite,0]
								zy = Sprite_Scale_Dim[sprite,1]
								anim_num = Sprite_CurrentAnimation[sprite]
								frame_num = Sprite_Animation_CurrentFrame[sprite]
								'Print "Anim_Num = " + anim_num
								'Print "Frame_Num = " + frame_num
								'Print "Sprite_Frame = " + Sprite_Frames[sprite, anim_num, frame_num]
								DrawSpriteFrame(sprite, Sprite_Frames[sprite, anim_num, frame_num], x, y, angle, zx, zy)
							End If
						End If
					Next
					For spr = 0 to Num_TopSprites-1
						sprite = Pop_N()
						'Print "!Sprite = " + sprite
						If Sprite_Exists[sprite] And Sprite_Animation_isPlaying[sprite] Then
								
								If Sprite_isChild[sprite] Then
									parent_sprite = Sprite_Parent[sprite]
									'print "parent " + parent_sprite
									x = (Sprite_Pos[parent_sprite,0] - x_off) + Sprite_Child_Offset[sprite, 0]
									y = (Sprite_Pos[parent_sprite,1] - y_off) + Sprite_Child_Offset[sprite, 1]
								Else
									x = Sprite_Pos[sprite,0] - x_off
									y = Sprite_Pos[sprite,1] - y_off
								End If
								
								angle = Sprite_Angle[sprite]
								zx = Sprite_Scale_Dim[sprite,0]
								zy = Sprite_Scale_Dim[sprite,1]
								anim_num = Sprite_CurrentAnimation[sprite]
								frame_num = Sprite_Animation_CurrentFrame[sprite]
								'Print "!Anim_Num = " + anim_num
								'Print "!Frame_Num = " + frame_num
								'Print "!Sprite_Frame = " + Sprite_Frames[sprite, anim_num, frame_num]
								DrawSpriteFrame(sprite, Sprite_Frames[sprite, anim_num, frame_num], x, y, angle, zx, zy)
						End If
					Next
					'Print "End Layer Draw"
				End If
				
				If Layer_Flag_Geometry[i] And False Then
					SetColor(Layer_GeometryColor)
					sect = Map_CurrentSector
					If Map_NumSectorGeometries[i, sect] > 0 Then
						For g = 0 to Map_NumSectorGeometries[i, sect]-1
							DrawGeometry( Map_Geometries[i, sect, g], i, map_canvas_offset_x, map_canvas_offset_y )
						Next
					End If
					
					sect = Map_CurrentSector-1
					If Map_NumSectorGeometries[i, sect] > 0 And sect >= 0 Then
						For g = 0 to Map_NumSectorGeometries[i, sect]-1
							DrawGeometry( Map_Geometries[i, sect, g], i, map_canvas_offset_x, map_canvas_offset_y )
						Next
					End If
					
					sect = Map_CurrentSector+1
					If Map_NumSectorGeometries[i, sect] > 0 And sect >= 0 And sect < Map_Sector_Across Then
						For g = 0 to Map_NumSectorGeometries[i, sect]-1
							DrawGeometry( Map_Geometries[i, sect, g], i, map_canvas_offset_x, map_canvas_offset_y )
						Next
					End If
					
					sect = Map_CurrentSector - Map_Sector_Across
					If Map_NumSectorGeometries[i, sect] > 0 And sect >= 0 And sect < Map_NumSectors Then
						For g = 0 to Map_NumSectorGeometries[i, sect]-1
							DrawGeometry( Map_Geometries[i, sect, g], i, map_canvas_offset_x, map_canvas_offset_y )
						Next
					End If
					
					sect = (Map_CurrentSector - Map_Sector_Across) - 1
					If Map_NumSectorGeometries[i, sect] > 0 And sect >= 0 And sect < Map_NumSectors Then
						For g = 0 to Map_NumSectorGeometries[i, sect]-1
							DrawGeometry( Map_Geometries[i, sect, g], i, map_canvas_offset_x, map_canvas_offset_y )
						Next
					End If
					
					sect = (Map_CurrentSector - Map_Sector_Across) + 1
					If Map_NumSectorGeometries[i, sect] > 0 And sect >= 0 And sect < Map_NumSectors Then
						For g = 0 to Map_NumSectorGeometries[i, sect]-1
							DrawGeometry( Map_Geometries[i, sect, g], i, map_canvas_offset_x, map_canvas_offset_y )
						Next
					End If
					
					sect = Map_CurrentSector + Map_Sector_Across
					If Map_NumSectorGeometries[i, sect] > 0 And sect >= 0 And sect < Map_NumSectors Then
						For g = 0 to Map_NumSectorGeometries[i, sect]-1
							DrawGeometry( Map_Geometries[i, sect, g], i, map_canvas_offset_x, map_canvas_offset_y )
						Next
					End If
					
					sect = (Map_CurrentSector + Map_Sector_Across) - 1
					If Map_NumSectorGeometries[i, sect] > 0 And sect >= 0 And sect < Map_NumSectors Then
						For g = 0 to Map_NumSectorGeometries[i, sect]-1
							DrawGeometry( Map_Geometries[i, sect, g], i, map_canvas_offset_x, map_canvas_offset_y )
						Next
					End If
					
					sect = (Map_CurrentSector + Map_Sector_Across) + 1
					If Map_NumSectorGeometries[i, sect] > 0 And sect >= 0 And sect < Map_NumSectors Then
						For g = 0 to Map_NumSectorGeometries[i, sect]-1
							DrawGeometry( Map_Geometries[i, sect, g], i, map_canvas_offset_x, map_canvas_offset_y )
						Next
					End If
				End If
			End If
		Next
		
		If Layer_Sprites_Count[3] > 0 Then
			i = 3
			'Print "Sprite Layer = "; i
			'Print "Layer_Sprites_Count = " + Layer_Sprites_Count[i]
			mt_offset_x = Map_Offset_X[0] / fw
			mt_offset_y = Map_Offset_Y[0] / fh
				
			map_canvas_offset_x = Map_Offset_X[0] MOD fw
			map_canvas_offset_y = Map_Offset_Y[0] MOD fh
			anim_num = 0
			frame_num = 0
			x = 0
			y = 0
			w = 0
			h = 0
			angle = 0
			zx = 0
			zy = 0
			x_off = Map_Offset_X[0] - map_canvas_offset_x
			y_off = Map_Offset_Y[0] - map_canvas_offset_y
			
			For spr = 0 to Layer_Sprites_Count[i]-1
				sprite = Layer_Sprites[i, spr]
				'Print "Sprite = " + sprite
				If sprite <> -1 Then
					If Sprite_Exists[sprite] And Sprite_Animation_isPlaying[sprite] Then
								
						If Sprite_isChild[sprite] Then
							parent_sprite = Sprite_Parent[sprite]
							'print "parent " + parent_sprite
							x = (Sprite_Pos[parent_sprite,0] - x_off) + Sprite_Child_Offset[sprite, 0]
							y = (Sprite_Pos[parent_sprite,1] - y_off) + Sprite_Child_Offset[sprite, 1]
						Else
							x = Sprite_Pos[sprite,0] - x_off
							y = Sprite_Pos[sprite,1] - y_off
						End If
								
						angle = Sprite_Angle[sprite]
						zx = Sprite_Scale_Dim[sprite,0]
						zy = Sprite_Scale_Dim[sprite,1]
						anim_num = Sprite_CurrentAnimation[sprite]
						frame_num = Sprite_Animation_CurrentFrame[sprite]
								'Print "Anim_Num = " + anim_num
								'Print "Frame_Num = " + frame_num
								'Print "Sprite_Frame = " + Sprite_Frames[sprite, anim_num, frame_num]
								DrawSpriteFrame(sprite, Sprite_Frames[sprite, anim_num, frame_num], x, y, angle, zx, zy)
							End If
						End If
					Next
					
					'Print "End Layer Draw"
				End If
		
		If num_draw_commands > 0 then
			map_canvas_offset_x = Map_Offset_X[0] MOD fw
			map_canvas_offset_y = Map_Offset_Y[0] MOD fh
			x_off = Map_Offset_X[0] - map_canvas_offset_x
			y_off = Map_Offset_Y[0] - map_canvas_offset_y
			for i = 0 to num_draw_commands-1
				Select Case Render_Draw_Command[i,0]
				Case DRAW_CMD_SPRITE
					sprite = Render_Draw_Command[i,1]
					x = Render_Draw_Command[i,2]
					y = Render_Draw_Command[i,3]
					angle = Sprite_Angle[sprite]
					zx = Sprite_Scale_Dim[sprite,0]
					zy = Sprite_Scale_Dim[sprite,1]
					anim_num = Sprite_CurrentAnimation[sprite]
					frame_num = Sprite_Animation_CurrentFrame[sprite]
					DrawSpriteFrame(sprite, Sprite_Frames[sprite, anim_num, frame_num], x - x_off, y - y_off, angle, zx, zy)
				End Select
			next
			num_draw_commands = 0
		end if
		
			'n_fps
			fps_frame = fps_frame + 1
			If timer - fps_start > 1000 Then
				n_fps = fps_frame
				fps_frame = 0
				fps_start = timer
			End If
			
			'DrawText("n_fps = " + str(n_fps), (Map_Offset_X[0] mod fw) + 10, (Map_Offset_Y[0] mod fh) + 10)
			
			'Update
			Update()
			Wait(5)
			Refresh_timer = timer
	End If
End Sub

msg_font = 1

jump_sound = 0
LoadSound(jump_sound, sfx_dir$ + "Jump.wav")
SetSoundVolume(jump_sound, 70)

death_sound = 1
LoadSound(death_sound, sfx_dir$ + "Explosion.wav")
SetSoundVolume(death_sound, 70)

Sub Engine_Init()
	LoadFont(msg_font, "font/FreeMono.ttf", 12)
	Font(msg_font)
	For i = 0 to MAX_FRAMESHEETS-1
		FrameSheet_Image[i] = -1
	Next
	For i = 0 to MAX_SPRITES-1
		Sprite_Animation_isPlaying[i] = False
		Sprite_isChild[i] = False
		For l = 0 to MAX_LAYERS-1
			Layer_Sprites[l, i] = -1
		Next
	Next
End Sub

'----------GAME TEST-------------------
'MAX_JBUTTONS = 30
'dim JButton[MAX_JBUTTONS]
'dim JAxis[MAX_JBUTTONS]
'dim JHat[MAX_JBUTTONS]

'Sub GetJoystick(joy_num)
'	For i = 0 to MAX_JBUTTONS-1
'		JButton[i] = 0
'		JAxis[i] = 0
'		JHat[i] = 0
'	Next
'	
'	If NumJoyHats(joy_num) > 0 Then
'		For i = 0 to NumJoyHats(joy_num)-1
'			JHat[i] = JoyHat(joy_num, i)
'		Next
'	End If
'	
'	If NumJoyButtons(joy_num) > 0 Then
'		For i = 0 to NumJoyButtons(joy_num) - 1
'			JButton[i] = JoyButton(joy_num, i)
'		Next
'	End If
'	
'	If NumJoyAxes(joy_num) > 0 Then
'		For i = 0 to NumJoyAxes(joy_num) - 1
'			JAxis[i] = JoyAxis(joy_num, i)
'		Next
'	End If
'End Sub


GRAVITY_GROUND_STATE = 0
GRAVITY_RISE_STATE = 1
GRAVITY_FALL_STATE = 2

Gravity = 4

Dim Sprite_Weight[MAX_SPRITES]
Dim Sprite_Speed[MAX_SPRITES]
Dim Sprite_Jump[MAX_SPRITES]
Dim Sprite_Gravity_State[MAX_SPRITES]
Dim Sprite_Jump_Height[MAX_SPRITES]
Dim Sprite_Jump_Start[MAX_SPRITES,2]
Dim Sprite_Jump_Force[MAX_SPRITES]
Dim Sprite_Jump_Speed[MAX_SPRITES]
Dim Sprite_Momentum[MAX_SPRITES]
Dim Sprite_Fall_Speed[MAX_SPRITES]

update_timer = timer
update_rate = 1000/100

sub World_Update(layer, focus_sprite)
	tx = 0
	ty = 0
	If Layer_Sprites_Count[layer] > 0 And (timer - update_timer > update_rate) Then
		update_timer = timer
		For s = 0 to Layer_Sprites_Count[layer]-1
			sprite = Layer_Sprites[layer, s]
			Select Case Sprite_Gravity_State[sprite]
			Case GRAVITY_GROUND_STATE
				'On ground
				'Print "Ground"
				m = Sprite_Move(sprite, Sprite_Speed[sprite], 0)
				
				If Not m Then
					If Sprite_Speed[sprite] > 1 Then
						Sprite_Speed[sprite] = 1
					ElseIf Sprite_Speed[sprite] < -1 Then
						Sprite_Speed[sprite] = -1
					Else
						Sprite_Speed[sprite] = 0
					End If
				End If
				
				m = Sprite_Move(sprite, 0, 1)
				
				If m Then
					Sprite_Gravity_State[sprite] = GRAVITY_FALL_STATE
				End If
				
				'x = Sprite_Pos[sprite, 0]
				'y = Sprite_Pos[sprite, 1]
				
				'w_hit = Sprite_GetWorldHit(sprite, x, (y + Sprite_HitBox_Size[sprite,1]) + 1)
				
				'Checks if sprite is on the ground
				'If Not w_hit Then
				'	Sprite_Gravity_State[sprite] = GRAVITY_FALL_STATE
				'End If
				
			Case GRAVITY_RISE_STATE
				'beginning to mid jump
				'Print "Rise"
				m = Sprite_Move(sprite, 0, Sprite_Jump_Speed[sprite])
				
				If (Not m) Or Sprite_Jump_Start[sprite,1] - Sprite_Pos[sprite, 1] >= Sprite_Jump_Height[sprite] Then
					Sprite_Gravity_State[sprite] = GRAVITY_FALL_STATE
				End If
				
				m = Sprite_Move(sprite, Sprite_Momentum[sprite], 0)
				
				If Not m Then
					If Sprite_Momentum[sprite] > 1 Then
						Sprite_Momentum[sprite] = 1
					ElseIf Sprite_Momentum[sprite] < -1 Then
						Sprite_Momentum[sprite] = -1
					End If
				End If
				
			Case GRAVITY_FALL_STATE
				'mid to end jump
				'Print "Fall"
				m = Sprite_Move(sprite, 0, Gravity)
				
				If Not m Then
					Sprite_Gravity_State[sprite] = GRAVITY_GROUND_STATE
				End If
				
				m = Sprite_Move(sprite, Sprite_Momentum[sprite], 0)
				
				If Not m Then
					If Sprite_Momentum[sprite] > 1 Then
						Sprite_Momentum[sprite] = 1
					ElseIf Sprite_Momentum[sprite] < -1 Then
						Sprite_Momentum[sprite] = -1
					End If
				End If
			End Select
			
			If sprite = focus_sprite Then
				Map_Scroll( Sprite_Pos[sprite,0] - (Map_Offset_X[0] + 320), Sprite_Pos[sprite,1] - (Map_Offset_Y[0] + 240) )
			End If
			
		Next
	End If
end sub

sub jump(sprite)
	Sprite_Gravity_State[sprite] = GRAVITY_RISE_STATE
	Sprite_Jump_Height[sprite] = (20-Gravity) + Sprite_Speed[sprite]
	Sprite_Jump_Speed[sprite] = -4
	Sprite_Fall_Speed[sprite] = 4
	Sprite_Jump_Start[sprite, 0] = Sprite_Pos[sprite, 0]
	Sprite_Jump_Start[sprite, 1] = Sprite_Pos[sprite, 1]
end sub

MSG_CANVAS = 8
HUD_CANVAS = 9

sub msg(txt$)
	'SetCanvasZ(6,)
	Canvas(7)
	SetColor(RGB(1, 1, 1))
	RectFill(20, 400, 600, 60)
	SetColor(RGB(255,255,255))
	DrawText(txt$, 22, 402)
	Update()
	'Wait(100)
	
	'ClearCanvas()
end sub

Dim NPC[10]
Dim NPC_Dialog$[10]
npc_text$ = ""
NPC_Count = 0
Dim Enemy[10]
Enemy_Count = 0

sub NPC_ResetList()
	For i = 0 to 9
		NPC[i] = -1
	Next
	NPC_Count = 0
end sub

sub NPC_AddSprite(sprite)
	NPC[NPC_Count] = sprite
	NPC_Count = NPC_Count + 1
end sub

sub NPC_SetDialog(sprite, txt$)
	If NPC_Count > 0 Then
		For i = 0 to NPC_Count-1
			If NPC[i] = sprite Then
				NPC_Dialog$[i] = txt$
			End If
		Next
	End If
end sub


function NPC_Hit(sprite)
	If NPC_Count > 0 Then
		For i = 0 to NPC_Count-1
			If NPC[i] >= 0 Then
				If Sprite_GetHit(sprite, NPC[i]) Then
					npc_text$ = NPC_Dialog$[i]
					Return True
				End If
			End If
		Next
	End If
	Return False
end function


Dim Teleport_Sprite[10]
Dim Teleport_Pos[10,2]
Dim Teleport_Dst_Map$[10]
Dim Teleport_Dst_Pos[10,2]
Dim Teleport_Active[10]

sub Teleport_SetSprite(t_num, sprite$)
	Teleport_Sprite[t_num] = LoadSprite(sprite$)
	Sprite_SetLayer(Teleport_Sprite[t_num], 2)
	Sprite_Play(Teleport_Sprite[t_num], 0, -1)
end sub

sub Teleport_SetPos(t_num, x, y)
	Teleport_Pos[t_num,0] = x
	Teleport_Pos[t_num,1] = y
	Sprite_Position(Teleport_Sprite[t_num], x, y)
end sub

sub Teleport_SetDst(t_num, map$, x, y)
	Teleport_Dst_Map$[t_num] = map$
	Teleport_Dst_Pos[t_num,0] = x
	Teleport_Dst_Pos[t_num,1] = y
end sub

sub Teleport_SetActive(t_num, flag)
	Teleport_Active[t_num] = flag
end sub

function isTeleportSprite(sprite)
	For i = 0 to 9
		If sprite = Teleport_Sprite[i] Then
			Return True
		End If
	Next
	Return False
end function

sub Teleport_Clear()
	For i = 0 to 9
		Teleport_Active[i] = False
	Next
end sub

sub lv_prima_hall()
	NPC_ResetList()
	Teleport_Clear()
	ent = LoadSprite("ent")
	NPC_AddSprite(ent)
	NPC_SetDialog(ent, "Yo whats up")
	Sprite_SetLayer(ent, 2)
	Sprite_Position(ent, 150, 440)
	Sprite_Play(ent, 0, -1)
end sub

sub OnTeleport(sprite, map$)
	For i = 0 to NumSprites-1
		If Sprite_Exists[i] And (Not isTeleportSprite(i)) And (i <> sprite) And (sprite <> Sprite_Parent[i]) Then
			KillSprite(i)
		End If
	Next
	If map$ = "test" Then
		'lv_test()
	ElseIf map$ = "prima_hall" Then
		'lv_prima_hall()
	End If
end sub

sub Teleport_Check(sprite)
	For i = 0 to 9
		If Teleport_Active[i] Then
			If Sprite_GetHit(sprite, Teleport_Sprite[i]) Then
				LoadMap(Teleport_Dst_Map$[i], 0, 0, 640, 480)
				Sprite_Position(sprite, Teleport_Dst_Pos[i,0], Teleport_Dst_Pos[i,1])
				Map_SetOffset(Teleport_Dst_Pos[i,0], Teleport_Dst_Pos[i,1])
				OnTeleport(sprite, Teleport_Dst_Map$[i])
			End If
		End If
	Next
end sub


sub render_cmd_drawSprite(sprite, x, y)
	If num_draw_commands < MAX_DRAW_COMMANDS Then
		Render_Draw_Command[num_draw_commands, 0] = DRAW_CMD_SPRITE
		Render_Draw_Command[num_draw_commands,1] = sprite
		Render_Draw_Command[num_draw_commands,2] = x
		Render_Draw_Command[num_draw_commands,3] = y
		num_draw_commands = num_draw_commands + 1
	End If
end sub

PLAYER_DK = 0
PLAYER_ALANA = 1

sp_pressed = 0
hero_attack_animation = 0
hero_direction = 0
hero_ready = 1

hero_move_timer = timer
hero_move_rate = 2

sub control_joystick(sprite, player)
	If NumJoysticks() > 1 Then
		GetJoystick(player)
	Else
		GetJoystick(0)
	End If
	
	jump_button = 0
	
	Select Case player
	Case 0
		jump_button = PLAYER1_BUTTON_JUMP
	Case 1
		jump_button = PLAYER2_BUTTON_JUMP
	End Select
	
	hero_current_animation = Sprite_GetAnimation(sprite)
	hero_animation = hero_current_animation
	
	'If Key(K_LEFT) Then
	If JHat[0] = HAT_LEFT And (timer - hero_move_timer > hero_move_rate) Then
		If Sprite_Gravity_State[sprite] = GRAVITY_GROUND_STATE Then
			hero_animation = 5 'run left animation
			hero_direction = 1 'LEFT DIRECTION
		End If
		If Sprite_Speed[sprite] > -3 then
			Sprite_Speed[sprite] = Sprite_Speed[sprite] - 0.1
			Sprite_Momentum[sprite] = Sprite_Speed[sprite] * 1.5
		End If
	End If
	
	'If Key(K_RIGHT) Then
	If JHat[0] = HAT_RIGHT And (timer - hero_move_timer > hero_move_rate) Then
		If Sprite_Gravity_State[sprite] = GRAVITY_GROUND_STATE Then
			hero_animation = 1 'run right animation
			hero_direction = 0
		End If
		If Sprite_Speed[sprite] < 3 then
			Sprite_Speed[sprite] = Sprite_Speed[sprite] + 0.1
			Sprite_Momentum[sprite] = Sprite_Speed[sprite] * 1.5
		End If
	End If
	
	'If Key(K_DOWN) Then
	If JHat[0] = HAT_DOWN  Then
		If Sprite_Gravity_State[sprite] = GRAVITY_GROUND_STATE And hero_direction = 0 Then 'If ground state and direction is right
			hero_animation = 3 'DUCK right animation
			Sprite_Speed[sprite] = 0
			Sprite_Momentum[sprite] = 0
		ElseIf Sprite_Gravity_State[sprite] = GRAVITY_GROUND_STATE Then
			hero_animation = 7
			Sprite_Speed[sprite] = 0
			Sprite_Momentum[sprite] = 0
		End If
	End If
	
	'If Key(K_b) And sp_pressed = 0 And Sprite_Gravity_State[sprite] = GRAVITY_GROUND_STATE Then
	If JButton[jump_button] And sp_pressed = 0 And Sprite_Gravity_State[sprite] = GRAVITY_GROUND_STATE Then
		jump(sprite)
		If hero_direction = 0 Then 'direction = RIGHT
			hero_animation = 2 'RIGHT JUMP animation
		Else
			hero_animation = 6 'Left Jump animation
		End If
		'print "m = " + momentum
		'print "s = " + speed
		PlaySound(jump_sound, 0, 0)
		sp_pressed = 1
	ElseIf Not (JButton[jump_button]) Then
		sp_pressed = 0
	ElseIf sp_pressed And Sprite_Jump_Height[sprite] < 120 Then
		Sprite_Jump_Height[sprite] = Sprite_Jump_Height[sprite] + 5
	ElseIf JButton[jump_button] Then
		sp_pressed = 1
	End If
			
	
	If (Not (JHat[0]=HAT_LEFT) ) And (Not (JHat[0]=HAT_RIGHT) ) And (Not (JHat[0]=HAT_DOWN)) Then 'not moving right or left
		Sprite_Speed[sprite] = 0
		If Sprite_Gravity_State[sprite] = GRAVITY_GROUND_STATE Then
			If hero_direction = 0 Then
				hero_animation = 0 'right stand animation
			Else
				hero_animation = 4 'left stand animation
			End If
			If sp_pressed = 0 Then
				Sprite_Momentum[sprite] = 0
			End If
		End If
	End If
	
	If Sprite_Gravity_State[sprite] = GRAVITY_GROUND_STATE Then
		If hero_animation = 2 Then 'if jump animation is playing
				hero_animation = 0 'stand animation
		End If
	ElseIf Sprite_Gravity_State[sprite] = GRAVITY_FALL_STATE Then
		If hero_direction = 0 Then 'if direction is RIGHT
			hero_animation = 2
		Else
			hero_animation = 6
		End If
	End If
	
	If (timer - hero_move_timer > hero_move_rate) then
		hero_move_timer = timer
	end if
	
	If hero_animation <> hero_current_animation Then
		Sprite_Play(sprite, hero_animation, -1)
	End If
	
end sub

sub control_keyboard(sprite, player)
	
	jump_button = 0
	
	Select Case player
	Case 0
		jump_button = PLAYER1_BUTTON_JUMP
	Case 1
		jump_button = PLAYER2_BUTTON_JUMP
	End Select
	
	hero_current_animation = Sprite_GetAnimation(sprite)
	hero_animation = hero_current_animation
	
	If Key(K_LEFT) And (timer - hero_move_timer > hero_move_rate) Then
		If Sprite_Gravity_State[sprite] = GRAVITY_GROUND_STATE Then
			hero_animation = 5 'run left animation
			hero_direction = 1 'LEFT DIRECTION
		End If
		If Sprite_Speed[sprite] > -3 then
			Sprite_Speed[sprite] = Sprite_Speed[sprite] - 0.1
			Sprite_Momentum[sprite] = Sprite_Speed[sprite] * 1.5
		End If
	End If
	
	If Key(K_RIGHT) And (timer - hero_move_timer > hero_move_rate) Then
		If Sprite_Gravity_State[sprite] = GRAVITY_GROUND_STATE Then
			hero_animation = 1 'run right animation
			hero_direction = 0
		End If
		If Sprite_Speed[sprite] < 3 then
			Sprite_Speed[sprite] = Sprite_Speed[sprite] + 0.1
			Sprite_Momentum[sprite] = Sprite_Speed[sprite] * 1.5
		End If
	End If
	
	If Key(K_DOWN)   Then
		If Sprite_Gravity_State[sprite] = GRAVITY_GROUND_STATE And hero_direction = 0 Then 'If ground state and direction is right
			hero_animation = 3 'DUCK right animation
			Sprite_Speed[sprite] = 0
			Sprite_Momentum[sprite] = 0
		ElseIf Sprite_Gravity_State[sprite] = GRAVITY_GROUND_STATE Then
			hero_animation = 7
			Sprite_Speed[sprite] = 0
			Sprite_Momentum[sprite] = 0
		End If
	End If
	
	If Key(jump_button) And sp_pressed = 0 And Sprite_Gravity_State[sprite] = GRAVITY_GROUND_STATE Then
		jump(sprite)
		If hero_direction = 0 Then 'direction = RIGHT
			hero_animation = 2 'RIGHT JUMP animation
		Else
			hero_animation = 6 'Left Jump animation
		End If
		PlaySound(jump_sound, 0, 0)
		'print "m = " + momentum
		'print "s = " + speed
		sp_pressed = 1
	ElseIf Not (key(jump_button)) Then
		sp_pressed = 0
	ElseIf sp_pressed And Sprite_Jump_Height[sprite] < 120 Then
		Sprite_Jump_Height[sprite] = Sprite_Jump_Height[sprite] + 6
	ElseIf key(jump_button) Then
		sp_pressed = 1
	End If
			
	
	If (Not (Key(K_LEFT)) ) And (Not (Key(K_RIGHT)) ) And (Not (Key(K_DOWN))) Then 'not moving right or left
		Sprite_Speed[sprite] = 0
		If Sprite_Gravity_State[sprite] = GRAVITY_GROUND_STATE Then
			If hero_direction = 0 Then
				hero_animation = 0 'right stand animation
			Else
				hero_animation = 4 'left stand animation
			End If
			If sp_pressed = 0 Then
				Sprite_Momentum[sprite] = 0
			End If
		End If
	End If
	
	If Sprite_Gravity_State[sprite] = GRAVITY_GROUND_STATE Then
		If hero_animation = 2 Then 'if jump animation is playing
				hero_animation = 0 'stand animation
		End If
	ElseIf Sprite_Gravity_State[sprite] = GRAVITY_FALL_STATE Then
		If hero_direction = 0 Then 'if direction is RIGHT
			hero_animation = 2
		Else
			hero_animation = 6
		End If
	End If
	
	If (timer - hero_move_timer > hero_move_rate) then
		hero_move_timer = timer
	end if
	
	If hero_animation <> hero_current_animation Then
		Sprite_Play(sprite, hero_animation, -1)
	End If
	
end sub

sub control(sprite, player)
	Select Case player
	Case 0
		If PLAYER1_CONTROLLER = CONTROLLER_JOYSTICK Then
			control_joystick(sprite, player)
		Else
			control_keyboard(sprite, player)
		End If
	Case 1
		If PLAYER2_CONTROLLER = CONTROLLER_JOYSTICK Then
			control_joystick(sprite, player)
		Else
			control_keyboard(sprite, player)
		End If
	End Select
end sub

'Engine_Init()
WindowOpen(0, "Test Engine", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480, 0)

Function home_stage1()

End Function

Function home_stage2(player)
	LoadMap("home_level2", 0, 0, 640, 480)

	bkg = LoadBkg("home_bkg1.png")
	Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 736)

	update_rate = 10
	hero_move_rate = 0.175
	
	level_end = false
	
	dim sprite
	
	goal = LoadSprite("casee")
	Sprite_Position(goal, 3104, 800)
	Sprite_RenderTopLayer(goal, true)
	Sprite_SetLayer(goal, 2)
	Sprite_Play(goal, 1, -1)
	
	Select Case Player_Character[player]
	Case 0
		sprite = LoadSprite("dk")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 8, 19, 18, 45)
		Sprite_Position(sprite, 160, 1024)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	Case 1
		sprite = LoadSprite("alana")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 7, 25, 17, 39)
		Sprite_Position(sprite, 160, 1024)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	End Select
		
	
	While (not level_end)
	If Key(K_ESCAPE) Then: End: End If
		'Sprite_CheckCollisions(2)
		control(sprite, player)
		World_Update(2, sprite)
		
		If Sprite_GetHit(sprite, goal) Then
			level_end = true
		ElseIf (Sprite_Pos[sprite,0] < 0 Or Sprite_Pos[sprite,0] > Map_Width_InPixels Or Sprite_Pos[sprite,1] > Map_Height_InPixels) Then
			PlaySound(death_sound, 0, 0)
			Wait(200)
			ClearSprite(sprite)
			ClearSprite(goal)
			ClearMap()
			Return 0
		End If
	
		Render()
	Wend
	
	dim dialog$[7]
	dialog$[0] = "CASEE: I can't believe I lost them again."
	dialog$[1] = "CASEE: It sucks being an adult."
	Select Case Player_Character[player]
	Case 0
		dialog$[2] = "DK: Don't worry moma."
		dialog$[3] = "DK: I will find them"
	Case 1
		dialog$[2] = "ALANA: BUUUUUUBBBBYYYY!!!"
		dialog$[3] = "ALANA: BUBBY!"
	End Select
	dialog_index = 0
	
	While true
		GetJoystick(0)
		msg(dialog[dialog_index])
		
		
		If JButton[0] Or Key(K_RETURN) Then
			dialog_index = dialog_index + 1
			If dialog_index > 3 Then
				Exit While
			End If
			wait(200)
		End If
		
		
		Render()
		
	Wend
	Canvas(8)
	ClearCanvas()
	wait(200)
	ClearSprite(goal)
	ClearSprite(sprite)
	Return 1
End Function


Function home_stage3(player)

	LoadMap("home_level3", 0, 0, 640, 480)

	bkg = LoadBkg("home_bkg1.png")
	Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 2000)

	update_rate = 10
	hero_move_rate = 2
	
	level_end = false
	
	dim sprite
	
	goal = LoadSprite("casee")
	Sprite_Position(goal, 352, 320)
	Sprite_RenderTopLayer(goal, true)
	Sprite_SetLayer(goal, 2)
	Sprite_Play(goal, 1, -1)
	
	Select Case Player_Character[player]
	Case 0
		sprite = LoadSprite("dk")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 8, 19, 18, 45)
		Sprite_Position(sprite, 64, 448)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	Case 1
		sprite = LoadSprite("alana")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 7, 25, 17, 39)
		Sprite_Position(sprite, 64, 448)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	End Select
	
	While Not level_end
	If Key(K_ESCAPE) Then: End: End If
		'Sprite_CheckCollisions(2)
		control(sprite, player)
		World_Update(2, sprite)
		
		If Sprite_GetHit(sprite, goal) Then
			level_end = true
		ElseIf (Sprite_Pos[sprite,0] < 0 Or Sprite_Pos[sprite,0] > Map_Width_InPixels Or Sprite_Pos[sprite,1] > Map_Height_InPixels) Then
			PlaySound(death_sound, 0, 0)
			Wait(200)
			ClearSprite(sprite)
			ClearSprite(goal)
			ClearMap()
			Return 0
		End If
	
		Render()
	Wend
	
	dim dialog$[7]
	dialog$[0] = "CASEE: I need to learn RESPOOONSIBLITY."
	dialog$[1] = "CASEE: Maybe someday."
	Select Case Player_Character[player]
	Case 0
		dialog$[2] = "DK: If I find the keys can I get a doggy?"
		dialog$[3] = "DK: PLEEEAASEE"
	Case 1
		dialog$[2] = "ALANA: BUBBY?"
		dialog$[3] = "ALANA: BUUUUBBYYYY!!!!"
	End Select
	dialog_index = 0
	
	While true
		GetJoystick(0)
		msg(dialog[dialog_index])
		
		
		If JButton[0] Or Key(K_RETURN) Then
			dialog_index = dialog_index + 1
			If dialog_index > 3 Then
				Exit While
			End If
			wait(200)
		End If
		
		
		Render()
		
	Wend
	Canvas(8)
	ClearCanvas()
	wait(200)
	ClearSprite(goal)
	ClearSprite(sprite)
	
	Return 1
End Function

Function home_stage4(player)

	LoadMap("home_level4", 0, 0, 640, 480)

	bkg = LoadBkg("home_bkg1.png")
	Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 0)

	update_rate = 10
	hero_move_rate = 2
	
	level_end = false
	
	dim sprite
	
	goal = LoadSprite("casee")
	Sprite_Position(goal, 608, 640)
	'Sprite_RenderTopLayer(goal, true)
	Sprite_SetLayer(goal, 3)
	Sprite_Play(goal, 0, -1)
	
	Select Case Player_Character[player]
	Case 0
		sprite = LoadSprite("dk")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 8, 19, 18, 45)
		Sprite_Position(sprite, 64, 16)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	Case 1
		sprite = LoadSprite("alana")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 7, 25, 17, 39)
		Sprite_Position(sprite, 64, 16)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	End Select
	
	While Not level_end
	If Key(K_ESCAPE) Then: End: End If
		'Sprite_CheckCollisions(2)
		control(sprite, player)
		World_Update(2, sprite)
		
		If Sprite_GetHit(sprite, goal) Then
			level_end = true
		ElseIf (Sprite_Pos[sprite,0] < 0 Or Sprite_Pos[sprite,0] > Map_Width_InPixels Or Sprite_Pos[sprite,1] > Map_Height_InPixels) Then
			PlaySound(death_sound, 0, 0)
			Wait(200)
			ClearSprite(sprite)
			ClearSprite(goal)
			ClearMap()
			Return 0
		End If
	
		Render()
	Wend
	
	dim dialog$[7]
	dialog$[0] = "CASEE: I guess we can't go to the park."
	dialog$[1] = "CASEE: Oh Well."
	Select Case Player_Character[player]
	Case 0
		dialog$[2] = "DK: NOOOOOOOOOOOOOO!!!!!"
		dialog$[3] = "DK: I got to find those keys"
	Case 1
		dialog$[2] = "ALANA: BUBBY!"
		dialog$[3] = "ALANA: ..."
	End Select
	dialog_index = 0
	
	While true
		GetJoystick(0)
		msg(dialog[dialog_index])
		
		
		If JButton[0] Or Key(K_RETURN) Then
			dialog_index = dialog_index + 1
			If dialog_index > 3 Then
				Exit While
			End If
			wait(200)
		End If
		
		
		Render()
		
	Wend
	Canvas(8)
	ClearCanvas()
	wait(200)
	
	ClearSprite(sprite)
	ClearSprite(goal)
	ClearMap()
	
	Return 1
End Function

Function home_stage5(player)

	LoadMap("home_level5", 0, 0, 640, 480)

	bkg = LoadBkg("home_bkg1.png")
	Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 0)

	update_rate = 10
	hero_move_rate = 2
	
	level_end = false
	
	dim sprite
	
	goal = LoadSprite("casee")
	Sprite_Position(goal, 96, 640)
	'Sprite_RenderTopLayer(goal, true)
	Sprite_SetLayer(goal, 3)
	Sprite_Play(goal, 0, -1)
	
	Select Case Player_Character[player]
	Case 0
		sprite = LoadSprite("dk")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 8, 19, 18, 45)
		Sprite_Position(sprite, 96, 256)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	Case 1
		sprite = LoadSprite("alana")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 7, 25, 17, 39)
		Sprite_Position(sprite, 96, 256)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	End Select
	
	While Not level_end
	If Key(K_ESCAPE) Then: End: End If
		'Sprite_CheckCollisions(2)
		control(sprite, player)
		World_Update(2, sprite)
		
		If Sprite_GetHit(sprite, goal) Then
			level_end = true
		ElseIf (Sprite_Pos[sprite,0] < 0 Or Sprite_Pos[sprite,0] > Map_Width_InPixels Or Sprite_Pos[sprite,1] > Map_Height_InPixels) Then
			PlaySound(death_sound, 0, 0)
			Wait(200)
			ClearSprite(sprite)
			ClearSprite(goal)
			ClearMap()
			Return 0
		End If
	
		Render()
	Wend
	
	dim dialog$[7]
	dialog$[0] = "CASEE: I think I left the keys in the next Level?"
	Select Case Player_Character[player]
	Case 0
		dialog$[1] = "DK: Oh yeah, I am going to the park!!"
		dialog$[2] = "DK:  "
	Case 1
		dialog$[1] = "ALANA: BUBBY!"
		dialog$[2] = "ALANA: "
	End Select
	dialog_index = 0
	
	While true
		GetJoystick(0)
		msg(dialog[dialog_index])
		
		
		If JButton[0] Or Key(K_RETURN) Then
			dialog_index = dialog_index + 1
			If dialog_index > 1 Then
				Exit While
			End If
			wait(200)
		End If
		
		
		Render()
		
	Wend
	Canvas(8)
	ClearCanvas()
	wait(200)
	
	ClearSprite(sprite)
	ClearSprite(goal)
	ClearMap()
	
	Return 1
End Function


Function home_stage7(player)

	LoadMap("home_level7", 0, 0, 640, 480)

	bkg = LoadBkg("home_bkg1.png")
	Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 0)

	update_rate = 10
	hero_move_rate = 2
	
	level_end = false
	
	dim sprite
	
	goal = LoadSprite("key")
	Sprite_Position(goal, 544, 544)
	'Sprite_RenderTopLayer(goal, true)
	Sprite_SetLayer(goal, 3)
	Sprite_Play(goal, 0, -1)
	
	Select Case Player_Character[player]
	Case 0
		sprite = LoadSprite("dk")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 8, 19, 18, 45)
		Sprite_Position(sprite, 96, 224)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	Case 1
		sprite = LoadSprite("alana")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 7, 25, 17, 39)
		Sprite_Position(sprite, 96, 224)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	End Select
	
	While Not level_end
	If Key(K_ESCAPE) Then: End: End If
		'Sprite_CheckCollisions(2)
		control(sprite, player)
		World_Update(2, sprite)
		
		If Sprite_GetHit(sprite, goal) Then
			level_end = true
		ElseIf (Sprite_Pos[sprite,0] < 0 Or Sprite_Pos[sprite,0] > Map_Width_InPixels Or Sprite_Pos[sprite,1] > Map_Height_InPixels) Then
			PlaySound(death_sound, 0, 0)
			Wait(200)
			ClearSprite(sprite)
			ClearSprite(goal)
			ClearMap()
			Return 0
		End If
	
		Render()
	Wend
	
	
	ClearSprite(sprite)
	ClearSprite(goal)
	ClearMap()
	
	Return 1
End Function


Function Home_World(n_players, p1_char, p2_char)
	LoadMusic(music_dir$ + "Worldmap Theme.mp3")
	SetMusicVolume(128)
	PlayMusic(-1)
	
	
	current_player = 0
	
	while not home_stage2(current_player)
		if n_players = 2 then
			current_player = not current_player
		end if
	wend
	
	while not home_stage3(current_player)
		if n_players = 2 then
			current_player = not current_player
		end if
	wend
	
	while not home_stage4(current_player)
		if n_players = 2 then
			current_player = not current_player
		end if
	wend
	
	while not home_stage5(current_player)
		if n_players = 2 then
			current_player = not current_player
		end if
	wend
	
	while not home_stage7(current_player)
		if n_players = 2 then
			current_player = not current_player
		end if
	wend
	
	DeleteMusic()
End Function

Function Open_Scene()
	LoadMap("home", 0, 0, 640, 480)

	'bkg = LoadBkg("home_bkg1.png")
	'Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 0)

	dk = LoadSprite("dk")
	Sprite_SetHitBox(dk, HITBOX_RECT, 8, 19, 18, 45)
	Sprite_Position(dk, 384, 256)
	Sprite_Pos[dk, 1] = 288
	'Sprite_Position(dk, 64, 448)
	Sprite_RenderTopLayer(dk, true)
	Sprite_SetLayer(dk, 2)
	Sprite_Play(dk, 04, -1)
	
	alana = LoadSprite("alana")
	Sprite_SetHitBox(alana, HITBOX_RECT, 8, 19, 18, 45)
	Sprite_Position(alana, 416, 256)
	Sprite_Pos[alana, 1] = 288
	'Sprite_Position(dk, 64, 448)
	Sprite_RenderTopLayer(alana, true)
	Sprite_SetLayer(alana, 2)
	Sprite_Play(alana, 4, -1)
	
	casee = LoadSprite("casee")
	Sprite_SetHitBox(casee, HITBOX_RECT, 8, 19, 18, 45)
	'Sprite_Position(casee, 320, 256)
	Sprite_Pos[casee, 0] = 320
	Sprite_Pos[casee, 1] = 288
	'Sprite_Position(dk, 64, 448)
	Sprite_RenderTopLayer(casee, true)
	Sprite_SetLayer(casee, 2)
	Sprite_Play(casee, 0, -1)
	
	dim dialog$[7]
	dialog$[0] = "CASEE: I can't find my keys."
	dialog$[1] = "CASEE: We can't go to the park until I find them."
	dialog$[2] = "DOMINIQUE: We got to find Momma's keys."
	dialog$[3] = "ALANA: BUBBY!!!!"
	dialog$[4] = "..."
	dialog$[5] = "..."
	dialog_index = 0
	
	While true
		GetJoystick(0)
		msg(dialog[dialog_index])
		
		
		If JButton[0] Or key(K_RETURN) Then
			dialog_index = dialog_index + 1
			If dialog_index > 3 Then
				Wait(200)
				Exit While
			End If
			wait(200)
		End If
		
		
		Render()
		
	Wend
	Canvas(8)
	ClearCanvas()
	ClearSprite(dk)
	ClearSprite(casee)
	ClearSprite(alana)
	ClearMap()
	wait(200)
End Function

function OverWorld1()
	LoadMap("overworld", 0, 0, 640, 480)

	bkg = LoadBkg("Level_Select3.png")
	Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 0)

	dk = LoadSprite("dk")
	Sprite_SetHitBox(dk, HITBOX_RECT, 8, 19, 18, 45)
	Sprite_Position(dk, 128, 64)
	'Sprite_Position(dk, 64, 448)
	Sprite_RenderTopLayer(dk, true)
	Sprite_SetLayer(dk, 3)
	Sprite_Play(dk, 1, -1)
	
	alana = LoadSprite("alana")
	Sprite_SetHitBox(alana, HITBOX_RECT, 8, 19, 18, 45)
	Sprite_Position(alana, 96, 64)
	'Sprite_Position(dk, 64, 448)
	Sprite_RenderTopLayer(alana, true)
	Sprite_SetLayer(alana, 3)
	Sprite_Play(alana, 1, -1)
	
	For y = 0 to 160
		Sprite_Move(dk,0,1)
		Sprite_Move(alana,0,1)
		Render()
		wait(30)
	Next
	
	ClearSprite(dk)
	ClearSprite(alana)
	ClearMap()
	wait(200)
end function

function OverWorld2()
	LoadMap("overworld", 0, 0, 640, 480)

	bkg = LoadBkg("Level_Select3.png")
	Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 0)

	dk = LoadSprite("dk")
	Sprite_SetHitBox(dk, HITBOX_RECT, 8, 19, 18, 45)
	Sprite_Position(dk, 128, 200)
	'Sprite_Position(dk, 64, 448)
	Sprite_RenderTopLayer(dk, true)
	Sprite_SetLayer(dk, 3)
	Sprite_Play(dk, 1, -1)
	
	alana = LoadSprite("alana")
	Sprite_SetHitBox(alana, HITBOX_RECT, 8, 19, 18, 45)
	Sprite_Position(alana, 96, 200)
	'Sprite_Position(dk, 64, 448)
	Sprite_RenderTopLayer(alana, true)
	Sprite_SetLayer(alana, 3)
	Sprite_Play(alana, 1, -1)
	
	For x = 96 to 416
		Sprite_Move(dk,1,0)
		Sprite_Move(alana,1,0)
		Render()
		wait(20)
	Next
	
	ClearSprite(dk)
	ClearSprite(alana)
	ClearMap()
	wait(200)
end function

function OverWorld3()
	LoadMap("overworld", 0, 0, 640, 480)

	bkg = LoadBkg("Level_Select3.png")
	Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 0)

	dk = LoadSprite("dk")
	Sprite_SetHitBox(dk, HITBOX_RECT, 8, 19, 18, 45)
	Sprite_Position(dk, 450, 240)
	'Sprite_Position(dk, 64, 448)
	Sprite_RenderTopLayer(dk, true)
	Sprite_SetLayer(dk, 3)
	Sprite_Play(dk, 1, -1)
	
	alana = LoadSprite("alana")
	Sprite_SetHitBox(alana, HITBOX_RECT, 8, 19, 18, 45)
	Sprite_Position(alana, 410, 240)
	'Sprite_Position(dk, 64, 448)
	Sprite_RenderTopLayer(alana, true)
	Sprite_SetLayer(alana, 3)
	Sprite_Play(alana, 1, -1)
	
	For x = 240 to 420
		Sprite_Move(dk,0,1)
		Sprite_Move(alana,0,1)
		Render()
		wait(20)
	Next
	
	ClearSprite(dk)
	ClearSprite(alana)
	ClearMap()
	wait(200)
end function

Function park_stage1(player)

	LoadMap("level1", 0, 0, 640, 480)

	bkg = LoadBkg("bkg1.png")
	Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 1276)

	update_rate = 10
	hero_move_rate = 2
	
	level_end = false
	
	dim sprite
	
	goal = LoadSprite("tiera")
	Sprite_Position(goal, 192, 704)
	'Sprite_RenderTopLayer(goal, true)
	Sprite_SetLayer(goal, 3)
	Sprite_Play(goal, 0, -1)
	
	Select Case Player_Character[player]
	Case 0
		sprite = LoadSprite("dk")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 8, 19, 18, 45)
		Sprite_Position(sprite, 224, 1376)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	Case 1
		sprite = LoadSprite("alana")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 7, 25, 17, 39)
		Sprite_Position(sprite, 224, 1376)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	End Select
	
	While Not level_end
	If Key(K_ESCAPE) Then: End: End If
		'Sprite_CheckCollisions(2)
		control(sprite, player)
		World_Update(2, sprite)
		
		If Sprite_GetHit(sprite, goal) Then
			level_end = true
		ElseIf (Sprite_Pos[sprite,0] < 0 Or Sprite_Pos[sprite,0] > Map_Width_InPixels Or Sprite_Pos[sprite,1] > Map_Height_InPixels) Then
			PlaySound(death_sound, 0, 0)
			Wait(200)
			ClearSprite(sprite)
			ClearSprite(goal)
			ClearMap()
			Return 0
		End If
	
		Render()
	Wend
	
	
	ClearSprite(sprite)
	ClearSprite(goal)
	ClearMap()
	
	Return 1
End Function

Function park_stage2(player)

	LoadMap("park2", 0, 0, 640, 480)

	bkg = LoadBkg("bkg1.png")
	Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 188)

	update_rate = 10
	hero_move_rate = 2
	
	level_end = false
	
	dim sprite
	
	goal = LoadSprite("park2")
	Sprite_Position(goal, 1184, 608)
	'Sprite_RenderTopLayer(goal, true)
	Sprite_SetLayer(goal, 3)
	Sprite_Play(goal, 0, -1)
	
	Select Case Player_Character[player]
	Case 0
		sprite = LoadSprite("dk")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 8, 19, 18, 45)
		Sprite_Position(sprite, 160, 288)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	Case 1
		sprite = LoadSprite("alana")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 7, 25, 17, 39)
		Sprite_Position(sprite, 160, 288)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	End Select
	
	While Not level_end
	If Key(K_ESCAPE) Then: End: End If
		'Sprite_CheckCollisions(2)
		control(sprite, player)
		World_Update(2, sprite)
		
		If Sprite_GetHit(sprite, goal) Then
			level_end = true
		ElseIf (Sprite_Pos[sprite,0] < 0 Or Sprite_Pos[sprite,0] > Map_Width_InPixels Or Sprite_Pos[sprite,1] > Map_Height_InPixels) Then
			PlaySound(death_sound, 0, 0)
			Wait(200)
			ClearSprite(sprite)
			ClearSprite(goal)
			ClearMap()
			Return 0
		End If
	
		Render()
	Wend
	
	
	ClearSprite(sprite)
	ClearSprite(goal)
	ClearMap()
	
	Return 1
End Function

Function park_stage4(player)

	LoadMap("park4", 0, 0, 640, 480)

	bkg = LoadBkg("bkg1.png")
	Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 156)

	update_rate = 10
	hero_move_rate = 2
	
	level_end = false
	
	dim sprite
	
	goal = LoadSprite("tiera")
	Sprite_Position(goal, 1248, 736)
	'Sprite_RenderTopLayer(goal, true)
	Sprite_SetLayer(goal, 3)
	Sprite_Play(goal, 0, -1)
	
	Select Case Player_Character[player]
	Case 0
		sprite = LoadSprite("dk")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 8, 19, 18, 45)
		Sprite_Position(sprite, 288, 256)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	Case 1
		sprite = LoadSprite("alana")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 7, 25, 17, 39)
		Sprite_Position(sprite, 288, 256)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	End Select
	
	While Not level_end
	If Key(K_ESCAPE) Then: End: End If
		'Sprite_CheckCollisions(2)
		control(sprite, player)
		World_Update(2, sprite)
		
		If Sprite_GetHit(sprite, goal) Then
			level_end = true
		ElseIf (Sprite_Pos[sprite,0] < 0 Or Sprite_Pos[sprite,0] > Map_Width_InPixels Or Sprite_Pos[sprite,1] > Map_Height_InPixels) Then
			PlaySound(death_sound, 0, 0)
			Wait(200)
			ClearSprite(sprite)
			ClearSprite(goal)
			ClearMap()
			Return 0
		End If
	
		Render()
	Wend
	
	
	dim dialog$[7]
	dialog$[0] = "TIERA: The Pastor sure preached last sunday."
	dialog$[1] = "TIERA: Jesus take the wheel."
	dialog$[2] = "DOMINIQUE: Bye TT, we are going to the pool."
	dialog$[3] = "TIERA: AMEN!!!"
	dialog$[4] = "..."
	dialog$[5] = "..."
	dialog_index = 0
	
	While true
		GetJoystick(0)
		msg(dialog[dialog_index])
		
		
		If JButton[0] Or key(K_RETURN) Then
			dialog_index = dialog_index + 1
			If dialog_index > 3 Then
				Wait(200)
				Exit While
			End If
			wait(200)
		End If
		
		
		Render()
		
	Wend
	Canvas(8)
	ClearCanvas()
	ClearSprite(sprite)
	ClearSprite(goal)
	ClearMap()
	wait(200)
	
	Return 1
End Function

Function Park_Scene()
	LoadMap("park_main", 0, 0, 640, 480)

	bkg = LoadBkg("bkg1.png")
	Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 188)

	dk = LoadSprite("dk")
	Sprite_SetHitBox(dk, HITBOX_RECT, 8, 19, 18, 45)
	Sprite_Position(dk, 288, 288)
	'Sprite_Position(dk, 64, 448)
	Sprite_RenderTopLayer(dk, true)
	Sprite_SetLayer(dk, 2)
	Sprite_Play(dk, 4, -1)
	
	alana = LoadSprite("alana")
	Sprite_SetHitBox(alana, HITBOX_RECT, 8, 19, 18, 45)
	Sprite_Position(alana, 352, 288)
	'Sprite_Position(dk, 64, 448)
	Sprite_RenderTopLayer(alana, true)
	Sprite_SetLayer(alana, 2)
	Sprite_Play(alana, 4, -1)
	
	casee = LoadSprite("tiera")
	Sprite_SetHitBox(casee, HITBOX_RECT, 8, 19, 18, 45)
	Sprite_Position(casee, 160, 288)
	'Sprite_Position(dk, 64, 448)
	Sprite_RenderTopLayer(casee, true)
	Sprite_SetLayer(casee, 2)
	Sprite_Play(casee, 0, -1)
	
	dim dialog$[7]
	dialog$[0] = "TIERA: While we are at the park, lets not forget about church."
	dialog$[1] = "TIERA: Sunday is always around the corner."
	dialog$[2] = "DOMINIQUE: I just wanna play."
	dialog$[3] = "ALANA: BUBBY!!!!"
	dialog$[4] = "..."
	dialog$[5] = "..."
	dialog_index = 0
	
	Sprite_Pos[casee, 1] = 320
	Sprite_Pos[dk, 1] = 320
	Sprite_Pos[alana, 1] = 320
	
	While true
		GetJoystick(0)
		msg(dialog[dialog_index])
		
		
		If JButton[0] Or key(K_RETURN) Then
			dialog_index = dialog_index + 1
			If dialog_index > 3 Then
				Wait(200)
				Exit While
			End If
			wait(200)
		End If
		
		
		Render()
		
	Wend
	Canvas(8)
	ClearCanvas()
	ClearSprite(dk)
	ClearSprite(casee)
	ClearSprite(alana)
	ClearMap()
	wait(200)
End Function


function Park_World(n_players, p1_char, p2_char)
	LoadMusic(music_dir$ + "GrasslandsTheme.mp3")
	SetMusicVolume(128)
	PlayMusic(-1)
	
	current_player = 0
	
	while not park_stage1(current_player)
		if n_players = 2 then
			current_player = not current_player
		end if
	wend
	
	'while not park_stage2(current_player)
	'	if n_players = 2 then
	'		current_player = not current_player
	'	end if
	'wend
	
	while not park_stage4(current_player)
		if n_players = 2 then
			current_player = not current_player
		end if
	wend
	
	DeleteMusic()
end function

Function swim_stage1(player)

	LoadMap("swim1", 0, 0, 640, 480)

	bkg = LoadBkg("bkg1.png")
	Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 412)

	update_rate = 10
	hero_move_rate = 2
	
	level_end = false
	
	dim sprite
	
	goal = LoadSprite("tdog")
	Sprite_Position(goal, 1504, 512)
	'Sprite_RenderTopLayer(goal, true)
	Sprite_SetLayer(goal, 3)
	Sprite_Play(goal, 0, -1)
	
	Select Case Player_Character[player]
	Case 0
		sprite = LoadSprite("dk")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 8, 19, 18, 45)
		Sprite_Position(sprite, 96, 512)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	Case 1
		sprite = LoadSprite("alana")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 7, 25, 17, 39)
		Sprite_Position(sprite, 96, 512)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	End Select
	
	While Not level_end
	If Key(K_ESCAPE) Then: End: End If
		'Sprite_CheckCollisions(2)
		control(sprite, player)
		World_Update(2, sprite)
		
		If Sprite_GetHit(sprite, goal) Then
			level_end = true
		ElseIf (Sprite_Pos[sprite,0] < 0 Or Sprite_Pos[sprite,0] > Map_Width_InPixels Or Sprite_Pos[sprite,1] > Map_Height_InPixels) Then
			PlaySound(death_sound, 0, 0)
			Wait(200)
			ClearSprite(sprite)
			ClearSprite(goal)
			ClearMap()
			Return 0
		End If
	
		Render()
	Wend
	
	
	ClearSprite(sprite)
	ClearSprite(goal)
	ClearMap()
	
	Return 1
End Function

Function swim_stage2(player)

	LoadMap("swim2", 0, 0, 640, 480)

	bkg = LoadBkg("bkg1.png")
	Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 60)

	update_rate = 10
	hero_move_rate = 2
	
	level_end = false
	
	dim sprite
	
	goal = LoadSprite("tdog")
	Sprite_Position(goal, 1856, 352)
	'Sprite_RenderTopLayer(goal, true)
	Sprite_SetLayer(goal, 3)
	Sprite_Play(goal, 0, -1)
	
	Select Case Player_Character[player]
	Case 0
		sprite = LoadSprite("dk")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 8, 19, 18, 45)
		Sprite_Position(sprite, 64, 160)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	Case 1
		sprite = LoadSprite("alana")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 7, 25, 17, 39)
		Sprite_Position(sprite, 64, 160)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	End Select
	
	While Not level_end
	If Key(K_ESCAPE) Then: End: End If
		'Sprite_CheckCollisions(2)
		control(sprite, player)
		World_Update(2, sprite)
		
		If Sprite_GetHit(sprite, goal) Then
			level_end = true
		ElseIf (Sprite_Pos[sprite,0] < 0 Or Sprite_Pos[sprite,0] > Map_Width_InPixels Or Sprite_Pos[sprite,1] > Map_Height_InPixels) Then
			PlaySound(death_sound, 0, 0)
			Wait(200)
			ClearSprite(sprite)
			ClearSprite(goal)
			ClearMap()
			Return 0
		End If
	
		Render()
	Wend
	
	
	ClearSprite(sprite)
	ClearSprite(goal)
	ClearMap()
	
	Return 1
End Function

Function swim_stage3(player)

	LoadMap("swim3", 0, 0, 640, 480)

	bkg = LoadBkg("bkg1.png")
	Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 1148)

	update_rate = 10
	hero_move_rate = 2
	
	level_end = false
	
	dim sprite
	
	goal = LoadSprite("tdog")
	Sprite_Position(goal, 96, 928)
	'Sprite_RenderTopLayer(goal, true)
	Sprite_SetLayer(goal, 3)
	Sprite_Play(goal, 0, -1)
	Sprite_Pos[goal, 1] = 960
	
	Select Case Player_Character[player]
	Case 0
		sprite = LoadSprite("dk")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 8, 19, 18, 45)
		Sprite_Position(sprite, 96, 1248)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	Case 1
		sprite = LoadSprite("alana")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 7, 25, 17, 39)
		Sprite_Position(sprite, 96, 1248)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	End Select
	
	While Not level_end
	If Key(K_ESCAPE) Then: End: End If
		'Sprite_CheckCollisions(2)
		control(sprite, player)
		World_Update(2, sprite)
		
		If Sprite_GetHit(sprite, goal) Then
			level_end = true
		ElseIf (Sprite_Pos[sprite,0] < 0 Or Sprite_Pos[sprite,0] > Map_Width_InPixels Or Sprite_Pos[sprite,1] > Map_Height_InPixels) Then
			PlaySound(death_sound, 0, 0)
			Wait(200)
			ClearSprite(sprite)
			ClearSprite(goal)
			ClearMap()
			Return 0
		End If
	
		Render()
	Wend
	
	
	ClearSprite(sprite)
	ClearSprite(goal)
	ClearMap()
	
	Return 1
End Function

Function swim_stage4(player)

	LoadMap("swim4", 0, 0, 640, 480)

	bkg = LoadBkg("bkg1.png")
	Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 124)

	update_rate = 10
	hero_move_rate = 2
	
	level_end = false
	
	dim sprite
	
	goal = LoadSprite("tdog")
	Sprite_Position(goal, 1024, 256)
	'Sprite_RenderTopLayer(goal, true)
	Sprite_SetLayer(goal, 3)
	Sprite_Play(goal, 0, -1)
	
	Select Case Player_Character[player]
	Case 0
		sprite = LoadSprite("dk")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 8, 19, 18, 45)
		Sprite_Position(sprite, 64, 224)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	Case 1
		sprite = LoadSprite("alana")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 7, 25, 17, 39)
		Sprite_Position(sprite, 64, 224)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	End Select
	
	While Not level_end
	If Key(K_ESCAPE) Then: End: End If
		'Sprite_CheckCollisions(2)
		control(sprite, player)
		World_Update(2, sprite)
		
		If Sprite_GetHit(sprite, goal) Then
			level_end = true
		ElseIf (Sprite_Pos[sprite,0] < 0 Or Sprite_Pos[sprite,0] > Map_Width_InPixels Or Sprite_Pos[sprite,1] > Map_Height_InPixels) Then
			PlaySound(death_sound, 0, 0)
			Wait(200)
			ClearSprite(sprite)
			ClearSprite(goal)
			ClearMap()
			Return 0
		End If
	
		Render()
	Wend
	
	
	ClearSprite(sprite)
	ClearSprite(goal)
	ClearMap()
	
	Return 1
End Function

Function Swim_Scene()
	LoadMap("swim_main", 0, 0, 640, 480)

	bkg = LoadBkg("bkg1.png")
	Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 188)

	dk = LoadSprite("dk")
	Sprite_SetHitBox(dk, HITBOX_RECT, 8, 19, 18, 45)
	Sprite_Position(dk, 288, 256)
	'Sprite_Position(dk, 64, 448)
	Sprite_RenderTopLayer(dk, true)
	Sprite_SetLayer(dk, 2)
	Sprite_Play(dk, 4, -1)
	
	alana = LoadSprite("alana")
	Sprite_SetHitBox(alana, HITBOX_RECT, 8, 19, 18, 45)
	Sprite_Position(alana, 352, 256)
	'Sprite_Position(dk, 64, 448)
	Sprite_RenderTopLayer(alana, true)
	Sprite_SetLayer(alana, 2)
	Sprite_Play(alana, 4, -1)
	
	casee = LoadSprite("tdog")
	Sprite_SetHitBox(casee, HITBOX_RECT, 8, 19, 18, 45)
	Sprite_Position(casee, 160, 256)
	'Sprite_Position(dk, 64, 448)
	Sprite_RenderTopLayer(casee, true)
	Sprite_SetLayer(casee, 2)
	Sprite_Play(casee, 0, -1)
	
	Sprite_Pos[casee, 1] = 288
	Sprite_Pos[dk, 1] = 288
	Sprite_Pos[alana, 1] = 288
	
	dim dialog$[7]
	dialog$[0] = "TDOG: Be careful swimming."
	dialog$[1] = "TDOG: ...."
	dialog$[2] = "DOMINIQUE: I just wanna swim."
	dialog$[3] = "ALANA: BUBBY!!!!"
	dialog$[4] = "..."
	dialog$[5] = "..."
	dialog_index = 0
	
	While true
		GetJoystick(0)
		msg(dialog[dialog_index])
		
		
		If JButton[0] Or key(K_RETURN) Then
			dialog_index = dialog_index + 1
			If dialog_index > 3 Then
				Wait(200)
				Exit While
			End If
			wait(200)
		End If
		
		
		Render()
		
	Wend
	Canvas(8)
	ClearCanvas()
	ClearSprite(dk)
	ClearSprite(casee)
	ClearSprite(alana)
	ClearMap()
	wait(200)
End Function


function Swim_World(n_players, p1_char, p2_char)
	LoadMusic(music_dir$ + "IcelandTheme.mp3")
	SetMusicVolume(128)
	PlayMusic(-1)
	
	current_player = 0
	
	while not swim_stage1(current_player)
		if n_players = 2 then
			current_player = not current_player
		end if
	wend
	
	while not swim_stage2(current_player)
		if n_players = 2 then
			current_player = not current_player
		end if
	wend
	
	while not swim_stage3(current_player)
		if n_players = 2 then
			current_player = not current_player
		end if
	wend
	
	while not swim_stage4(current_player)
		if n_players = 2 then
			current_player = not current_player
		end if
	wend
	
	DeleteMusic()
end function


Function space_stage1(player)

	LoadMap("space1", 0, 0, 640, 480)

	bkg = LoadBkg("space.png")
	Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 124)

	update_rate = 10
	hero_move_rate = 2
	
	level_end = false
	
	dim sprite
	
	goal = LoadSprite("travis")
	Sprite_Position(goal, 1184, 224)
	'Sprite_RenderTopLayer(goal, true)
	Sprite_SetLayer(goal, 3)
	Sprite_Play(goal, 0, -1)
	
	Select Case Player_Character[player]
	Case 0
		sprite = LoadSprite("dk")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 8, 19, 18, 45)
		Sprite_Position(sprite, 160, 224)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	Case 1
		sprite = LoadSprite("alana")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 7, 25, 17, 39)
		Sprite_Position(sprite, 160, 224)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	End Select
	
	While Not level_end
	If Key(K_ESCAPE) Then: End: End If
		'Sprite_CheckCollisions(2)
		control(sprite, player)
		World_Update(2, sprite)
		
		If Sprite_GetHit(sprite, goal) Then
			level_end = true
		ElseIf (Sprite_Pos[sprite,0] < 0 Or Sprite_Pos[sprite,0] > Map_Width_InPixels Or Sprite_Pos[sprite,1] > Map_Height_InPixels) Then
			PlaySound(death_sound, 0, 0)
			Wait(200)
			ClearSprite(sprite)
			ClearSprite(goal)
			ClearMap()
			Return 0
		End If
	
		Render()
	Wend
	
	
	ClearSprite(sprite)
	ClearSprite(goal)
	ClearMap()
	
	Return 1
End Function

Function space_stage2(player)

	LoadMap("space2", 0, 0, 640, 480)

	bkg = LoadBkg("space.png")
	Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 124)

	update_rate = 10
	hero_move_rate = 2
	
	level_end = false
	
	dim sprite
	
	goal = LoadSprite("travis")
	Sprite_Position(goal, 1728, 480)
	'Sprite_RenderTopLayer(goal, true)
	Sprite_SetLayer(goal, 3)
	Sprite_Play(goal, 0, -1)
	
	Select Case Player_Character[player]
	Case 0
		sprite = LoadSprite("dk")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 8, 19, 18, 45)
		Sprite_Position(sprite, 192, 224)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	Case 1
		sprite = LoadSprite("alana")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 7, 25, 17, 39)
		Sprite_Position(sprite, 192, 224)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	End Select
	
	While Not level_end
	If Key(K_ESCAPE) Then: End: End If
		'Sprite_CheckCollisions(2)
		control(sprite, player)
		World_Update(2, sprite)
		
		If Sprite_GetHit(sprite, goal) Then
			level_end = true
		ElseIf (Sprite_Pos[sprite,0] < 0 Or Sprite_Pos[sprite,0] > Map_Width_InPixels Or Sprite_Pos[sprite,1] > Map_Height_InPixels) Then
			PlaySound(death_sound, 0, 0)
			Wait(200)
			ClearSprite(sprite)
			ClearSprite(goal)
			ClearMap()
			Return 0
		End If
	
		Render()
	Wend
	
	
	ClearSprite(sprite)
	ClearSprite(goal)
	ClearMap()
	
	Return 1
End Function

Function space_stage3(player)

	LoadMap("space3", 0, 0, 640, 480)

	bkg = LoadBkg("space.png")
	Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 220)

	update_rate = 10
	hero_move_rate = 2
	
	level_end = false
	
	dim sprite
	
	goal = LoadSprite("travis")
	Sprite_Position(goal, 736, 416)
	'Sprite_RenderTopLayer(goal, true)
	Sprite_SetLayer(goal, 3)
	Sprite_Play(goal, 0, -1)
	
	Select Case Player_Character[player]
	Case 0
		sprite = LoadSprite("dk")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 8, 19, 18, 45)
		Sprite_Position(sprite, 256, 320)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	Case 1
		sprite = LoadSprite("alana")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 7, 25, 17, 39)
		Sprite_Position(sprite, 256, 320)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	End Select
	
	While Not level_end
	If Key(K_ESCAPE) Then: End: End If
		'Sprite_CheckCollisions(2)
		control(sprite, player)
		World_Update(2, sprite)
		
		If Sprite_GetHit(sprite, goal) Then
			level_end = true
		ElseIf (Sprite_Pos[sprite,0] < 0 Or Sprite_Pos[sprite,0] > Map_Width_InPixels Or Sprite_Pos[sprite,1] > Map_Height_InPixels) Then
			PlaySound(death_sound, 0, 0)
			Wait(200)
			ClearSprite(sprite)
			ClearSprite(goal)
			ClearMap()
			Return 0
		End If
	
		Render()
	Wend
	
	
	ClearSprite(sprite)
	ClearSprite(goal)
	ClearMap()
	
	Return 1
End Function

Function Space_Scene()
	LoadMap("space_main", 0, 0, 640, 480)

	bkg = LoadBkg("space.png")
	Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 188)

	dk = LoadSprite("dk")
	Sprite_SetHitBox(dk, HITBOX_RECT, 8, 19, 18, 45)
	Sprite_Position(dk, 320, 224)
	'Sprite_Position(dk, 64, 448)
	Sprite_RenderTopLayer(dk, true)
	Sprite_SetLayer(dk, 2)
	Sprite_Play(dk, 4, -1)
	
	alana = LoadSprite("alana")
	Sprite_SetHitBox(alana, HITBOX_RECT, 8, 19, 18, 45)
	Sprite_Position(alana, 384, 224)
	'Sprite_Position(dk, 64, 448)
	Sprite_RenderTopLayer(alana, true)
	Sprite_SetLayer(alana, 2)
	Sprite_Play(alana, 4, -1)
	
	casee = LoadSprite("travis")
	Sprite_SetHitBox(casee, HITBOX_RECT, 8, 19, 18, 45)
	Sprite_Position(casee, 192, 224)
	'Sprite_Position(dk, 64, 448)
	Sprite_RenderTopLayer(casee, true)
	Sprite_SetLayer(casee, 2)
	Sprite_Play(casee, 0, -1)
	
	Sprite_Pos[casee, 1] = 256
	Sprite_Pos[dk, 1] = 256
	Sprite_Pos[alana, 1] = 256
	
	dim dialog$[7]
	dialog$[0] = "TRAVIS: Behave yourself in space or I wont let you come back."
	dialog$[1] = "TRAVIS: A few more levels and its over."
	dialog$[2] = "DOMINIQUE: Is the moon made of cheese?"
	dialog$[3] = "ALANA: BUBBY!!!!"
	dialog$[4] = "..."
	dialog$[5] = "..."
	dialog_index = 0
	
	While true
		GetJoystick(0)
		msg(dialog[dialog_index])
		
		
		If JButton[0] Or key(K_RETURN) Then
			dialog_index = dialog_index + 1
			If dialog_index > 3 Then
				Wait(200)
				Exit While
			End If
			wait(200)
		End If
		
		
		Render()
		
	Wend
	Canvas(8)
	ClearCanvas()
	ClearSprite(dk)
	ClearSprite(casee)
	ClearSprite(alana)
	ClearMap()
	wait(200)
End Function


function Space_World(n_players, p1_char, p2_char)
	LoadMusic(music_dir$ + "BossTheme.mp3")
	SetMusicVolume(128)
	PlayMusic(-1)
	
	current_player = 0
	
	while not space_stage1(current_player)
		if n_players = 2 then
			current_player = not current_player
		end if
	wend
	
	while not space_stage2(current_player)
		if n_players = 2 then
			current_player = not current_player
		end if
	wend
	
	while not space_stage3(current_player)
		if n_players = 2 then
			current_player = not current_player
		end if
	wend
	
	
	DeleteMusic()
end function

Function bonus_stage1(player)

	LoadMap("hard_level1", 0, 0, 640, 480)

	bkg = LoadBkg("bonus.png")
	Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 0)

	update_rate = 10
	hero_move_rate = 2
	
	level_end = false
	
	dim sprite
	
	goal1 = LoadSprite("travis")
	goal2 = LoadSprite("casee")
	goal3 = LoadSprite("me")
	
	Sprite_Position(goal1, 1376, 223)
	'Sprite_RenderTopLayer(goal, true)
	Sprite_SetLayer(goal1, 3)
	Sprite_Play(goal1, 1, -1)
	
	Sprite_Position(goal2, 64, 1087)
	'Sprite_RenderTopLayer(goal, true)
	Sprite_SetLayer(goal2, 3)
	Sprite_Play(goal2, 1, -1)
	
	Sprite_Position(goal3, 1600, 1023)
	'Sprite_RenderTopLayer(goal, true)
	Sprite_SetLayer(goal3, 3)
	Sprite_Play(goal3, 1, -1)
	
	Select Case Player_Character[player]
	Case 0
		sprite = LoadSprite("dk")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 8, 19, 18, 45)
		Sprite_Position(sprite, 128, 160)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	Case 1
		sprite = LoadSprite("alana")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 7, 25, 17, 39)
		Sprite_Position(sprite, 128, 160)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	End Select
	
	goal1_found = 0
	goal2_found = 0
	
	msg("Find Casee, Travis, and Man")
	Render()
	Wait(1000)
	
	While inkey = 0
		GetJoystick(0)
		If JButton[0] Then
			Exit While
		End If
		Update
	Wend
	
	Wait(200)
	
	Canvas(7)
	ClearCanvas()
	
	While Not level_end
	If Key(K_ESCAPE) Then: End: End If
		'Sprite_CheckCollisions(2)
		control(sprite, player)
		World_Update(2, sprite)
		
		If Sprite_GetHit(sprite, goal3) Then
			If goal1_found And goal2_found Then
				level_end = true
			Else
				Exit While
			End If
		ElseIf Sprite_GetHit(sprite, goal1) Then
			goal1_found = true
		ElseIf Sprite_GetHit(sprite, goal2) Then
			goal2_found = true
		ElseIf (Sprite_Pos[sprite,0] < 0 Or Sprite_Pos[sprite,0] > Map_Width_InPixels Or Sprite_Pos[sprite,1] > Map_Height_InPixels) Then
			PlaySound(death_sound, 0, 0)
			Wait(200)
			ClearSprite(sprite)
			ClearSprite(goal1)
			ClearSprite(goal2)
			ClearSprite(goal3)
			ClearMap()
			Return 0
		End If
	
		Render()
	Wend
	
	If level_end Then
		ClearSprite(sprite)
		ClearSprite(goal1)
		ClearSprite(goal2)
		ClearSprite(goal3)
		ClearMap()
		return 1
	Else
		msg("You Did Not Find Everyone")
		Render()
		Wait(2000)
		msg("Try again")
		Render()
		Wait(2000)
		Canvas(7)
		ClearCanvas()
		ClearSprite(sprite)
		ClearSprite(goal1)
		ClearSprite(goal2)
		ClearSprite(goal3)
		ClearMap()
		return 0
	End If
	
	Return 1
End Function

Function bonus_stage2(player)

	LoadMap("bonus_level2", 0, 0, 640, 480)

	bkg = LoadBkg("bonus.png")
	Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 0)

	update_rate = 10
	hero_move_rate = 2
	
	level_end = false
	
	dim sprite
	
	goal = LoadSprite("travis")
	Sprite_Position(goal, 576, 64)
	'Sprite_RenderTopLayer(goal, true)
	Sprite_SetLayer(goal, 3)
	Sprite_Play(goal, 1, -1)
	
	Select Case Player_Character[player]
	Case 0
		sprite = LoadSprite("dk")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 8, 19, 18, 45)
		Sprite_Position(sprite, 2, 64)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	Case 1
		sprite = LoadSprite("alana")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 7, 25, 17, 39)
		Sprite_Position(sprite, 2, 64)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	End Select
	
	While Not level_end
	If Key(K_ESCAPE) Then: End: End If
		'Sprite_CheckCollisions(2)
		control(sprite, player)
		World_Update(2, sprite)
		
		If Sprite_GetHit(sprite, goal) Then
			level_end = true
		ElseIf (Sprite_Pos[sprite,0] < 0 Or Sprite_Pos[sprite,0] > Map_Width_InPixels Or Sprite_Pos[sprite,1] > Map_Height_InPixels) Then
			PlaySound(death_sound, 0, 0)
			Wait(200)
			ClearSprite(sprite)
			ClearSprite(goal)
			ClearMap()
			Return 0
		End If
	
		Render()
	Wend
	
	
	ClearSprite(sprite)
	ClearSprite(goal)
	ClearMap()
	
	Return 1
End Function

Function bonus_stage3(player)

	LoadMap("bonus_level3", 0, 0, 640, 480)

	bkg = LoadBkg("bonus.png")
	Map_QuickSetBkg(0, bkg)

	Map_SetOffset(0, 0)

	update_rate = 10
	hero_move_rate = 2
	
	level_end = false
	
	dim sprite
	
	goal = LoadSprite("travis")
	Sprite_Position(goal, 640, 512)
	'Sprite_RenderTopLayer(goal, true)
	Sprite_SetLayer(goal, 3)
	Sprite_Play(goal, 0, -1)
	
	Select Case Player_Character[player]
	Case 0
		sprite = LoadSprite("dk")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 8, 19, 18, 45)
		Sprite_Position(sprite, 96, 96)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	Case 1
		sprite = LoadSprite("alana")
		Sprite_SetHitBox(sprite, HITBOX_RECT, 7, 25, 17, 39)
		Sprite_Position(sprite, 96, 96)
		Sprite_RenderTopLayer(sprite, true)
		Sprite_SetLayer(sprite, 2)
		Sprite_Play(sprite, 0, -1)
	End Select
	
	While Not level_end
		
		If Key(K_ESCAPE) Then: End: End If
		
		'Sprite_CheckCollisions(2)
		control(sprite, player)
		World_Update(2, sprite)
		
		If Sprite_GetHit(sprite, goal) Then
			level_end = true
		ElseIf (Sprite_Pos[sprite,0] < 0 Or Sprite_Pos[sprite,0] > Map_Width_InPixels Or Sprite_Pos[sprite,1] > Map_Height_InPixels) Then
			PlaySound(death_sound, 0, 0)
			Wait(200)
			ClearSprite(sprite)
			ClearSprite(goal)
			ClearMap()
			Return 0
		End If
	
		Render()
	Wend
	
	
	ClearSprite(sprite)
	ClearSprite(goal)
	ClearMap()
	
	Return 1
End Function

function Bonus_Levels(n_players, p1_char, p2_char)
	LoadMusic(music_dir$ + "MushroomTheme.mp3")
	SetMusicVolume(128)
	PlayMusic(-1)
	
	current_player = 0
	
	'while not bonus_stage2(current_player)
	'	if n_players = 2 then
	'		current_player = not current_player
	'	end if
	'wend
	
	'while not bonus_stage3(current_player)
	'	if n_players = 2 then
	'		current_player = not current_player
	'	end if
	'wend
	
	while not bonus_stage1(current_player)
		if n_players = 2 then
			current_player = not current_player
		end if
	wend
	
	
	DeleteMusic()
end function


function run()
	Engine_Init()
	CanvasOpen(0, 640, 480, 0, 0, 640, 480, 1)
	Canvas(0)
	
	While JButton[0] Or Inkey <> 0
		GetJoystick(0)
	Wend
	
	Wait(200)
	
	While True
		If Not Game_Menu() Then
			return -1
		End If
		
		If NUMPLAYERS > 10 Then
			Bonus_Levels(NUMPLAYERS-10, Player_Character[0], Player_Character[1])
		Else
			Open_Scene()
			Home_World(NUMPLAYERS, Player_Character[0], Player_Character[1])
			OverWorld1()
			Park_Scene()
			Park_World(NUMPLAYERS, Player_Character[0], Player_Character[1])
			OverWorld2()
			Swim_Scene()
			Swim_World(NUMPLAYERS, Player_Character[0], Player_Character[1])
			OverWorld3()
			Space_Scene()
			Space_World(NUMPLAYERS, Player_Character[0], Player_Character[1])
		End If
		Exit While	
	Wend

	For i = 0 to 7
		CanvasClose(i)
	Next
	
	Cls
	CanvasOpen(0, 640, 480, 0, 0, 640, 480, 1)
	Canvas(0)
	SetCanvasVisible(0, true)
	
	Wait(100)
	
	If ImageExists(0) Then
		DeleteImage(0)
	End If
	LoadImage(0, gfx_dir$ + "title2.png")
	dim w
	dim h
	GetImageSize(0, w, h)
	DrawImage_Blit_Ex(0, 0, 0, 640, 480, 0, 0, w, h)
	SetColor(RGB(0,0,128))
	RectFill(100, 350, 500, 100)
	SetColor(RGB(255,255,255))
	Font(0)
	DrawText("MERRY CHRISTMAS 2017",120,370)
	Update()
	Wait(200)
	While inkey = 0 
		GetJoystick(0)
		If JButton[0] Then
			Exit While
		End If
		Update
	Wend
	
	for i = 255 to 0 step -1
		SetCanvasAlpha(0, i)
		DrawImage_Blit_Ex(0, 0, 0, 640, 480, 0, 0, w, h)
		SetColor(RGB(0,0,128))
		RectFill(100, 350, 500, 100)
		SetColor(RGB(255,255,255))
		Font(0)
		DrawText("MERRY CHRISTMAS 2017",120,370)
		Update()
		wait(10)
	next
	DeleteImage(0)
	Wait(200)
	CanvasClose(0)
	return 1
end function

w = 1

while w >= 0
	w = run()
wend


'While not Key(k_escape)
	'Sprite_CheckCollisions(2)
'	control(warrior, dk_attack)
'	World_Update(2, warrior)
	
	
'	Render()
'Wend
