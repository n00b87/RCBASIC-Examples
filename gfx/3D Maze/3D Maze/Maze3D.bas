MAX_VALUE = 2^1024

Dim Map_Grid[99, 99]

Sub LoadGrid(rows, cols)
	f = FreeFile
	FileOpen(f, "grid.txt", TEXT_INPUT)
	For i = 0 to rows-1
		s$ = ReadLine(f)
		For j = 0 to cols-1
			Map_Grid[i, j] = Val(Left(s, 1))
			s = Mid(s, 2, Len(s)-2)
		'Print "g[";i;", ";j;"] = ";Map_Grid[i,j]
		Next
		If EOF(f) Then: Exit For: End If
	Next
	FileClose(f)
End Sub

redbrick = 30

PI = 3.14159265359
PI_2 = PI * 2

TILE_SIZE = 32
MAP_NUM_ROWS = 11
MAP_NUM_COLS = 15

WINDOW_WIDTH = MAP_NUM_COLS * TILE_SIZE
WINDOW_HEIGHT = MAP_NUM_ROWS * TILE_SIZE

FOV_ANGLE = 60 * (PI / 180)

WALL_STRIP_WIDTH = 1
NUM_RAYS = WINDOW_WIDTH / WALL_STRIP_WIDTH

MINIMAP_SCALE_FACTOR = 0.2


'----FLOOR----------------------
Dim BUFFER_BACK
Dim BUFFER_DISPLAY
Dim BKG_IMAGE
Dim BKG_IMAGE_W
Dim BKG_IMAGE_H
Dim BKG_CENTER_X
Dim BKG_CENTER_Y
Dim WINDOW_CENTER_X
Dim WINDOW_CENTER_Y

BUFFER_BACK = 1
BUFFER_DISPLAY = 0

BKG_IMAGE = 0

WINDOW_CENTER_X = WINDOW_WIDTH/2
WINDOW_CENTER_Y = WINDOW_HEIGHT/2

Function CRadians(angle)
	Return angle * 0.0174533
End Function

Function GetFreeImage()
	For i = 0 to 1023
		If Not ImageExists(i) Then
			Return i
		End If
	Next
	Return -1
End Function

Sub LoadTexture(img_file$)
	'LoadImage(BKG_IMAGE, img_file)
	f = GetFreeImage()
	If f < 0 Then
		Print "No Image Available"
		End
	End If
	LoadImage(f, img_file$)
	Canvas(BUFFER_BACK)
	ClearCanvas
	SetColor(RGB(255,255,255))
	For y = 0 to MAP_NUM_ROWS-1
		For x = 0 to MAP_NUM_COLS-1
			DrawImage(f, x*64, y*64)
			'Line(x*64, y*64, x*64+64, y*64)
		Next
	Next
	DeleteImage(f)
	
	'SetColor(RGB(0,255,0))
	'RectFill(0,0,64,64)
	
	'SetColor(RGB(255,255,255))
	'RectFill((MAP_NUM_COLS-1)*64, (MAP_NUM_ROWS-1)*64, 64,64)
	
	CanvasClip(BKG_IMAGE, 0, 0, MAP_NUM_COLS*TILE_SIZE, MAP_NUM_ROWS*TILE_SIZE, 1)
	GetImageSize(BKG_IMAGE, BKG_IMAGE_W, BKG_IMAGE_H)
	BKG_CENTER_X = Int(BKG_IMAGE_W / 2)
	BKG_CENTER_Y = Int(BKG_IMAGE_H / 2)
End Sub

'-----------------------------------------------------------------------------------------


Function map_getWallContentAt(x, y)
	If (x < 0 OR x > WINDOW_WIDTH OR y < 0 OR y > WINDOW_HEIGHT) Then
		return 1
	End If
	
	mapGridIndexX = Int(x / TILE_SIZE)
	mapGridIndexY = Int(y / TILE_SIZE)
	Select Case Map_Grid[mapGridIndexY, mapGridIndexX]
	Case 0
		Return 0
	Case 5
		Return 0
	Default
		Return 1
	End Select
   
   Return Map_Grid[mapGridIndexY, mapGridIndexX]
End Function

