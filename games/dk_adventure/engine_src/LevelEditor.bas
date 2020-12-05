include "gui.bas"

MAP_WINDOW = 7

MAP_CANVAS_OVERLAY = 15

MAX_IMAGES = 4096
MAX_TILESETS = 2
MAX_TILES = 512
MAX_TILE_FRAMES = 4
MAX_ANIMATION_FRAMES = 8
MAX_FRAMESHEETS = 10
MAX_SPRITES = 10
MAX_SPRITE_ANIMATIONS = 100

Sprite_Dir$ = "sprite/"
Gfx_Dir$ = "gfx/"
Music_Dir$ = "music/"
Sfx_Dir$ = "sfx/"
TileSet_Dir$ = "tileset/"
Video_Dir$ = "video/"
Map_Dir$ = "map/"

'FrameSheets can be tilesheets or sprite sheets
NumFrameSheets = 0
Dim FrameSheet_File$[MAX_FRAMESHEETS]
Dim FrameSheet_Image[MAX_FRAMESHEETS]
Dim FrameSheet_NumFrames[MAX_FRAMESHEETS]
Dim FrameSheet_Width[MAX_FRAMESHEETS]
Dim FrameSheet_Height[MAX_FRAMESHEETS]
Dim FrameSheet_Frame_Width[MAX_FRAMESHEETS]
Dim FrameSheet_Frame_Height[MAX_FRAMESHEETS]

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

Map_CurrentLayer = 0

TileSet_Image = 6

Function LoadFrameSheet(img_file$, frame_width, frame_height)
	f_num = NumFrameSheets
	For i = 0 to MAX_IMAGES-1
		If Not ImageExists(i) Then
			LoadImage(i, Gfx_Dir$ + img_file$)
			'ColorKey(i, -1)
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
	FrameSheet_Image[f_num] = TileSet_Image
	LoadImage(TileSet_Image, Gfx_Dir$ + img_file$)
	If Not ImageExists(TileSet_Image) Then
		Print "Could Not Load Image"
		Return -1
	End If
	'ColorKey(CurrentImage, -1)
	FrameSheet_File$[f_num] = img_file$
	w = 0
	h = 0
	GetImageSize(TileSet_Image, w, h)
	FrameSheet_Width[f_num] = w
	FrameSheet_Height[f_num] = h
	FrameSheet_Frame_Width[f_num] = frame_width
	FrameSheet_Frame_Height[f_num] = frame_height
	DeleteImage(TileSet_Image)
	Push_S(img_file$)
	NumFrameSheets = NumFrameSheets + 1
	Return f_num
End Function

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

Sub CreateTileSet(img_file$, tile_width, tile_height)
	If TileSet_Init Then
		If ImageExists(FrameSheet_Image[ TileSet_FrameSheet ]) Then
			DeleteImage(FrameSheet_Image[ TileSet_FrameSheet ])
		End If
	End If
	TileSet_FrameSheet = LoadFrameSheet(img_file$, tile_width, tile_height)
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

Sub Editor_CreateTileSet(img_file$, tile_width, tile_height)
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
	TileSet_FrameSheet = Editor_LoadFrameSheet(img_file$, tile_width, tile_height)
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

	Window(MAP_WINDOW)
	dim win_w
	dim win_h
	GetWindowSize(MAP_WINDOW, win_w, win_h)

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

Sub Editor_CreateMap(width_in_tiles, height_in_tiles, vpx, vpy, vpw, vph, sect_w, sect_h)
	Map_Width = width_in_tiles
	Map_Height = height_in_tiles
	Map_Width_InPixels = Map_Width * FrameSheet_Frame_Width[ TileSet_FrameSheet ]
	Map_Height_InPixels = Map_Height * FrameSheet_Frame_Height[ TileSet_FrameSheet ]
	Map_Viewport_X = vpx
	Map_Viewport_Y = vpy
	Map_Viewport_Width = vpw
	Map_Viewport_Height = vph

	Video_Layer = -1

	Window(MAP_WINDOW)
	dim win_w
	dim win_h
	GetWindowSize(MAP_WINDOW, win_w, win_h)

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
	LoadImage(TileSet_Image, Gfx_Dir$ + Pop_S$())
End Sub

Sub Editor_SaveTileSet()
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

Sub Editor_LoadTileSet(tset$)
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

	TileSet_FrameSheet = Editor_LoadFrameSheet(fs_file$, fw, fh)
	NumTiles = Int(FrameSheet_Width[ TileSet_FrameSheet ] / fw) * Int(FrameSheet_Height[ TileSet_FrameSheet ] / fh)

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

Sub Editor_SaveMap(map_name$)
	Editor_SaveTileSet()
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

Sub Editor_LoadMap(map_name$, vpx, vpy, vpw, vph)
	f = FreeFile()

	FileOpen(f, Map_Dir$ + map_name$ + ".mfi", TEXT_INPUT)
	tset$ = ReadLine$(f)
	FileClose(f)

	Editor_LoadTileSet(tset$)
	'Editor_CreateTileSet("ct.png", 32, 32)

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

	'If MAP_WINDOW is open, then close it
	If WindowExists(MAP_WINDOW) Then
		WindowClose(MAP_WINDOW)
	End If

	'Open "Map Window
	WindowOpen(MAP_WINDOW, map_name$, WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, Map_Sector_Width, Map_Sector_Height, 3)

	Window(MAP_WINDOW)

	dim win_w
	dim win_h
	GetWindowSize(MAP_WINDOW, win_w, win_h)

	cw = win_w + (FrameSheet_Frame_Width[ TileSet_FrameSheet ]*2)
	ch = win_h + (FrameSheet_Frame_Height[ TileSet_FrameSheet ]*2)

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
		SetCanvasZ(i,i)
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
	ShowWindow(MAP_WINDOW)

	LoadImage(TileSet_Image, Gfx_Dir$ + Pop_S$())

	'Print "Img Exists = " + ImageExists(FrameSheet_Image[ TileSet_FrameSheet ])
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
	Window(MAP_WINDOW)
	SetCanvasVisible(layer, TRUE)
	Map_Layer_isVisible[layer] = TRUE
End Sub

Sub Map_HideLayer(layer)
	Window(MAP_WINDOW)
	SetCanvasVisible(layer, FALSE)
	Map_Layer_isVisible[layer] = FALSE
End Sub

Sub Map_SetLayer(layer)
	Window(MAP_WINDOW)
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
	'Print "f = " + frame_num
	'Print "DIB (" + image + ", " + x + ", " + y + ", " + src_x + " ," + src_y + ", " + FrameSheet_Frame_Width[ TileSet_FrameSheet ] + ", " + FrameSheet_Frame_Height[ TileSet_FrameSheet ] + " )"
	'update()
	'waitkey()
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

Sub Editor_Map_Render()
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

	Window(MAP_WINDOW)

	For i = 0 to MAX_LAYERS-1
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

			If Layer_Flag_Geometry[i] Then
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
	Update()
End Sub

EDIT_MODE_TILE = 0
EDIT_MODE_GEOMETRY = 1

Editor_Mode_Text$ = "TILE"
Editor_Mode = 0

Gui_Init()

main_win = Gui_WindowOpen("Level Editor", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480, 0)

'Menu Panel
menu_panel = Gui_CreatePanel(main_win, "menu panel", 0, 0, 640, 30)

'Menu Buttons
new_button = Gui_CreateButton(menu_panel, "New Map", 5, 5, 60, 20)
load_button = Gui_CreateButton(menu_panel, "Load Map", 70, 5, 60, 20)
save_button = Gui_CreateButton(menu_panel, "Save Map", 135, 5, 60, 20)
tile_mode_button = Gui_CreateButton(menu_panel, "Tile Mode", 300, 5, 70, 20)
geometry_mode_button = Gui_CreateButton(menu_panel, "Geom Mode", 375, 5, 70, 20)
mode_label = Gui_CreateLabel(menu_panel, "Mode:"+Editor_Mode_Text$, 450, 5)

