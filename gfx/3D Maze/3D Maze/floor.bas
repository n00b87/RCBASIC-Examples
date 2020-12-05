
'Floor_Ray
NUM_FLOOR_RAYS = WINDOW_WIDTH/2
Dim Floor_Ray_rayAngle[NUM_FLOOR_RAYS]
Dim Floor_Ray_wallHitX[NUM_FLOOR_RAYS]
Dim Floor_Ray_wallHitY[NUM_FLOOR_RAYS]
Dim Floor_Ray_distance[NUM_FLOOR_RAYS]
Dim Floor_Ray_wasHitVertical[NUM_FLOOR_RAYS]
Dim Floor_Ray_hitWallColor[NUM_FLOOR_RAYS]
Dim Floor_Ray_isFloor_RayFacingDown[NUM_FLOOR_RAYS]
Dim Floor_Ray_isFloor_RayFacingUp[NUM_FLOOR_RAYS]
Dim Floor_Ray_isFloor_RayFacingRight[NUM_FLOOR_RAYS]
Dim Floor_Ray_isFloor_RayFacingLeft[NUM_FLOOR_RAYS]
Dim Floor_Ray_stripHeight[NUM_FLOOR_RAYS]

Dim Floor_Player_X
Dim Floor_Player_Y
Dim Floor_Player_Radius
Dim Floor_Player_TurnDirection
Dim Floor_Player_WalkDirection
Dim Floor_Player_RotationAngle
Dim Floor_Player_MoveSpeed
Dim Floor_Player_RotationSpeed

'Floor Player
Floor_Player_X = TILE_SIZE*3/2
Floor_Player_Y = 0
Floor_Player_Radius = 8
Floor_Player_TurnDirection = 0 ' -1 if left, +1 if right
Floor_Player_WalkDirection = 0 ' -1 if back, +1 if front
Floor_Player_RotationAngle = Radians(90)
Floor_Player_MoveSpeed = 4.0
Floor_Player_RotationSpeed = 3 * (PI / 180)

Sub Floor_Ray_Create(columnId, rayAngle)
	Floor_Ray_rayAngle[columnId] = normalizeAngle(rayAngle)
    
    Floor_Ray_wallHitX[columnId] = 0
    Floor_Ray_wallHitY[columnId] = 0
    Floor_Ray_distance[columnId] = 0
    Floor_Ray_wasHitVertical[columnId] = False
    Floor_Ray_hitWallColor[columnId] = 0

    Floor_Ray_isFloor_RayFacingDown[columnId] = Floor_Ray_rayAngle[columnId] > 0 And Floor_Ray_rayAngle[columnId] < PI
    Floor_Ray_isFloor_RayFacingUp[columnId] = Not Floor_Ray_isFloor_RayFacingDown[columnId]

    Floor_Ray_isFloor_RayFacingRight[columnId] = Floor_Ray_rayAngle[columnId] < 0.5 * PI Or Floor_Ray_rayAngle[columnId] > 1.5 * PI
    Floor_Ray_isFloor_RayFacingLeft[columnId] = Not Floor_Ray_isFloor_RayFacingRight[columnId]
End Sub