Sub map_render()
	Dim TileColor
	for i = 0 to MAP_NUM_ROWS-1
		for j = 0 to MAP_NUM_COLS-1
            tileX = j * TILE_SIZE
            tileY = i * TILE_SIZE
            If Map_Grid[i, j] <> 0 Then
				TileColor = RGB(0,0,0)
			Else
				TileColor = RGB(255,255,255)
			End If
            SetColor(tileColor)
            rectFill(MINIMAP_SCALE_FACTOR * tileX, MINIMAP_SCALE_FACTOR * tileY, MINIMAP_SCALE_FACTOR * TILE_SIZE, MINIMAP_SCALE_FACTOR * TILE_SIZE)
			SetColor(RGB(0,0,0))
            rect(MINIMAP_SCALE_FACTOR * tileX, MINIMAP_SCALE_FACTOR * tileY, MINIMAP_SCALE_FACTOR * TILE_SIZE, MINIMAP_SCALE_FACTOR * TILE_SIZE)
         Next
     Next
End Sub

'Player
player_x = WINDOW_WIDTH / 2
player_y = WINDOW_HEIGHT / 7
player_radius = 8
player_turnDirection = 0 ' -1 if left, +1 if right
player_walkDirection = 0 ' -1 if back, +1 if front
player_rotationAngle = PI / 2
player_moveSpeed = 4.0
player_rotationSpeed = 3 * (PI / 180)

Sub rotatePoint(pt_x, pt_y, center_x, center_y, angleRad, ByRef x, Byref y)

    'angleRad = (angleDeg/180)*PI
    cosAngle = Cos(angleRad)
    sinAngle = Sin(angleRad)
    dx = (pt_x-center_x)
    dy = (pt_y-center_y)

    x = center_x + int(dx*cosAngle-dy*sinAngle)
    y = center_y + int(dx*sinAngle+dy*cosAngle)
End Sub


'Player Normalize

Function normalizeAngle(angle)
	If angle > PI_2 Then
		angle = angle / Int(angle / (2 * PI)) - (2 * PI)
   End If
    'print "angle: ";angle;" -- ";angle2
    If (angle < 0) Then
        angle = PI_2 + angle
    End If
    return angle
End Function
   
Sub player_update()
	player_rotationAngle = player_rotationAngle + player_turnDirection * player_rotationSpeed
	player_rotationAngle = normalizeAngle(player_rotationAngle)
	
	moveStep = player_walkDirection * player_moveSpeed
	
	newPlayerX = player_x + cos(player_rotationAngle) * moveStep
    newPlayerY = player_y + sin(player_rotationAngle) * moveStep

    If map_getWallContentAt(newPlayerX, newPlayerY) = 0 Then
		player_x = newPlayerX
        player_y = newPlayerY
    End If
End Sub

Sub player_render()
    SetColor(RGB(0,0,200))
    circle(MINIMAP_SCALE_FACTOR * player_x, MINIMAP_SCALE_FACTOR * player_y, MINIMAP_SCALE_FACTOR * player_radius)
	line(MINIMAP_SCALE_FACTOR * player_x, MINIMAP_SCALE_FACTOR * player_y, MINIMAP_SCALE_FACTOR * (player_x + cos(player_rotationAngle) * 30), MINIMAP_SCALE_FACTOR * (player_y + sin(player_rotationAngle) * 30))
End Sub

Function distanceBetweenPoints(x1, y1, x2, y2)
    return Sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1))
End Function

'Ray
NUM_RAYS = WINDOW_WIDTH
Dim Ray_rayAngle[NUM_RAYS]
Dim Ray_wallHitX[NUM_RAYS]
Dim Ray_wallHitY[NUM_RAYS]
Dim Ray_distance[NUM_RAYS]
Dim Ray_wasHitVertical[NUM_RAYS]
Dim Ray_hitWallColor[NUM_RAYS]
Dim Ray_isRayFacingDown[NUM_RAYS]
Dim Ray_isRayFacingUp[NUM_RAYS]
Dim Ray_isRayFacingRight[NUM_RAYS]
Dim Ray_isRayFacingLeft[NUM_RAYS]