'Map Info Panel
map_info_panel = Gui_CreatePanel(main_win, "info panel", 5, 35, 180, 85)

'Map Info Fields
map_info_mapLabel = Gui_CreateLabel(map_info_panel, "Map:", 5, 5)
map_info_mapField = Gui_CreateTextField(map_info_panel, 40, 5, 130, 20, 0, 0)
map_info_tsetLabel = Gui_CreateLabel(map_info_panel, "Tileset:", 5, 30)
map_info_tsetField = Gui_CreateTextField(map_info_panel, 65, 30, 100, 20, 0, 0)
map_info_fpsLabel = Gui_CreateLabel(map_info_panel, "FPS:", 5, 55)
map_info_fpsField = Gui_CreateTextField(map_info_panel, 40, 55, 130, 20, 0, 0)

'Map Settings Panel
map_setting_panel = Gui_CreatePanel(main_win, "setting panel", 5, 125, 180, 350)

'Map Settings Stuff
map_setting_rtileLabel = Gui_CreateLabel(map_setting_panel, "Render Tiles", 5, 30)
map_setting_rtileCheckBox = Gui_CreateCheckBox(map_setting_panel, 120, 30, 20, 20)
map_setting_rImageLabel = Gui_CreateLabel(map_setting_panel, "Render Image", 5, 55)
map_setting_rImageCheckBox = Gui_CreateCheckBox(map_setting_panel, 120, 55, 20, 20)
map_setting_rShapeLabel = Gui_CreateLabel(map_setting_panel, "Render Geometry", 5, 80)
map_setting_rShapeCheckBox = Gui_CreateCheckBox(map_setting_panel, 120, 80, 20, 20)
map_setting_rDrawLabel = Gui_CreateLabel(map_setting_panel, "Render Draw", 5, 105)
map_setting_rDrawCheckBox = Gui_CreateCheckBox(map_setting_panel, 120, 105, 20, 20)
map_setting_activeLabel = Gui_CreateLabel(map_setting_panel, "Active", 5, 130)
map_setting_activeCheckBox = Gui_CreateCheckBox(map_setting_panel, 120, 130, 20, 20)
map_setting_intervalLabel = Gui_CreateLabel(map_setting_panel, "Interval:", 5, 155)
map_setting_intervalField = Gui_CreateTextField(map_setting_panel, 75, 155, 90, 20, 0, 0)
map_setting_layerLabel = Gui_CreateLabel(map_setting_panel, "Layer:", 5, 5)
layerList_Options$ = "Layer 0;Layer 1;Layer 2;Layer 3;Layer 4;Layer 5;Layer 6;Layer 7;"
map_setting_layerList = Gui_CreateDropDown(map_setting_panel, layerList_Options$, 50, 5, 100, 20)

'Bitmap Surface
bsurf_panel = Gui_CreatePanel(main_win, "Bitmap Panel", 190, 35, 300, 300)
bsurf = Gui_CreateBitmapSurface(bsurf_panel, 640, 480)

'Frame Left Scroll
tframe_left_panel = Gui_CreatePanel(main_win, "Left Scroll", 190, 340, 65, 65)
tframe_left_button = Gui_CreateButton(tframe_left_panel, "<", 0, 0, 65, 65)

'Frame Slide
tframe_slide_panel = Gui_CreatePanel(main_win, "Frame Slide Panel", 255, 340, 170, 65)

'Frame Right Scroll
tframe_right_panel = Gui_CreatePanel(main_win, "Right Scroll", 425, 340, 65, 65)
tframe_right_button = Gui_CreateButton(tframe_right_panel, ">", 0, 0, 65, 65)

tframe_adjust_panel = Gui_CreatePanel(main_win, "Adjust Panel", 190, 410, 300, 30)
tframe_adjust_addButton = Gui_CreateButton(tframe_adjust_panel, "+", 5, 5, 20, 20)
tframe_adjust_removeButton = Gui_CreateButton(tframe_adjust_panel, "-", 30, 5, 20, 20)
tframe_adjust_selectButton = Gui_CreateButton(tframe_adjust_panel, "=", 55, 5, 20, 20)
tframe_adjust_stateLabel = Gui_CreateLabel(tframe_adjust_panel, " ", 90, 5)

'Tile Preview
image_preview_panel = Gui_CreatePanel(main_win, "Preview Panel", 495, 35, 140, 170)
image_preview_clip = Gui_CreateImageClip(image_preview_panel, 5, 5, 100, 100)
image_preview_label = Gui_CreateLabel(image_preview_panel, "Image:", 5, 115)
image_preview_loadButton = Gui_CreateButton(image_preview_panel, "Load", 5, 140, 50, 20)
image_preview_clearButton = Gui_CreateButton(image_preview_panel, "Clear", 60, 140, 50, 20)

'Geometry Panel
geometry_panel = Gui_CreatePanel(main_win, "geometry_panel", 495, 210, 140, 250)
geometry_list = Gui_CreateListBox(geometry_panel, " ;", 5, 5, 105, 100)
geometry_removeButton = Gui_CreateButton(geometry_panel, "Remove Geometry", 5, 110, 100, 20)
geometry_editButton = Gui_CreateButton(geometry_panel, "Edit Geometry", 5, 135, 100, 20)

'New Map Window
new_map_win = Gui_WindowOpen("New Map", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 200, 280, 3)

'New Map Panel
new_map_panel = Gui_CreatePanel(new_map_win, "New Map", 0, 0, 200, 280)

'New Map Stuff
new_map_nameLabel = Gui_CreateLabel(new_map_panel, "Map Name:", 5, 5)
new_map_nameField = Gui_CreateTextField(new_map_panel, 70, 5, 120, 20, 0, 0)
new_map_twLabel = Gui_CreateLabel(new_map_panel, "Tile Width:", 5, 60)
new_map_twField = Gui_CreateTextField(new_map_panel, 100, 60, 90, 20, 0, 0)
new_map_thLabel = Gui_CreateLabel(new_map_panel, "Tile Height:", 5, 85)
new_map_thField = Gui_CreateTextField(new_map_panel, 100, 85, 90, 20, 0, 0)
new_map_fpsLabel = Gui_CreateLabel(new_map_panel, "Tile FPS:", 5, 110)
new_map_fpsField = Gui_CreateTextField(new_map_panel, 100, 110, 90, 20, 0, 0)
new_map_mwLabel = Gui_CreateLabel(new_map_panel, "Map Width:", 5, 135)
new_map_mwField = Gui_CreateTextField(new_map_panel, 100, 135, 90, 20, 0, 0)
new_map_mhLabel = Gui_CreateLabel(new_map_panel, "Map Height:", 5, 160)
new_map_mhField = Gui_CreateTextField(new_map_panel, 100, 160, 90, 20, 0, 0)
new_map_swLabel = Gui_CreateLabel(new_map_panel, "Sect Width:", 5, 185)
new_map_swField = Gui_CreateTextField(new_map_panel, 100, 185, 90, 20, 0, 0)
new_map_shLabel = Gui_CreateLabel(new_map_panel, "Sect Height:", 5, 210)
new_map_shField = Gui_CreateTextField(new_map_panel, 100, 210, 90, 20, 0, 0)
new_map_createButton = Gui_CreateButton(new_map_panel, "Create", 5, 250, 60, 20)
new_map_cancelButton = Gui_CreateButton(new_map_panel, "Cancel", 75, 250, 60, 20)
new_map_tsetLabel = Gui_CreateLabel(new_map_panel, "Tileset:", 5, 35)
new_map_tsetList = Gui_CreateDropDown(new_map_panel, " ;", 70, 35, 100, 20)

