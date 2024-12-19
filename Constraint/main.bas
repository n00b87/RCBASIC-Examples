'----------------------------------------------------------------
'   TITLE: 3D Constraint Demo
'   AUTHOR: n00b
'   DATE: Dec 13, 2024
'
'   DESCRIPTION: Shows how to use a constraint to limit actors
'                motion
'----------------------------------------------------------------

sub cam_control(cam_canvas)
	current_canvas = ActiveCanvas()
	If Key(K_W) Then
		Canvas(cam_canvas)
		TranslateCamera(0,0,10)
    ElseIf Key(K_S) Then
		Canvas(cam_canvas)
		TranslateCamera(0,0,-10)
	End If

	If Key(K_A) Then 
		Canvas(cam_canvas)
		TranslateCamera(-10,0,0)
	ElseIf Key(K_D) Then
		Canvas(cam_canvas)
		TranslateCamera(10,0,0)
	End If

	If Key(K_R) Then
		Canvas(cam_canvas)
		Dim crx, cry, crz
		GetCameraPosition(crx, cry, crz)
		SetCameraPosition(crx, cry+10, crz)
	ElseIf Key(K_F) Then
		Canvas(cam_canvas)
		'TranslateCameraW(0, -10, 0) - Haven't added this function yet
		Dim crx, cry, crz
		GetCameraPosition(crx, cry, crz)
		SetCameraPosition(crx, cry-10, crz)
	End If


	If Key(K_UP) Then
		Canvas(cam_canvas)
		RotateCamera(1, 0, 0)
	ElseIf Key(K_DOWN) Then
		Canvas(cam_canvas)
		RotateCamera(-1, 0, 0)
	End If

	If Key(K_LEFT) Then
		Canvas(cam_canvas)
		Dim crx, cry, crz
		GetCameraRotation(crx, cry, crz)

		RotateCamera(-1*crx, 0, 0)
		RotateCamera(0, -1, 0)
		RotateCamera(crx, 0, 0)
	ElseIf Key(K_RIGHT) Then
		Canvas(cam_canvas)
		Dim crx, cry, crz
		GetCameraRotation(crx, cry, crz)
		SetCameraRotation(crx, cry+1, crz)
	End If
	
	Canvas(current_canvas)
end sub

window_width = 640
window_height= 480
fullscreen = false
vsync = true

OpenWindow( "Constraint Demo", window_width, window_height, fullscreen, vsync )

scene_canvas = OpenCanvas3D(0, 0, window_width, window_height, 0)
ui_canvas = OpenCanvas(window_width, window_height, 0, 0, window_width, window_height, 0)
SetCanvasZ(ui_canvas, 0)

Canvas(ui_canvas)
ClearCanvas()
m_font = LoadFont("FreeMono.ttf", 12)
SetFont(m_font)
SetColor(RGB(255,255,255))
DrawText("W/A/S/D TO MOVE", 10, 10)
DrawText("R/F TO MOVE UP AND DOWN", 10, 30)
DrawText("ARROW KEYS TO TURN", 10, 50)

Canvas(scene_canvas)

ground = CreateCubeActor(10)
ground_material = GetActorMaterial(ground, 0)
SetMaterialLighting(ground_material, true)
SetMaterialEmissiveColor(ground_material, RGB(0,200,0))
ScaleActor(ground, 50, 1, 50)
SetActorSolid(ground, true)
SetActorCollisionShape(ground, SHAPE_TYPE_BOX, 0)
RotateActor(ground, 0, 0, 45)

ground2 = CreateCubeActor(10)
ground2_material = GetActorMaterial(ground2, 0)
SetMaterialLighting(ground2_material, true)
SetMaterialEmissiveColor(ground2_material, RGB(0,120,0))
ScaleActor(ground2, 100, 1, 100)
SetActorSolid(ground2, true)
SetActorCollisionShape(ground2, SHAPE_TYPE_BOX, 0)
TranslateActorWorld(ground, 0, 300, 0)

sphere = CreateSphereActor(30)
sphere_material = GetActorMaterial(sphere, 0)
SetMaterialLighting(sphere_material, true)
SetMaterialEmissiveColor(sphere_material, RGB(200,0,0))
TranslateActorWorld(sphere, 0, 300, 0)
SetActorSolid(sphere, true)
SetActorCollisionShape(sphere, SHAPE_TYPE_SPHERE, 10)
Dim sphere_gx, sphere_gy, sphere_gz
GetActorGravity(sphere, sphere_gx, sphere_gy, sphere_gz)
SetActorGravity(sphere, sphere_gx, sphere_gy*30, sphere_gz)

ApplyActorCentralImpulseLocal(sphere, 0, 0, 20)

ground_sphere_constraint = createPointConstraintEx( sphere,  ground,  0,  120,  0,  0,  0,  0)

Canvas(scene_canvas)
SetCameraPosition(-560, 150, -608)
SetCameraRotation(0, 40, 0)

t = Timer()
While Timer()-t < 1000: PreUpdate(): Wend


While Not Key(K_ESCAPE)
	If key(K_1) Then
		DeleteConstraint(ground_sphere_constraint)
	End If
	cam_control(scene_canvas)
	
	Canvas(scene_canvas)
	PreUpdate()
	Dim sx, sy, sz
	Dim gx, gy, gz
	GetActorPosition(sphere, sx, sy, sz)
	GetActorPosition(ground, gx, gy, gz)
	Dim vx, vy
	GetWorldToViewportPosition(sx, sy, sz, vx, vy)
	
	
	SetColor(RGB(255,255,255))
	Line3D(gx, gy, gz, sx, sy, sz)
	
	Update()
Wend