'class Ray {
Sub Ray_Create(columnId, rayAngle)
	Ray_rayAngle[columnId] = normalizeAngle(rayAngle)
    
    Ray_wallHitX[columnId] = 0
    Ray_wallHitY[columnId] = 0
    Ray_distance[columnId] = 0
    Ray_wasHitVertical[columnId] = False
    Ray_hitWallColor[columnId] = 0

    Ray_isRayFacingDown[columnId] = Ray_rayAngle[columnId] > 0 And Ray_rayAngle[columnId] < PI
    Ray_isRayFacingUp[columnId] = Not Ray_isRayFacingDown[columnId]

    Ray_isRayFacingRight[columnId] = Ray_rayAngle[columnId] < 0.5 * PI Or Ray_rayAngle[columnId] > 1.5 * PI
    Ray_isRayFacingLeft[columnId] = Not Ray_isRayFacingRight[columnId]
End Sub

max_ray = 0
max_ray_distance = 0

Sub Ray_Cast(columnId)
	xintercept = 0 : yintercept = 0
	xstep = 0 : ystep = 0
	
	'///////////////////////////////////////////
	'// HORIZONTAL RAY-GRID INTERSECTION CODE
	'///////////////////////////////////////////
	foundHorzWallHit = false
	horzWallHitX = 0
	horzWallHitY = 0
	horzWallColor = 0

	'// Find the y-coordinate of the closest horizontal grid intersenction
	yintercept = Int(player_y / TILE_SIZE) * TILE_SIZE
	If Ray_isRayFacingDown[columnId] Then
		yintercept = yintercept + TILE_SIZE
	End If

	'// Find the x-coordinate of the closest horizontal grid intersection
	xintercept = player_x + (yintercept - player_y) / Tan(Ray_rayAngle[columnId])
	

	'// Calculate the increment xstep and ystep
	ystep = TILE_SIZE
	If Ray_isRayFacingUp[columnId] Then
		ystep = ystep *  -1
	End If

	xstep = TILE_SIZE / Tan(Ray_rayAngle[columnId])
	If Ray_isRayFacingLeft[columnId] And xstep > 0 Then
		xstep = xstep * -1
	End If
	
	If Ray_isRayFacingRight[columnId] And xstep < 0 Then
		xstep = xstep * -1
	End If

	nextHorzTouchX = xintercept
	nextHorzTouchY = yintercept

	If Ray_isRayFacingUp[columnId] Then
	    nextHorzTouchY = nextHorzTouchY - 1
	End If

	'// Increment xstep and ystep until we find a wall
	While nextHorzTouchX >= 0 And nextHorzTouchX <= WINDOW_WIDTH And nextHorzTouchY >= 0 And nextHorzTouchY <= WINDOW_HEIGHT
	    wallGridContent = map_getWallContentAt(nextHorzTouchX, nextHorzTouchY)
	    If wallGridContent <> 0 Then
			foundHorzWallHit = true
			horzWallHitX = nextHorzTouchX
			horzWallHitY = nextHorzTouchY
			horzWallColor = wallGridContent
			Exit While
	    Else
			nextHorzTouchX = nextHorzTouchX + xstep
			nextHorzTouchY = nextHorzTouchY + ystep
		End If
	Wend

	'///////////////////////////////////////////
	'// VERTICAL RAY-GRID INTERSECTION CODE
	'///////////////////////////////////////////
	foundVertWallHit = false
	vertWallHitX = 0
	vertWallHitY = 0
	vertWallColor = 0

	'// Find the x-coordinate of the closest vertical grid intersenction
	xintercept = Int(player_x / TILE_SIZE) * TILE_SIZE
	If Ray_isRayFacingRight[columnId] Then
		xintercept = xintercept + TILE_SIZE
	End If

	'// Find the y-coordinate of the closest vertical grid intersection
	yintercept = player_y + (xintercept - player_x) * Tan(Ray_rayAngle[columnId])

	'// Calculate the increment xstep and ystep
	xstep = TILE_SIZE
	If Ray_isRayFacingLeft[columnId] Then
		xstep = xstep * -1
	End If

	ystep = TILE_SIZE * Tan(Ray_rayAngle[columnId])
	If Ray_isRayFacingUp[columnId] And ystep > 0 Then
		ystep = ystep * -1
	End If
	
	If Ray_isRayFacingDown[columnId] And ystep < 0 Then
		ystep = ystep * -1
	End If

	nextVertTouchX = xintercept
	nextVertTouchY = yintercept

	If Ray_isRayFacingLeft[columnId] Then
	    nextVertTouchX = nextVertTouchX - 1
	End If

	'// Increment xstep and ystep until we find a wall
	While nextVertTouchX >= 0 And nextVertTouchX <= WINDOW_WIDTH And nextVertTouchY >= 0 And nextVertTouchY <= WINDOW_HEIGHT
	    wallGridContent = map_getWallContentAt(nextVertTouchX, nextVertTouchY)
	    If wallGridContent <> 0 Then
			foundVertWallHit = true
			vertWallHitX = nextVertTouchX
			vertWallHitY = nextVertTouchY
			vertWallColor = wallGridContent
			Exit While
		Else
			nextVertTouchX = nextVertTouchX + xstep
			nextVertTouchY = nextVertTouchY + ystep
	    End If
	Wend
	
	Dim horzHitDistance
	Dim vertHitDistance

	'// Calculate both horizontal and vertical distances and choose the smallest value
	If (foundHorzWallHit) Then
		horzHitDistance = distanceBetweenPoints(player_x, player_y, horzWallHitX, horzWallHitY)
	Else
		horzHitDistance = MAX_VALUE
	End If
	
	If foundVertWallHit Then
		vertHitDistance = distanceBetweenPoints(player_x, player_y, vertWallHitX, vertWallHitY)
	Else
		vertHitDistance = MAX_VALUE
	End If

	'// only store the smallest of the distances
	If vertHitDistance < horzHitDistance Then
	    Ray_wallHitX[columnId] = vertWallHitX
	    Ray_wallHitY[columnId] = vertWallHitY
	    Ray_distance[columnId] = vertHitDistance
	    Ray_hitWallColor[columnId] = vertWallColor
	    Ray_wasHitVertical[columnId] = true
	Else
	    Ray_wallHitX[columnId] = horzWallHitX
	    Ray_wallHitY[columnId] = horzWallHitY
	    Ray_distance[columnId] = horzHitDistance
	    Ray_hitWallColor[columnId] = horzWallColor
	    Ray_wasHitVertical[columnId] = false
	End If
	
	nx = 0
	ny = 0
	
	rotatePoint(Ray_wallHitX[columnId], Ray_wallHitY[columnId], player_x, player_y, 0 - player_rotationAngle, nx, ny)
	
	If nx > max_ray_distance Then
		max_ray = columnId
		max_ray_distance = nx
	End If
	