'Load Map Window: Used as the load window for images as well
load_map_win = Gui_WindowOpen("Load", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 200, 260, 3)

'Load Map Panel
load_map_panel = Gui_CreatePanel(load_map_win, "Load Map", 0, 0, 200, 260)

'Load Map Stuff
load_map_list = Gui_CreateListBox(load_map_panel, " ;", 5, 5, 170, 200)
load_map_loadButton = Gui_CreateButton(load_map_panel, "Load", 5, 230, 60, 20)
load_map_cancelButton = Gui_CreateButton(load_map_panel, "Cancel", 75, 230, 60, 20)

'Edit Geometry Window
edit_geometry_win = Gui_WindowOpen("Edit Geometry", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 160, 160, 3)

'Edit Geometry Panel
edit_geometry_panel = Gui_CreatePanel(edit_geometry_win, "Edit Geometry", 0, 0, 160, 160)

'Edit Geometry Stuff
edit_geometry_label1 = Gui_CreateLabel(edit_geometry_panel, "N1:", 5, 30)
edit_geometry_field1 = Gui_CreateTextField(edit_geometry_panel, 30, 30, 50, 20, 0, 0)
edit_geometry_label2 = Gui_CreateLabel(edit_geometry_panel, "N2:", 5, 55)
edit_geometry_field2 = Gui_CreateTextField(edit_geometry_panel, 30, 55, 50, 20, 0, 0)
edit_geometry_label3 = Gui_CreateLabel(edit_geometry_panel, "N3:", 5, 80)
edit_geometry_field3 = Gui_CreateTextField(edit_geometry_panel, 30, 80, 50, 20, 0, 0)
edit_geometry_label4 = Gui_CreateLabel(edit_geometry_panel, "N4:", 5, 105)
edit_geometry_field4 = Gui_CreateTextField(edit_geometry_panel, 30, 105, 50, 20, 0, 0)
edit_geometry_saveButton = Gui_CreateButton(edit_geometry_panel, "Save", 5, 130, 60, 20)
edit_geometry_cancelButton = Gui_CreateButton(edit_geometry_panel, "Cancel", 75, 130, 60, 20)
edit_geometry_typeLabel = Gui_CreateLabel(edit_geometry_panel, "Type:", 5, 5)
edit_geometry_typeList = Gui_CreateDropDown(edit_geometry_panel, "Line;Rect;Circle;", 50, 5, 70, 20)

'Status Window
status_win = Gui_WindowOpen("Status", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 300, 100, 3)

'Status Panel and Label
status_panel = Gui_CreatePanel(status_win, "Status Panel", 0, 0, 300, 100)
status_label = Gui_CreateLabel(status_panel, "Status", 10, 60)

MAP_DEFAULT_NAME$ = "New_Map"
MAP_DEFAULT_TILE_WIDTH = 32
MAP_DEFAULT_TILE_HEIGHT = 32
MAP_DEFAULT_TILE_FPS = 16
MAP_DEFAULT_MAP_WIDTH = 100
MAP_DEFAULT_MAP_HEIGHT = 100
MAP_DEFAULT_SECTOR_WIDTH = 640
MAP_DEFAULT_SECTOR_HEIGHT = 480

main_dir$ = Dir$()
bsurf_isLoaded = False
bsurf_mouse_x = 0
bsurf_mouse_y = 0
bsurf_mouse_w = 1
bsurf_mouse_h = 1

SelectedTile = 0

'ImageClips for the diffent frames in the animation
Dim frame_clip[MAX_TILE_FRAMES]
frame_clip_count = 0
selected_frame_clip = 0
frame_clip_state = 0

dim geometry_list_index[MAX_GEOMETRIES]
geometry_list_count = 0
selected_geometry = 0

tile_preview = 0

map_mouse_x = 0
map_mouse_y = 0
map_mouse_b1 = 0
map_mouse_b2 = 0
map_mouse_b3 = 0

ed_b1_release = 0
ed_b2_release = 0
ed_b3_release = 0

Sub Map_Ed_GetMouse()
	b1 = map_mouse_b1
	b2 = map_mouse_b2
	b3 = map_mouse_b3
	GetMouse(map_mouse_x, map_mouse_y, map_mouse_b1, map_mouse_b2, map_mouse_b3)

	If b1 And (Not map_mouse_b1) Then
		ed_b1_release = True
	Else
		ed_b1_release = False
	End If

	If b2 And (Not map_mouse_b2) Then
		ed_b2_release = True
	Else
		ed_b2_release = False
	End If

	If b3 And (Not map_mouse_b3) Then
		ed_b3_release = True
	Else
		ed_b3_release = False
	End If
End Sub

Function Map_Ed_Mouse_Release(b)
	Select Case b
	Case 1
		Return ed_b1_release
	Case 2
		Return ed_b2_release
	Case 3
		Return ed_b3_release
	End Select
	Return False
End Function

GEOMETRY_STATE_NULL = 0
GEOMETRY_STATE_LINE = 1
GEOMETRY_STATE_RECT = 2
GEOMETRY_STATE_CIRCLE = 3
GEOMETRY_STATE_TILE_LINE = 4
GEOMETRY_STATE_TILE_RECT = 5
GEOMETRY_STATE_TILE_CIRCLE = 6
GEOMETRY_STATE_PICK = 7

edit_geometry_state = GEOMETRY_STATE_NULL
edit_geometry_type = GEOMETRY_LINE
CurrentGeometry = 0

Dim edit_geometry_n[4]
edit_geometry_n_index = 0

Dim geometry_list_init[MAX_LAYERS]