Sub Floor_Ray_Cast(columnId)
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
	yintercept = Int(Floor_Player_Y / TILE_SIZE) * TILE_SIZE
	If Floor_Ray_isFloor_RayFacingDown[columnId] Then
		yintercept = yintercept + TILE_SIZE
	End If

	'// Find the x-coordinate of the closest horizontal grid intersection
	xintercept = Floor_Player_X + (yintercept - Floor_Player_Y) / Tan(Floor_Ray_rayAngle[columnId])
	

	'// Calculate the increment xstep and ystep
	ystep = TILE_SIZE
	If Floor_Ray_isFloor_RayFacingUp[columnId] Then
		ystep = ystep *  -1
	End If

	xstep = TILE_SIZE / Tan(Floor_Ray_rayAngle[columnId])
	If Floor_Ray_isFloor_RayFacingLeft[columnId] And xstep > 0 Then
		xstep = xstep * -1
	End If
	
	If Floor_Ray_isFloor_RayFacingRight[columnId] And xstep < 0 Then
		xstep = xstep * -1
	End If

	nextHorzTouchX = xintercept
	nextHorzTouchY = yintercept

	If Floor_Ray_isFloor_RayFacingUp[columnId] Then
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
	xintercept = Int(Floor_Player_x / TILE_SIZE) * TILE_SIZE
	If Floor_Ray_isFloor_RayFacingRight[columnId] Then
		xintercept = xintercept + TILE_SIZE
	End If

	'// Find the y-coordinate of the closest vertical grid intersection
	yintercept = Floor_Player_Y + (xintercept - Floor_Player_X) * Tan(Floor_Ray_rayAngle[columnId])

	'// Calculate the increment xstep and ystep
	xstep = TILE_SIZE
	If Floor_Ray_isFloor_RayFacingLeft[columnId] Then
		xstep = xstep * -1
	End If

	ystep = TILE_SIZE * Tan(Floor_Ray_rayAngle[columnId])
	If Floor_Ray_isFloor_RayFacingUp[columnId] And ystep > 0 Then
		ystep = ystep * -1
	End If
	
	If Floor_Ray_isFloor_RayFacingDown[columnId] And ystep < 0 Then
		ystep = ystep * -1
	End If

	nextVertTouchX = xintercept
	nextVertTouchY = yintercept

	If Floor_Ray_isFloor_RayFacingLeft[columnId] Then
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
		horzHitDistance = distanceBetweenPoints(Floor_Player_x, Floor_Player_y, horzWallHitX, horzWallHitY)
	Else
		horzHitDistance = MAX_VALUE
	End If
	
	If foundVertWallHit Then
		vertHitDistance = distanceBetweenPoints(Floor_Player_x, Floor_Player_y, vertWallHitX, vertWallHitY)
	Else
		vertHitDistance = MAX_VALUE
	End If

	'// only store the smallest of the distances
	If vertHitDistance < horzHitDistance Then
	    Floor_Ray_wallHitX[columnId] = vertWallHitX
	    Floor_Ray_wallHitY[columnId] = vertWallHitY
	    Floor_Ray_distance[columnId] = vertHitDistance
	    Floor_Ray_hitWallColor[columnId] = vertWallColor
	    Floor_Ray_wasHitVertical[columnId] = true
	Else
	    Floor_Ray_wallHitX[columnId] = horzWallHitX
	    Floor_Ray_wallHitY[columnId] = horzWallHitY
	    Floor_Ray_distance[columnId] = horzHitDistance
	    Floor_Ray_hitWallColor[columnId] = horzWallColor
	    Floor_Ray_wasHitVertical[columnId] = false
	End If
	
End Sub

Dim Floor_X[NUM_FLOOR_RAYS]
Dim Floor_Y[NUM_FLOOR_RAYS]
Dim Floor_H[NUM_FLOOR_RAYS]

Dim Floor_TX[NUM_FLOOR_RAYS]
Dim Floor_TY[NUM_FLOOR_RAYS]

Dim Floor_Row_Count

Function castAllFloor_Rays()
    
    '// start first ray subtracting half of the FOV
    rayAngle = Floor_Player_RotationAngle - (FOV_ANGLE / 2)
	
	Floor_Player_Y = 0
	
	Floor_Row_Count = 0
	
	n = 0
    
    '// loop all columns casting the rays
    For columnId = 0 To NUM_FLOOR_RAYS-1
        
        Floor_Ray_Create(columnId, rayAngle)
        Floor_Ray_Cast(columnId)
        
        '// get the perpendicular distance to the wall to fix fishbowl distortion
        correctWallDistance = Floor_Ray_distance[columnId] * Cos(Floor_Ray_rayAngle[columnId] - Floor_Player_RotationAngle)

        '// calculate the distance to the projection plane
        distanceProjectionPlane = (WINDOW_WIDTH / 2) / Tan(FOV_ANGLE / 2)

        '// projected wall height
        wallStripHeight = (TILE_SIZE / correctWallDistance) * distanceProjectionPlane
        
        If Floor_Ray_wasHitVertical[columnId] and wallStRipHeight < WINDOW_HEIGHT Then
			Floor_Y[n] = Int(WINDOW_HEIGHT/2 + walLStripHeight/2)
			Floor_TY[n] = Int(Floor_Ray_wallHitY[columnId])
			
			hyp = Int(Floor_TY[n] / sin(Floor_Player_RotationAngle - FOV_ANGLE/2))
			adj = Sqrt(hyp^2 - Floor_TY[n]^2)
			
			Floor_TX[n] = Int(0 - adj)
			
			Floor_Row_Count = Floor_Row_Count + 1
			Floor_H[n] = 1
			n = n + 1
		End If
        
        rayAngle = rayAngle + (FOV_ANGLE / NUM_RAYS)
    Next
    
    n = 0
    
    tmp_y = Floor_TY[0]
    y = Floor_Y[0]
    tmp_x = Floor_TX[0]
    
    For i = 1 to Floor_Row_Count - 1
		If Floor_TY[i] = tmp_y Then
			Floor_H[n] = Floor_H[n] + 1
			y = Floor_Y[i]
			tmp_x = Floor_TX[i]
		Else
			Floor_Y[n] = y
			Floor_TX[n] = tmp_x
			Floor_TY[n] = tmp_y
			n = n + 1
			y = Floor_Y[i]
			tmp_y = Floor_TY[i]
			tmp_x = Floor_TX[i]
		End If
	Next
    
    Floor_Row_Count = n
    
    PRINT N
    