End Sub

Sub Ray_render(columnId)
	SetColor(rgba(255, 0, 0, 255))
    line(MINIMAP_SCALE_FACTOR * player_x,  MINIMAP_SCALE_FACTOR * player_y,  MINIMAP_SCALE_FACTOR * Ray_wallHitX[columnId],  MINIMAP_SCALE_FACTOR * Ray_wallHitY[columnId])
End Sub


Function keyPressed()
    If key(K_UP) Then
        player_walkDirection = 1
    ElseIf key(K_DOWN) Then
        player_walkDirection = -1
    End If
    
    If key(K_RIGHT) Then
        player_turnDirection = 1
    ElseIf key(K_LEFT) Then
        player_turnDirection = -1
    End If
End Function

Function keyReleased()
    If Not (key(K_UP) Or Key(K_DOWN)) Then
        player_walkDirection = 0
    End If
    
    If Not (key(K_RIGHT) Or Key(K_LEFT)) Then
        player_turnDirection = 0
    End If
End Function

Function castAllRays()
    
    max_ray = 0
    max_ray_distance = 0
    
    '// start first ray subtracting half of the FOV
    rayAngle = player_rotationAngle - (FOV_ANGLE / 2)

    '// loop all columns casting the rays
    For columnId = 0 To NUM_RAYS-1
        Ray_Create(columnId, rayAngle)
        Ray_Cast(columnId)
        
        rayAngle = rayAngle + (FOV_ANGLE / NUM_RAYS)
    Next
    
End Function