Sub Editor_Map_Events()
	Window(MAP_WINDOW)
	Map_Ed_GetMouse()
	map_x = Int( (map_mouse_x + Map_Offset_X[0]) / FrameSheet_Frame_Width[ TileSet_FrameSheet ])
	map_y = Int( (map_mouse_y + Map_Offset_Y[0]) / FrameSheet_Frame_Height[ TileSet_FrameSheet ])
	world_mouse_x = map_mouse_x
	world_mouse_y = map_mouse_y
	If edit_geometry_state = GEOMETRY_STATE_TILE_LINE Or edit_geometry_state = GEOMETRY_STATE_TILE_RECT Or edit_geometry_state = GEOMETRY_STATE_TILE_CIRCLE Then
		fw = FrameSheet_Frame_Width[TileSet_FrameSheet]
		fh = FrameSheet_Frame_Height[TileSet_FrameSheet]
		world_mouse_x = Int( world_mouse_x / fw) * fw
		world_mouse_y = Int( world_mouse_y / fh) * fh
	End If
	Map_ScreenToWorld(world_mouse_x, world_mouse_y)
	Select Case Editor_Mode
	Case EDIT_MODE_TILE
		If map_mouse_b1 Then
			Map_Tiles[Map_CurrentLayer, map_x, map_y] = SelectedTile
		ElseIf map_mouse_b3 Then
			Map_Tiles[Map_CurrentLayer, map_x, map_y] = -1
		End If
	Case EDIT_MODE_GEOMETRY
		If Map_Ed_Mouse_Release(1) Then
			'Draw Geometry
			Select Case edit_geometry_state
			Case GEOMETRY_STATE_LINE
				If edit_geometry_n_index = 0 And Map_Ed_Mouse_Release(1) Then
					edit_geometry_n[0] = world_mouse_x
					edit_geometry_n[1] = world_mouse_y
					edit_geometry_n[2] = world_mouse_x
					edit_geometry_n[3] = world_mouse_y
					CurrentGeometry = Map_Geometry_AddLine(edit_geometry_n[0], edit_geometry_n[1], edit_geometry_n[2], edit_geometry_n[3])
					edit_geometry_n_index = 1
					Print "Point 0: "; world_mouse_x; ", "; world_mouse_y
				ElseIf edit_geometry_n_index = 1 And Map_Ed_Mouse_Release(1) Then
					edit_geometry_n[2] = world_mouse_x
					edit_geometry_n[3] = world_mouse_y
					Map_Geometry_Edit(CurrentGeometry, GEOMETRY_LINE, edit_geometry_n[0], edit_geometry_n[1], edit_geometry_n[2], edit_geometry_n[3])
					If geometry_list_init[Map_CurrentLayer] Then
						Gui_ListBox_AddOption(geometry_list, "Line (" + Str$(edit_geometry_n[0]) + ", " + Str$(edit_geometry_n[1]) + ", " + Str$(edit_geometry_n[2]) + ", " + Str$(edit_geometry_n[3]) + ");")
					Else
						Gui_ListBox_SetOptions(geometry_list, "Line (" + Str$(edit_geometry_n[0]) + ", " + Str$(edit_geometry_n[1]) + ", " + Str$(edit_geometry_n[2]) + ", " + Str$(edit_geometry_n[3]) + ");")
						geometry_list_init[Map_CurrentLayer] = True
					End If
					geometry_list_index[geometry_list_count] = CurrentGeometry
					geometry_list_count = geometry_list_count + 1
					edit_geometry_n_index = 0
					'edit_geometry_state = GEOMETRY_STATE_NULL
					Print "Point 1: "; world_mouse_x; ", "; world_mouse_y
				End If
			Case GEOMETRY_STATE_TILE_LINE
				If edit_geometry_n_index = 0 And Map_Ed_Mouse_Release(1) Then
					edit_geometry_n[0] = world_mouse_x
					edit_geometry_n[1] = world_mouse_y
					edit_geometry_n[2] = world_mouse_x
					edit_geometry_n[3] = world_mouse_y
					CurrentGeometry = Map_Geometry_AddLine(edit_geometry_n[0], edit_geometry_n[1], edit_geometry_n[2], edit_geometry_n[3])
					edit_geometry_n_index = 1
					Print "Point 0: "; world_mouse_x; ", "; world_mouse_y
				ElseIf edit_geometry_n_index = 1 And Map_Ed_Mouse_Release(1) Then
					edit_geometry_n[2] = world_mouse_x
					edit_geometry_n[3] = world_mouse_y
					Map_Geometry_Edit(CurrentGeometry, GEOMETRY_LINE, edit_geometry_n[0], edit_geometry_n[1], edit_geometry_n[2], edit_geometry_n[3])
					If geometry_list_init[Map_CurrentLayer] Then
						Gui_ListBox_AddOption(geometry_list, "Line (" + Str$(edit_geometry_n[0]) + ", " + Str$(edit_geometry_n[1]) + ", " + Str$(edit_geometry_n[2]) + ", " + Str$(edit_geometry_n[3]) + ");")
					Else
						Gui_ListBox_SetOptions(geometry_list, "Line (" + Str$(edit_geometry_n[0]) + ", " + Str$(edit_geometry_n[1]) + ", " + Str$(edit_geometry_n[2]) + ", " + Str$(edit_geometry_n[3]) + ");")
						geometry_list_init[Map_CurrentLayer] = True
					End If
					geometry_list_index[geometry_list_count] = CurrentGeometry
					geometry_list_count = geometry_list_count + 1
					edit_geometry_n_index = 0
					'edit_geometry_state = GEOMETRY_STATE_NULL
					Print "Point 1: "; world_mouse_x; ", "; world_mouse_y
				End If
			Case GEOMETRY_STATE_RECT
				If edit_geometry_n_index = 0 And Map_Ed_Mouse_Release(1) Then
					edit_geometry_n[0] = world_mouse_x
					edit_geometry_n[1] = world_mouse_y
					edit_geometry_n[2] = world_mouse_x
					edit_geometry_n[3] = world_mouse_y
					CurrentGeometry = Map_Geometry_AddRect(edit_geometry_n[0], edit_geometry_n[1], edit_geometry_n[2], edit_geometry_n[3])
					edit_geometry_n_index = 1
					Print "Point 0: "; world_mouse_x; ", "; world_mouse_y
				ElseIf edit_geometry_n_index = 1 And Map_Ed_Mouse_Release(1) Then
					edit_geometry_n[2] = world_mouse_x - edit_geometry_n[0]
					edit_geometry_n[3] = world_mouse_y - edit_geometry_n[1]
					Map_Geometry_Edit(CurrentGeometry, GEOMETRY_RECT, edit_geometry_n[0], edit_geometry_n[1], edit_geometry_n[2], edit_geometry_n[3])
					If geometry_list_init[Map_CurrentLayer] Then
						Gui_ListBox_AddOption(geometry_list, "Rect (" + Str$(edit_geometry_n[0]) + ", " + Str$(edit_geometry_n[1]) + ", " + Str$(edit_geometry_n[2]) + ", " + Str$(edit_geometry_n[3]) + ");")
					Else
						Gui_ListBox_SetOptions(geometry_list, "Rect (" + Str$(edit_geometry_n[0]) + ", " + Str$(edit_geometry_n[1]) + ", " + Str$(edit_geometry_n[2]) + ", " + Str$(edit_geometry_n[3]) + ");")
						geometry_list_init[Map_CurrentLayer] = True
					End If
					geometry_list_index[geometry_list_count] = CurrentGeometry
					geometry_list_count = geometry_list_count + 1
					edit_geometry_n_index = 0
					'edit_geometry_state = GEOMETRY_STATE_NULL
				End If
			Case GEOMETRY_STATE_TILE_RECT
				If edit_geometry_n_index = 0 And Map_Ed_Mouse_Release(1) Then
					edit_geometry_n[0] = world_mouse_x
					edit_geometry_n[1] = world_mouse_y
					edit_geometry_n[2] = world_mouse_x
					edit_geometry_n[3] = world_mouse_y
					CurrentGeometry = Map_Geometry_AddRect(edit_geometry_n[0], edit_geometry_n[1], edit_geometry_n[2], edit_geometry_n[3])
					edit_geometry_n_index = 1
					Print "Point 0: "; world_mouse_x; ", "; world_mouse_y
				ElseIf edit_geometry_n_index = 1 And Map_Ed_Mouse_Release(1) Then
					edit_geometry_n[2] = world_mouse_x - edit_geometry_n[0]
					edit_geometry_n[3] = world_mouse_y - edit_geometry_n[1]
					Map_Geometry_Edit(CurrentGeometry, GEOMETRY_RECT, edit_geometry_n[0], edit_geometry_n[1], edit_geometry_n[2], edit_geometry_n[3])
					If geometry_list_init[Map_CurrentLayer] Then
						Gui_ListBox_AddOption(geometry_list, "Rect (" + Str$(edit_geometry_n[0]) + ", " + Str$(edit_geometry_n[1]) + ", " + Str$(edit_geometry_n[2]) + ", " + Str$(edit_geometry_n[3]) + ");")
					Else
						Gui_ListBox_SetOptions(geometry_list, "Rect (" + Str$(edit_geometry_n[0]) + ", " + Str$(edit_geometry_n[1]) + ", " + Str$(edit_geometry_n[2]) + ", " + Str$(edit_geometry_n[3]) + ");")
						geometry_list_init[Map_CurrentLayer] = True
					End If
					geometry_list_index[geometry_list_count] = CurrentGeometry
					geometry_list_count = geometry_list_count + 1
					edit_geometry_n_index = 0
					'edit_geometry_state = GEOMETRY_STATE_NULL
					Print "Point 1: "; world_mouse_x; ", "; world_mouse_y
				End If
			Case GEOMETRY_STATE_CIRCLE
				If edit_geometry_n_index = 0 And Map_Ed_Mouse_Release(1) Then
					edit_geometry_n[0] = world_mouse_x
					edit_geometry_n[1] = world_mouse_y
					edit_geometry_n[2] = 0
					CurrentGeometry = Map_Geometry_AddCircle(edit_geometry_n[0], edit_geometry_n[1], edit_geometry_n[2])
					edit_geometry_n_index = 1
					Print "Point: "; world_mouse_x; ", "; world_mouse_y
				ElseIf edit_geometry_n_index = 1 And Map_Ed_Mouse_Release(1) Then
					edit_geometry_n[2] = Int(Sqrt( (world_mouse_x-edit_geometry_n[0])^2 + (world_mouse_y-edit_geometry_n[1])^2 ))
					Map_Geometry_Edit(CurrentGeometry, GEOMETRY_CIRCLE, edit_geometry_n[0], edit_geometry_n[1], edit_geometry_n[2], 0)
					If geometry_list_init[Map_CurrentLayer] Then
						Gui_ListBox_AddOption(geometry_list, "Circle (" + Str$(edit_geometry_n[0]) + ", " + Str$(edit_geometry_n[1]) + ", " + Str$(edit_geometry_n[2]) + ", " + Str$(edit_geometry_n[3]) + ");")
					Else
						Gui_ListBox_SetOptions(geometry_list, "Circle (" + Str$(edit_geometry_n[0]) + ", " + Str$(edit_geometry_n[1]) + ", " + Str$(edit_geometry_n[2]) + ", " + Str$(edit_geometry_n[3]) + ");")
						geometry_list_init[Map_CurrentLayer] = True
					End If
					geometry_list_index[geometry_list_count] = CurrentGeometry
					geometry_list_count = geometry_list_count + 1
					edit_geometry_n_index = 0
					'edit_geometry_state = GEOMETRY_STATE_NULL
					Print "Radius: "; edit_geometry_n[2]
				End If
			Case GEOMETRY_STATE_TILE_CIRCLE
				If edit_geometry_n_index = 0 And Map_Ed_Mouse_Release(1) Then
					edit_geometry_n[0] = world_mouse_x
					edit_geometry_n[1] = world_mouse_y
					edit_geometry_n[2] = 0
					CurrentGeometry = Map_Geometry_AddCircle(edit_geometry_n[0], edit_geometry_n[1], edit_geometry_n[2])
					edit_geometry_n_index = 1
					Print "Point: "; world_mouse_x; ", "; world_mouse_y
				ElseIf edit_geometry_n_index = 1 And Map_Ed_Mouse_Release(1) Then
					edit_geometry_n[2] = Int(Sqrt( (world_mouse_x-edit_geometry_n[0])^2 + (world_mouse_y-edit_geometry_n[1])^2 ))
					Map_Geometry_Edit(CurrentGeometry, GEOMETRY_CIRCLE, edit_geometry_n[0], edit_geometry_n[1], edit_geometry_n[2], 0)
					If geometry_list_init[Map_CurrentLayer] Then
						Gui_ListBox_AddOption(geometry_list, "Circle (" + Str$(edit_geometry_n[0]) + ", " + Str$(edit_geometry_n[1]) + ", " + Str$(edit_geometry_n[2]) + ", " + Str$(edit_geometry_n[3]) + ");")
					Else
						Gui_ListBox_SetOptions(geometry_list, "Circle (" + Str$(edit_geometry_n[0]) + ", " + Str$(edit_geometry_n[1]) + ", " + Str$(edit_geometry_n[2]) + ", " + Str$(edit_geometry_n[3]) + ");")
						geometry_list_init[Map_CurrentLayer] = True
					End If
					geometry_list_index[geometry_list_count] = CurrentGeometry
					geometry_list_count = geometry_list_count + 1
					edit_geometry_n_index = 0
					'edit_geometry_state = GEOMETRY_STATE_NULL
					Print "Radius: "; edit_geometry_n[2]
				End If
			Case GEOMETRY_STATE_PICK
				If edit_geometry_n_index = 0 And Map_Ed_Mouse_Release(1) Then
					fw = FrameSheet_Frame_Width[TileSet_FrameSheet]
					fh = FrameSheet_Frame_Height[TileSet_FrameSheet]
					tx = Int( world_mouse_x / fw) * fw
					ty = Int( world_mouse_y / fh) * fh
					Print ""
					Print "Screen Pos = "; map_mouse_x; ", "; map_mouse_y
					Print "World Pos = "; world_mouse_x; ", "; world_mouse_y
					Print "World Tile = "; tx; ", "; ty
				End If
			End Select
		ElseIf edit_geometry_n_index = 1 Then
			Select Case edit_geometry_type
			Case GEOMETRY_LINE
				Map_Geometry_Edit(CurrentGeometry, GEOMETRY_LINE, edit_geometry_n[0], edit_geometry_n[1], world_mouse_x, world_mouse_y)
			Case GEOMETRY_RECT
				Map_Geometry_Edit(CurrentGeometry, GEOMETRY_RECT, edit_geometry_n[0], edit_geometry_n[1], world_mouse_x - edit_geometry_n[0], world_mouse_y - edit_geometry_n[1])
			Case GEOMETRY_CIRCLE
				Map_Geometry_Edit(CurrentGeometry, GEOMETRY_CIRCLE, edit_geometry_n[0], edit_geometry_n[1], Int(Sqrt( (world_mouse_x-edit_geometry_n[0])^2 + (world_mouse_y-edit_geometry_n[1])^2 )), 0 )
			End Select
		End If
	End Select

	If Key(k_right) Then
		map_scroll(2,0)
		wait(5)
	End If

	If Key(k_left) Then
		map_scroll(-2,0)
		wait(5)
	End If

	If Key(k_up) Then
		map_scroll(0,-2)
		wait(5)
	end if

	If Key(k_down) Then
		map_scroll(0,2)
		wait(5)
	End If

	If Key(k_l) And Editor_Mode = EDIT_MODE_GEOMETRY And edit_geometry_n_index = 0 Then
		edit_geometry_state = GEOMETRY_STATE_LINE
		edit_geometry_type = GEOMETRY_LINE
		Print "Draw Line"
	ElseIf Key(k_r) And Editor_Mode = EDIT_MODE_GEOMETRY And edit_geometry_n_index = 0 Then
		edit_geometry_state = GEOMETRY_STATE_RECT
		edit_geometry_type = GEOMETRY_RECT
		Print "Draw Rect"
	ElseIf Key(k_c) And Editor_Mode = EDIT_MODE_GEOMETRY And edit_geometry_n_index = 0 Then
		edit_geometry_state = GEOMETRY_STATE_CIRCLE
		edit_geometry_type = GEOMETRY_CIRCLE
		Print "Draw Circle"
	ElseIf Key(k_p) And Editor_Mode = EDIT_MODE_GEOMETRY And edit_geometry_n_index = 0 Then
		edit_geometry_state = GEOMETRY_STATE_PICK
		Print "Pick Mode"
	ElseIf Key(k_t) And Editor_Mode = EDIT_MODE_GEOMETRY And edit_geometry_n_index = 0 Then
		Select Case edit_geometry_state
		Case GEOMETRY_STATE_CIRCLE
			edit_geometry_state = GEOMETRY_STATE_TILE_CIRCLE
			Print "Tile Circle"
		Case GEOMETRY_STATE_RECT
			edit_geometry_state = GEOMETRY_STATE_TILE_RECT
			Print "Tile Rect"
		Case GEOMETRY_STATE_LINE
			edit_geometry_state = GEOMETRY_STATE_TILE_LINE
			Print "Tile Line"
		End Select
	End If