End Function


Sub InitFloorGrid()
	
	Map_Grid[0, 0] = 1
	Map_Grid[0, 1] = 0
	Map_Grid[0, 2] = 1
	
	For r = 0 to 97
		Map_Grid[r, 0] = 1
		Map_Grid[r, 1] = 0
		Map_Grid[r, 2] = 1
	Next
	
	Map_Grid[98, 0] = 1
	Map_Grid[98, 1] = 1
	Map_Grid[98, 2] = 1
	
	FLOOR_TILE_SIZE = TILE_SIZE
	FLOOR_MAP_NUM_ROWS = 99
	FLOOR_MAP_NUM_COLS = 3
	
	castAllFloor_Rays
End Sub

Sub DrawFloor()
	
	c_w = WINDOW_WIDTH
	c_h = WINDOW_HEIGHT
	center_x = c_w/2
	center_y = c_h/2
	
	zoom = 0.5
	
	w = 0 : h = 0
	GetImageSize(BKG_IMAGE, w, h)
	
	w = w*zoom
	h = h*zoom
	
	offset_x = center_x - w/2
	offset_y = center_y - h/2
	
	'-------Get Display Image----------------------------------------
	Canvas(1)
	ClearCanvas
	
	px = player_x * zoom
	py = player_y * zoom
		
	floor_angle = Radians(270) - player_rotationAngle
	
	DrawImage_RotoZoom(BKG_IMAGE, offset_x, offset_y, Degrees(floor_angle), zoom, zoom)

	nx = 0 : ny = 0
	t_angle = Radians(270)
	
	rotatePoint(px+offset_x, py+offset_y, center_x, center_y, floor_angle, nx, ny)
	
	hyp = ny / sin(t_angle - FOV_ANGLE/2)
	adj = Sqrt(hyp^2 - ny^2)
	
	floor_image = GetFreeImage
	fx = nx - adj
	fy = 0
	fw = adj*2
	fh = ny

	CanvasClip(floor_image, fx, fy, fw, fh, 1)
	'ClearCanvas
	
	Canvas(0)
	GetImageSize(floor_image, nx, ny)
	
	nx = nx / 2
	
	center_x = nx
	
	SetColor(RGB(60,60,60))
	RectFill(0, WINDOW_CENTER_Y, WINDOW_WIDTH, WINDOW_HEIGHT/4)
	
	for i = 0 to Floor_Row_Count-1
		
		tx = center_x + Int(Floor_TX[i]*zoom)
		ty = ny - Int(Floor_TY[i]*zoom)
		tw = abs(Floor_TX[i]*zoom)*2
		th = 1
		
		x = 0
		y = Floor_Y[i]
		w = WINDOW_WIDTH
		h = Floor_H[i] + 1
		
		If ty < 0 or ty > ny then
			exit for
		end if
		
		DrawImage_Blit_Ex(floor_image, x, y, w, h, tx, ty, tw, th)
	next
	
	DeleteImage(floor_image)
	
End Sub
