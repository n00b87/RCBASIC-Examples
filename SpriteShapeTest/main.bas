Include "shapes.bas"

title$ = "Simple 3D Game"
w = 640
h = 480
fullscreen = FALSE
vsync = FALSE

'Open a graphics window
OpenWindow( title$, w, h, fullscreen, vsync )

mono_font = LoadFont("FreeMono.ttf", 12)

sprite_canvas = OpenCanvasSpriteLayer(0, 0, w, h)
shape_overlay_canvas = OpenCanvas(w, h, 0, 0, w, h, 1)
text_overlay_canvas = OpenCanvas(w, h, 0, 0, w, h, 1)
bkg_canvas = OpenCanvas(w, h, 0, 0, w, h, 1)

Canvas(text_overlay_canvas)
SetColor(RGB(255,255,255))
DrawText("Press 1 to change object to Box", 10, 10)
DrawText("Press 2 to change object to Polygon", 10, 30)
DrawText("Press 3 to change object to Circle", 10, 50)
DrawText("Press 4 to change ground to Box", 10, 90)
DrawText("Press 5 to change ground to Chain", 10, 110)

Canvas(sprite_canvas)

obj_img = LoadImage("test_obj.png")
obj = CreateSprite(obj_img, 64, 64)

ground = CreateSprite(-1, 300, 64)

SetSpritePosition(obj, 300, 10)
SetSpriteSolid(obj, TRUE)
SetSpriteType(obj, SPRITE_TYPE_DYNAMIC)

SetSpritePosition(ground, 170, 300)
SetSpriteType(ground, SPRITE_TYPE_STATIC)
SetSpriteSolid(ground, TRUE)

Canvas(bkg_canvas)
SetColor(RGB(255,0,0))
Rect(170, 300, 300, 64)

Canvas(sprite_canvas)

Dim poly_vert[5] As Vertex

poly_vert[0] = CreateVertex(-32, -32)
poly_vert[1] = CreateVertex(-32, 32)
poly_vert[2] = CreateVertex(32, 32)

Dim chain_vert[5] As Vertex
chain_vert[0] = CreateVertex(-300, 30)
chain_vert[1] = CreateVertex(-200, 70)
chain_vert[2] = CreateVertex(100, 50)
chain_vert[3] = CreateVertex(200, 70)
chain_vert[4] = CreateVertex(300, 20)

SetGravity2D(0, 30)

While Not Key(K_ESCAPE)
	Canvas(sprite_canvas)
	If Key(K_1) Then
		SetSpriteCollisionShape(obj, SPRITE_SHAPE_BOX)
		SetSpriteBox(obj, 64, 64)
		SetSpritePosition(obj, 300, 10)
	ElseIf Key(K_2) Then
		SetPolyShape(obj, poly_vert[0], 3)
		SetSpritePosition(obj, 300, 10)
	ElseIf Key(K_3) Then
		SetSpriteCollisionShape(obj, SPRITE_SHAPE_CIRCLE)
		SetSpriteRadius(obj, 32)
		SetSpritePosition(obj, 300, 10)
	ElseIf Key(K_4) Then
		SetSpriteCollisionShape(ground, SPRITE_SHAPE_BOX)
		SetSpriteBox(ground, 300, 64)
		SetSpritePosition(ground, 170, 300)
		Canvas(bkg_canvas)
		ClearCanvas
		SetColor(RGB(255,0,0))
		Rect(170, 300, 300, 64)
		SetSpriteType(ground, SPRITE_TYPE_STATIC)
	ElseIf Key(K_5) Then
		SetChainShape(ground, chain_vert[0], 5)
		
		Canvas(bkg_canvas)
		ClearCanvas
		SetColor(RGB(255,0,0))
		Dim gx, gy
		GetSpritePosition(ground, gx, gy)
		gx = gx + 150 'Add half frame_width
		gy = gy + 32 'Add half frame_height
		Line(chain_vert[0].x + gx, chain_vert[0].y + gy, chain_vert[1].x + gx, chain_vert[1].y + gy)
		Line(chain_vert[1].x + gx, chain_vert[1].y + gy, chain_vert[2].x + gx, chain_vert[2].y + gy)
		Line(chain_vert[2].x + gx, chain_vert[2].y + gy, chain_vert[3].x + gx, chain_vert[3].y + gy)
		Line(chain_vert[3].x + gx, chain_vert[3].y + gy, chain_vert[4].x + gx, chain_vert[4].y + gy)
		SetSpriteType(ground, SPRITE_TYPE_STATIC)
	End If
	
	Canvas(sprite_canvas)
	
	If Key(K_RIGHT) Then
		SetSpriteAngularVelocity(obj, 30)
	ElseIf Key(K_LEFT) Then
		SetSpriteAngularVelocity(obj, -30)
	End If
	
	PreUpdate
	
	Canvas(shape_overlay_canvas)
	ClearCanvas
	SetColor(RGB(255,255,255))
	Dim obj_x, obj_y
	GetSpritePosition(obj, obj_x, obj_y)
	obj_angle = GetSpriteRotation(obj)
	
	Select Case GetSpriteCollisionShape(obj)
	Case SPRITE_SHAPE_BOX
		obj_angle = obj_angle * -1 'RotatePoint2D expects this angle in reverse
		obj_x = obj_x + 32
		obj_y = obj_y + 32
		Dim tmp_v As Vertex
		
		tmp_v = RotatePoint2D(-32, -32, 0, 0, obj_angle)
		x1 = tmp_v.x + obj_x
		y1 = tmp_v.y + obj_y
		
		tmp_v = RotatePoint2D(-32, 32, 0, 0, obj_angle)
		x2 = tmp_v.x + obj_x
		y2 = tmp_v.y + obj_y
		
		tmp_v = RotatePoint2D(32, 32, 0, 0, obj_angle)
		x3 = tmp_v.x + obj_x
		y3 = tmp_v.y + obj_y
		
		tmp_v = RotatePoint2D(32, -32, 0, 0, obj_angle)
		x4 = tmp_v.x + obj_x
		y4 = tmp_v.y + obj_y
		
		Line(x1, y1, x2, y2)
		Line(x2, y2, x3, y3)
		Line(x3, y3, x4, y4)
		Line(x4, y4, x1, y1)
	Case SPRITE_SHAPE_POLYGON
		obj_angle = obj_angle * -1 'RotatePoint2D expects this angle in reverse
		obj_x = obj_x + 32
		obj_y = obj_y + 32
		Dim tmp_v As Vertex
		
		tmp_v = RotatePoint2D(poly_vert[0].x, poly_vert[0].y, 0, 0, obj_angle)
		x1 = tmp_v.x + obj_x
		y1 = tmp_v.y + obj_y
		
		tmp_v = RotatePoint2D(poly_vert[1].x, poly_vert[1].y, 0, 0, obj_angle)
		x2 = tmp_v.x + obj_x
		y2 = tmp_v.y + obj_y
		
		tmp_v = RotatePoint2D(poly_vert[2].x, poly_vert[2].y, 0, 0, obj_angle)
		x3 = tmp_v.x + obj_x
		y3 = tmp_v.y + obj_y
		Line(x1, y1, x2, y2)
		Line(x2, y2, x3, y3)
		Line(x3, y3, x1, y1)
		
	Case SPRITE_SHAPE_CIRCLE
		obj_x = obj_x + 32
		obj_y = obj_y + 32
		Circle(obj_x, obj_y, 32)
	End Select
	
	Update
	
Wend