End Sub

Sub OnTileChange()
	If frame_clip_count > 0 Then
		For i = 0 to frame_clip_count-1
			Gui_DeleteImageClip(frame_clip[i])
		Next
	End If

	Dim x
	Dim y
	Dim w
	Dim h

	If TileSet_NumFrames[SelectedTile] > 0 Then
		For i = 0 to TileSet_NumFrames[SelectedTile]-1
			frame_clip[i] = Gui_CreateImageClip(tframe_slide_panel, i*65, 0, 64, 64)
			TileSet_GetFrame(TileSet_Frames[SelectedTile, i], x, y, w, h)
			Gui_ImageClip_Grab(frame_clip[i], FrameSheet_Image[TileSet_FrameSheet], x, y, w, h)
		Next
	End If
	frame_clip_count = TileSet_NumFrames[SelectedTile]
	Selected_Frame_Clip = 0
End Sub

Sub OnGeometryChange()
	selected_geometry = geometry_list_index[Gui_ListBox_GetSelection(geometry_list)]
End Sub

Sub OnLayerChange()
	Map_SetLayer(Gui_DropDown_GetSelection(map_setting_layerList))
	Gui_CheckBox_SetState(map_setting_rtileCheckBox, Layer_Flag_Tiles[Map_CurrentLayer])
	Gui_CheckBox_SetState(map_setting_rImageCheckBox, Layer_Flag_Image[Map_CurrentLayer])
	Gui_CheckBox_SetState(map_setting_rDrawCheckBox, Layer_Flag_Draw[Map_CurrentLayer])
	Gui_CheckBox_SetState(map_setting_rShapeCheckBox, Layer_Flag_Geometry[Map_CurrentLayer])
	Gui_CheckBox_SetState(map_setting_activeCheckBox, Map_Layer_isVisible[Map_CurrentLayer])
	Gui_TextField_SetText(map_setting_intervalField, Str$(Map_Offset_Interval[Map_CurrentLayer]))

	Gui_DeleteImage(Map_Bkg_Image[Map_CurrentLayer])
	If Map_Bkg_File$[Map_CurrentLayer] <> "" Then
		If Not ImageExists(Map_Bkg_Image[Map_CurrentLayer]) Then
			Map_Bkg_Image[Map_CurrentLayer] = Gui_LoadImage(Map_Bkg_File$[Map_CurrentLayer])
		End If
		iw = 0
		ih = 0
		GetImageSize(Map_Bkg_Image[Map_CurrentLayer], iw, ih)
		Gui_ImageClip_Grab(image_preview_clip, Map_Bkg_Image[Map_CurrentLayer], 0, 0, iw, ih)
		Gui_Label_SetText(image_preview_label, "Image:" + Map_Bkg_File$[Map_CurrentLayer])
	Else
		Gui_DeleteImageClip(image_preview_clip)
		image_preview_clip = Gui_CreateImageClip(image_preview_panel, 5, 5, 100, 100)
		Gui_Label_SetText(image_preview_label, "Image:")
	End If

	gList$ = ""
	geometry_list_count = 0

	For sect = 0 to MAX_SECTORS-1
		If Map_NumSectorGeometries[Map_CurrentLayer, sect] > 0 Then
			For g = 0 to Map_NumSectorGeometries[Map_CurrentLayer, sect]-1
				g_num = Map_Geometries[Map_CurrentLayer, sect, g]
				If Geometry_Type[g_num] = GEOMETRY_LINE Then
					gList$ = gList$ + "Line (" + Str$(Geometry[g_num,0]) + ", " + Str$(Geometry[g_num,1]) + ", " + Str$(Geometry[g_num,2]) + ", " + Str$(Geometry[g_num,3]) + ");"
				ElseIf Geometry_Type[g_num] = GEOMETRY_RECT Then
					gList$ = gList$ + "Rect (" + Str$(Geometry[g_num,0]) + ", " + Str$(Geometry[g_num,1]) + ", " + Str$(Geometry[g_num,2]) + ", " + Str$(Geometry[g_num,3]) + ");"
				ElseIf Geometry_Type[g_num] = GEOMETRY_CIRCLE Then
					gList$ = gList$ + "Circle (" + Str$(Geometry[g_num,0]) + ", " + Str$(Geometry[g_num,1]) + ", " + Str$(Geometry[g_num,2]) + ");"
				End If
				geometry_list_index[geometry_list_count] = g_num
				geometry_list_count = geometry_list_count + 1
			Next
		End If
	Next

	If gList$ = "" Then
		gList$ = " ;"
	End If

	Gui_ListBox_SetOptions(geometry_list, gList$)
	Gui_ListBox_SetSelection(geometry_list, 0)
	OnGeometryChange()