Function render3DProjectedWalls()
    '// loop every ray in the array of rays
    For i = 0 To NUM_RAYS-1
        
        '// get the perpendicular distance to the wall to fix fishbowl distortion
        correctWallDistance = Ray_distance[i] * Cos(Ray_rayAngle[i] - player_rotationAngle)

        '// calculate the distance to the projection plane
        distanceProjectionPlane = (WINDOW_WIDTH / 2) / Tan(FOV_ANGLE / 2)

        '// projected wall height
        wallStripHeight = (TILE_SIZE / correctWallDistance) * distanceProjectionPlane

        '// compute the transparency based on the wall distance
        alpha = Min( 255, 255 * (200 / correctWallDistance))
        'Print correctWallDistance

        '// set the correct color based on the wall hit grid content (1=Red, 2=Green, 3=Blue)
        colorR = 255
        colorG = 255
        colorB = 255
        tex = -1
        If ray_hitWallColor[i] = 1 Then
			colorR = 255
			colorG = 0
			colorB = 0
		ElseIf ray_hitWallColor[i] = 2 Then
			colorR = 0
			colorG = 255
			colorB = 0
		ElseIf ray_hitWallColor[i] = 3 Then
			colorR = 0
			colorG = 0
			colorB = 255
		ElseIf ray_hitWallColor[i] = 5 Then
			tex = 0
		End If
		tex = 0
		If tex >= 0 Then
			If Ray_wasHitVertical[i] Then
				column_offset = Ray_wallHitY[i] MOD TILE_SIZE
				x = i * WALL_STRIP_WIDTH
				y = (WINDOW_HEIGHT / 2) - (wallStripHeight / 2)
				w = WALL_STRIP_WIDTH
				h = wallStripHeight
				iw = TILE_SIZE
				ih = TILE_SIZE
				DrawImage_Blit_Ex(redbrick, x, y, w, h, column_offset, 0, 1, ih)
			Else
				column_offset = Ray_wallHitX[i] MOD TILE_SIZE
				x = i * WALL_STRIP_WIDTH
				y = (WINDOW_HEIGHT / 2) - (wallStripHeight / 2)
				w = WALL_STRIP_WIDTH
				h = wallStripHeight
				iw = TILE_SIZE
				ih = TILE_SIZE
				DrawImage_Blit_Ex(redbrick, x, y, w, h, column_offset, 0, 1, ih)
			End If
		Else
			SetColor(rgba(colorR , colorG , colorB, alpha ))
			'// render a rectangle with the calculated wall height
			Rect(i * WALL_STRIP_WIDTH, (WINDOW_HEIGHT / 2) - (wallStripHeight / 2), WALL_STRIP_WIDTH, wallStripHeight)
		End If
    Next
End Function

WIN_W = 960
WIN_H = 704

Include "floor.bas"

Function setup()
	WIN_W = 960
	WIN_H = 704
    WindowOpen(0, "Raycast", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, WIN_W, WIN_H, WINDOW_VISIBLE, 1)
    CanvasOpen(0, WIN_W, WIN_H, 0, 0, WIN_W, WIN_H, 1)
    CanvasOpen(BUFFER_BACK, WIN_W, WIN_H, 0, 0, WIN_W, WIN_H, 0)
    
	SetCanvasVisible(BUFFER_BACK, False)
    
    LoadImage(redbrick, "redbrick.png")
    LoadTexture("colorstone.png")
    
    InitFloorGrid
    
    'TILE_SIZE = 64
	MAP_NUM_ROWS = 11
	MAP_NUM_COLS = 15
    LoadGrid(11, 15)
End Function

Function game_update()
    player_update()
    castAllRays()
End Function

Function draw()
	game_update()
	
	Canvas(0)
	ClearCanvas
	
	DrawFloor

    render3DProjectedWalls()

    map_render()
    
    For i = 0 to NUM_RAYS-1
        Ray_render(i)
    Next
    
    player_render()
    
    f = GetFreeImage
    CanvasClip(f, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, 1)
    DrawImage_Blit_Ex(f, 0, 0, WIN_W, WIN_H, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
    DeleteImage(f)
    
End Function

setup

While Not Key(K_ESCAPE)
	keyPressed
	keyReleased
	draw
	
	Update
Wend

wait(500)