End Sub

Sub OnLoadBkg()
	main_dir$ = Dir$()
	ChangeDir(main_dir$ + "/gfx")
	item$ = DirFirst$()
	options$ = ""
	While item$ <> ""
		If Mid$(item$, 0, 1) <> "." Then
			options$ = options$ + item$ + ";"
		End If
		item$ = DirNext$()
	Wend
	If options$ = "" Then
		options$ = " ;"
	End If
	Gui_ListBox_SetOptions(load_map_list, options$)
	Gui_ShowWindow(load_map_win)

	loadBkg_isOpen = True
	While loadBkg_isOpen
		Gui_GetEvents()
		If Gui_Button_Clicked(load_map_loadButton) Then
			Map_Bkg_File$[Map_CurrentLayer] = Gui_ListBox_GetSelectionText$(load_map_list)
			img = Gui_LoadImage(Map_Bkg_File$[Map_CurrentLayer])
			Map_SetBkg(img)
			w = 0
			h = 0
			GetImageSize(img, w, h)
			Gui_ImageClip_Grab(image_preview_clip, img, 0, 0, w, h)
			Gui_Label_SetText(image_preview_label, "Image:" + Map_Bkg_File$[Map_CurrentLayer])
			loadBkg_isOpen = False
		ElseIf Gui_Button_Clicked(load_map_cancelButton) Then
			loadBkg_isOpen = False
		End If
		Gui_Render()
	Wend

	ChangeDir(main_dir$)
	Print "Current Dir = " + Dir$()

	Gui_HideWindow(load_map_win)
End Sub

Sub Editor_Gui_Events()

	p = Gui_GetActivePanel()

	If bsurf_isLoaded Then
		If Key(k_r) Then
			Gui_BitmapSurface_Clear()
			Gui_BitmapSurface_DrawImage(TileSet_Image, 0, 0)
			Gui_Render()
		End If
		If Gui_BitmapSurface_Clicked(bsurf) Then
			If frame_clip_state Then
				bx = 0
				by = 0
				Gui_BitmapSurface_GetMouse(bsurf, bx, by)
				bx = Int(bx / bsurf_mouse_w)
				by = Int(by / bsurf_mouse_h)
				tile_frame_clip = by * TileSet_FramesPerRow + bx

				'TileSet_GetFrame(tile_frame_clip, bsurf_mouse_x, bsurf_mouse_y, bsurf_mouse_w, bsurf_mouse_h)
				TileSet_Frames[SelectedTile, selected_frame_clip] = tile_frame_clip
				frame_clip_state = 0
				Gui_Label_SetText(tframe_adjust_stateLabel, " ")

				Dim x
				Dim y
				Dim w
				Dim h

				Gui_DeleteImageClip(frame_clip[selected_frame_clip])
				frame_clip[selected_frame_clip] = Gui_CreateImageClip(tframe_slide_panel, selected_frame_clip*65, 0, 64, 64)
				TileSet_GetFrame(TileSet_Frames[SelectedTile, selected_frame_clip], x, y, w, h)
				Gui_ImageClip_Grab(frame_clip[selected_frame_clip], FrameSheet_Image[TileSet_FrameSheet], x, y, w, h)
			Else
				Gui_BitmapSurface_GetMouse(bsurf, bsurf_mouse_x, bsurf_mouse_y)
				bsurf_mouse_x = Int(bsurf_mouse_x / bsurf_mouse_w)
				bsurf_mouse_y = Int(bsurf_mouse_y / bsurf_mouse_h)
				SelectedTile = bsurf_mouse_y * TileSet_FramesPerRow + bsurf_mouse_x

				TileSet_GetFrame(SelectedTile, bsurf_mouse_x, bsurf_mouse_y, bsurf_mouse_w, bsurf_mouse_h)
				OnTileChange()
			End If
		End If

		Gui_BitmapOverlay_SetColor(RGB(255,0,0))
		Gui_BitmapOverlay_DrawRect(bsurf_mouse_x, bsurf_mouse_y, bsurf_mouse_w, bsurf_mouse_h)
	End If

	If Gui_Button_Clicked(new_button) Then
		Gui_TextField_SetText(new_map_nameField, "New_Map")
		Gui_TextField_SetText(new_map_twField, Str$(MAP_DEFAULT_TILE_WIDTH))
		Gui_TextField_SetText(new_map_thField, Str$(MAP_DEFAULT_TILE_HEIGHT))
		Gui_TextField_SetText(new_map_fpsField, Str$(MAP_DEFAULT_TILE_FPS))
		Gui_TextField_SetText(new_map_mwField, Str$(MAP_DEFAULT_MAP_WIDTH))
		Gui_TextField_SetText(new_map_mhField, Str$(MAP_DEFAULT_MAP_HEIGHT))
		Gui_TextField_SetText(new_map_swField, Str$(MAP_DEFAULT_SECTOR_WIDTH))
		Gui_TextField_SetText(new_map_shField, Str$(MAP_DEFAULT_SECTOR_HEIGHT))
		main_dir$ = Dir$()
		ChangeDir(main_dir$ + "/gfx")
		item$ = DirFirst$()
		options$ = ""
		While item$ <> ""
			If Mid$(item$, 0, 1) <> "." Then
				options$ = options$ + item$ + ";"
			End If
			item$ = DirNext$()
		Wend
		If options$ = "" Then
			options$ = " ;"
		End If
		Gui_DropDown_SetOptions(new_map_tsetList, options$)
		Gui_ShowWindow(new_map_win)
		ChangeDir(main_dir$)
	ElseIf Gui_Button_Clicked(new_map_cancelButton) Then
		Gui_HideWindow(new_map_win)
	ElseIf Gui_Button_Clicked(new_map_createButton) Then
		map_name$ = Gui_TextField_GetText$(new_map_nameField)
		Image_File$ = Gui_DropDown_GetSelectionText$(new_map_tsetList)
		tset_w = Int( Val(Gui_TextField_GetText$(new_map_twField)) )
		tset_h = Int( Val(Gui_TextField_GetText$(new_map_thField)) )
		tset_fps = Int( Val(Gui_TextField_GetText$(new_map_fpsField)) )
		map_w = Int( Val(Gui_TextField_GetText$(new_map_mwField)) )
		map_h = Int( Val(Gui_TextField_GetText$(new_map_mhField)) )
		sect_w = Int( Val(Gui_TextField_GetText$(new_map_swField)) )
		sect_h = Int( Val(Gui_TextField_GetText$(new_map_shField)) )
		Print "Image: "; Image_File$
		Print "Tile Width = "; tset_w
		Print "Tile Height = "; tset_h
		Print "Tile FPS = "; tset_fps
		Print "Map Width = "; map_w
		Print "Map Height = "; map_h
		Print "Sector Width = "; sect_w
		Print "Sector Height = "; sect_h
		Gui_HideWindow(new_map_win)

		'If MAP_WINDOW is open, then close it
		If WindowExists(MAP_WINDOW) Then
			WindowClose(MAP_WINDOW)
		End If

		'Open "Map Window
		WindowOpen(MAP_WINDOW, map_name$, WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, sect_w, sect_h, 3)
		Window(MAP_WINDOW)
		'Show Status
		Gui_Label_SetText(status_label, "Creating Tile Settings and Map...")
		Gui_ShowWindow(status_win)
		Gui_Render()

		'Loading Tile Set
		Editor_CreateTileSet(Image_File$, tset_w, tset_h)
		bsurf_isLoaded = True
		bsurf_mouse_w = tset_w
		busrf_mouse_h = tset_h

		'Creating Map
		'Note: Setting the viewport width and height to sector width and height
		Editor_CreateMap(map_w, map_h, 0, 0, sect_w, sect_h, sect_w, sect_h)

		'Setting Fields
		Gui_TextField_SetText(map_info_mapField, map_name$)
		Gui_TextField_SetText(map_info_fpsField, str(tset_fps))
		Gui_CheckBox_SetState(map_setting_rtileCheckBox, FALSE)
		Gui_CheckBox_SetState(map_setting_rImageCheckBox, FALSE)
		Gui_CheckBox_SetState(map_setting_rShapeCheckBox, FALSE)
		Gui_CheckBox_SetState(map_setting_rDrawCheckBox, FALSE)
		Gui_DropDown_SetSelection(map_setting_layerList, 0)
		Gui_BitmapSurface_Clear()
		Gui_BitmapSurface_DrawImage(FrameSheet_Image[Tileset_FrameSheet], 0, 0)
		Gui_ListBox_SetOptions(geometry_list, " ;")
		Gui_TextField_SetText(map_setting_intervalField, "1.0")
		Gui_CheckBox_SetState(map_setting_activeCheckBox, FALSE)

		'Set geometry_init to false
		For i = 0 to MAX_LAYERS-1
			geometry_list_init[i] = False
		Next

		Gui_HideWindow(status_win)
		Window(MAP_WINDOW)
		ShowWindow(MAP_WINDOW)
	ElseIf Gui_Button_Clicked(load_button) Then
		options$ = ""
		main_dir$ = Dir$()
		ChangeDir(main_dir$ + "/map")
		item$ = DirFirst$()
		While item$ <> "" And item$ <> " "
			If Length(item$) >= 4 Then
				If Mid$(item$, Length(item$)-4, 4) = ".map" Then
					options$ = options$ + Mid$(item$, 0, Length(item$)-4) + ";"
				End If
			End If
			item$ = DirNext$()
		Wend
		ChangeDir(main_dir$)
		If options$ = "" Then
			options$ = " ;"
		End If
		Gui_ListBox_SetOptions(load_map_list, options$)
		Gui_ShowWindow(load_map_win)
		While True
			Gui_GetEvents()

			map_name$ = Gui_ListBox_GetSelectionText$(load_map_list)

			If Gui_Button_Clicked(load_map_loadButton) And map_name$ <> "" Then
				'Show Status
				Gui_Label_SetText(status_label, "Loading Map...")
				Gui_ShowWindow(status_win)
				Gui_Render()

				Editor_LoadMap( map_name$, 0, 0, 640, 480)

				'Switch back to main window
				Window(main_win)

				'Set Fields
				Gui_TextField_SetText(map_info_mapField, map_name$)
				Gui_TextField_SetText(map_info_fpsField, Str$(TileSet_FPS))
				Gui_BitmapSurface_Clear()
				Gui_BitmapSurface_DrawImage(FrameSheet_Image[Tileset_FrameSheet], 0, 0)
				bsurf_isLoaded = True
				Map_SetLayer(0)
				OnLayerChange()
				'Set geometry_init
				For layer = 0 to MAX_LAYERS-1
					For sect = 0 to Map_NumSectors-1
						If Map_NumSectorGeometries[layer, sect] > 0 Then
							geometry_list_init[layer] = True
							Exit For
						End If
					Next
				Next
				Gui_HideWindow(status_win)
				Exit While
			ElseIf Gui_Button_Clicked(load_map_cancelButton) Then
				Gui_HideWindow(status_win)
				Exit While
			End If
			Gui_Render()
		Wend
		Gui_HideWindow(load_map_win)

	ElseIf Gui_Button_Clicked(load_map_cancelButton) Then
		Gui_HideWindow(load_map_win)
	ElseIf Gui_Button_Clicked(save_button) Then
		'Save Map
		Editor_SaveMap(Gui_TextField_GetText$(map_info_mapField))
		Print "Map Saved"
	ElseIf Gui_Button_Clicked(image_preview_loadButton) Then
		'Load Background Image
		'Print "Balls"
		OnLoadBkg()
		'Print "Break"
	ElseIf Gui_Button_Clicked(geometry_mode_button) Then
		Editor_Mode = EDIT_MODE_GEOMETRY
		Editor_Mode_Text$ = "GEOMETRY"
		Gui_CheckBox_SetState(map_setting_rShapeCheckBox, TRUE)
		Gui_Label_SetText(mode_label, Editor_Mode_Text$)
	ElseIf Gui_Button_Clicked(tile_mode_button) And edit_geometry_n_index = 0 Then
		Editor_Mode = EDIT_MODE_TILE
		Editor_Mode_Text$ = "TILE"
		Gui_Label_SetText(mode_label, Editor_Mode_Text$)
	ElseIf Gui_Button_Clicked(geometry_editButton) And geometry_list_count > 0 Then
		selected_geometry = geometry_list_index[Gui_ListBox_GetSelection(geometry_list)]
		g_type = Geometry_Type[selected_geometry]
		If g_type = GEOMETRY_LINE Then
			Gui_DropDown_SetSelection(edit_geometry_typeList, 0)
		ElseIf g_type = GEOMETRY_RECT Then
			Gui_DropDown_SetSelection(edit_geometry_typeList, 1)
		ElseIf g_type = GEOMETRY_CIRCLE Then
			Gui_DropDown_SetSelection(edit_geometry_typeList, 2)
		End If
		Gui_TextField_SetText(edit_geometry_field1, Str$(Geometry[selected_geometry,0]))
		Gui_TextField_SetText(edit_geometry_field2, Str$(Geometry[selected_geometry,1]))
		Gui_TextField_SetText(edit_geometry_field3, Str$(Geometry[selected_geometry,2]))
		Gui_TextField_SetText(edit_geometry_field4, Str$(Geometry[selected_geometry,3]))
		Gui_ShowWindow(edit_geometry_win)
	ElseIf Gui_Button_Clicked(geometry_removeButton) And geometry_list_count > 0 Then
		Map_Geometry_Remove()
		OnLayerChange()
	ElseIf Gui_Button_Clicked(edit_geometry_cancelButton) Then
		Gui_HideWindow(edit_geometry_win)
	ElseIf Gui_Button_Clicked(edit_geometry_saveButton) Then
		'Save Button
		g_type = Gui_DropDown_GetSelection(edit_geometry_typeList) + 1
		n1 = Int( Val(Gui_TextField_GetText(edit_geometry_field1)) )
		n2 = Int( Val(Gui_TextField_GetText(edit_geometry_field2)) )
		n3 = Int( Val(Gui_TextField_GetText(edit_geometry_field3)) )
		n4 = Int( Val(Gui_TextField_GetText(edit_geometry_field4)) )
		Map_Geometry_Edit(selected_geometry, g_type, n1, n2, n3, n4)
		Gui_HideWindow(edit_geometry_win)
	ElseIf Gui_Button_Clicked(tframe_left_button) Then
		Gui_ScrollPanel(tframe_slide_panel, -8, 0)
	ElseIf Gui_Button_Clicked(tframe_right_button) Then
		Gui_ScrollPanel(tframe_slide_panel, 8, 0)
	ElseIf Gui_Button_Clicked(tframe_adjust_addButton) Then
		If frame_clip_count < MAX_TILE_FRAMES Then
			frame_clip[frame_clip_count] = Gui_CreateImageClip(tframe_slide_panel, frame_clip_count*65, 0, 64, 64)
			frame_clip_count = frame_clip_count + 1
			TileSet_NumFrames[SelectedTile] = frame_clip_count
		End If
	ElseIf Gui_Button_Clicked(tframe_adjust_removeButton) Then
		If frame_clip_count > 0 Then
			frame_clip_count = frame_clip_count - 1
			Gui_DeleteImageClip(frame_clip[frame_clip_count])
			TileSet_NumFrames[SelectedTile] = frame_clip_count
		End If
	ElseIf Gui_Button_Clicked(tframe_adjust_selectButton) Then
		frame_clip_state = Not frame_clip_state
		If frame_clip_state Then
			Gui_Label_SetText(tframe_adjust_stateLabel, "[SELECT TILE]")
		Else
			Gui_Label_SetText(tframe_adjust_stateLabel, " ")
		End If
	ElseIf p = tframe_slide_panel Then
		If frame_clip_count > 0 Then
			For i = 0 to frame_clip_count-1
				If Gui_ImageClip_Clicked(frame_clip[i]) Then
					Selected_Frame_Clip = i
					Exit For
				End If
			Next
		End If
	End If

	If Gui_DropDown_GetSelection(map_setting_layerList) <> Map_CurrentLayer Then
		OnLayerChange()
	End If

	If Key(K_DOWN) then
		Gui_ScrollPanel(p, 0, 4)
	End If

	If Key(K_UP) Then
		Gui_ScrollPanel(p, 0, -4)
	End If

	If Key(K_RIGHT) Then
		Gui_ScrollPanel(p, 4, 0)
	End If

	If Key(K_LEFT) Then
		Gui_ScrollPanel(p, -4, 0)
	End If
	
	'Map Settings
	Map_SetLayerFlag(TILE_FLAG, Gui_CheckBox_GetState(map_setting_rtileCheckBox))
	Map_SetLayerFlag(IMAGE_FLAG, Gui_CheckBox_GetState(map_setting_rImageCheckBox))
	Map_SetLayerFlag(DRAW_FLAG, Gui_CheckBox_GetState(map_setting_rDrawCheckBox))
	Map_SetLayerFlag(GEOMETRY_FLAG, Gui_CheckBox_GetState(map_setting_rShapeCheckBox))
	ml_visible = Gui_CheckBox_GetState(map_setting_ActiveCheckBox)
	If ml_visible <> Map_Layer_isVisible[Map_CurrentLayer] Then
		If ml_visible Then
			Map_ShowLayer(Map_CurrentLayer)
		Else
			Map_HideLayer(Map_CurrentLayer)
		End If
		Map_Layer_isVisible[Map_CurrentLayer] = ml_visible
	End If
	Map_SetOffsetInterval(Map_CurrentLayer, Val(Gui_TextField_GetText$(map_setting_intervalField)))
	TileSet_SetFPS( Int( Val(Gui_TextField_GetText$(map_info_fpsField)) ))
End Sub

w_flag = false

while not key(k_escape)
	w_flag = false
	If WindowExists(MAP_WINDOW) Then
		If WindowHasMouseFocus(MAP_WINDOW) Then
			w_flag = true
		Else
			w_flag = false
		End If
	End If

	If w_flag Then
		Editor_Map_Events()
		Editor_Map_Render()
	Else
		Gui_GetEvents()
		'Event Code
		Editor_Gui_Events()
		Gui_Render()
	End If
	
	Update

	'Editor_Render()
	'Gui_Render()
wend

end
