'----------------------------------------------------------------
'   TITLE: Simple 3D Platformer
'   AUTHOR: n00b
'   DATE: Dec 13, 2024
'
'   DESCRIPTION: This is a simple interactive demo written
'                to demonstrate the 3D functionality in RCBasic 4
'----------------------------------------------------------------

Include "util.bas" 'This has the RotatePoint2D and GetHeading2D functions

'This variable will be set to the main 3D canvas once its created
scene_canvas = -1

hero = -1
level = -1
level_collision = -1

'Used to store the bounding box for character
Dim min_bbx, min_bby, min_bbz
Dim max_bbx, max_bby, max_bbz

'Forces applied when the player moves
player_linear_force = 3000
player_angular_force = 3000
player_jump_force = 5000
player_jump_linear_force = 0
player_jump_ready = False
player_ground_test = FALSE

'These variables will store the animations once set below
PLAYER_IDLE_ANIMATION = 0
PLAYER_RUN_ANIMATION = 0
PLAYER_JUMP_ANIMATION = 0

'These are the buttons for player control mode
PLAYER_KEY_RUN = K_UP
PLAYER_KEY_LEFT = K_LEFT
PLAYER_KEY_RIGHT = K_RIGHT
PLAYER_KEY_JUMP = K_SPACE

CONTROL_MODE_PLAYER = 0
CONTROL_MODE_CAMERA = 1

mode_switch = False

'I am setting up some matrices that I use to get the direction the
'player is facing. GetActorPosition() is not reliable since it is
'prone to gimbal lock so the prefered method is to calculate the
'direction from the actor's transform matrix using a forward vector
'
'NOTE: Matrices are not automatically cleaned up once out of scope
'      so if you are not creating a matrix in global scope then you
'      must call DeleteMatrix() to clean them up
player_m = DimMatrix(4, 4)
forward_m = DimMatrix(4, 4)
result_m = DimMatrix(4, 4)

'This matrix is just setting a forward vector so it won't change
SetIdentityMatrix(forward_m, 4)
SetMatrixTranslation(forward_m, 0, 0, -1)

'A simple 3rd person camera to follow the player
Function Player_Camera(player_actor)
	Dim cam_x, cam_y, cam_z
	Canvas(scene_canvas)
	GetCameraPosition(cam_x, cam_y, cam_z)
	
	Dim px, py, pz
	GetActorPosition(player_actor, px, py, pz)
	
	Dim rx, ry, rz
	GetActorRotation(player_actor, rx, ry, rz)
	
	tx = 1 - (cam_x - px)
	ty = 30 - (cam_y - py)
	tz = -75 -(cam_z - pz)
	
	If mode_switch Then
		mode_switch = False
		SetCameraPosition(px+1, py+30, pz-75)
		SetCameraRotation(0, 0, 0)
	Else
		Dim rv As Vector2D
		
		GetActorTransform(player_actor, player_m)
		MultiplyMatrix(player_m, forward_m, result_m)
		Dim mx, my, mz
		GetMatrixTranslation(result_m, mx, my, mz)
		cam_rot_y = GetHeading2D(px, pz, mx, mz)
		rv = RotatePoint2D(px+1, pz-75, px, pz, 90-cam_rot_y)
		SetCameraPosition(rv.x, py+30, rv.y)
		SetCameraRotation(0, 90-cam_rot_y, 0)
	End If
End Function


'This function handles the players controls
Sub Player_Control(player_actor)
	If Key(K_R) Then
		SetActorPosition(hero, 80, 85, 570)
		mode_switch = TRUE
		While Key(K_R)
			Update()
		Wend
		Return
	End If
	
	'Store the current player animation
	player_animation = GetActorCurrentAnimation(player_actor)
	
	'We need to set the linear and angular factors and velocities to 0 to prevent
	'the forces from being continually applied when the player is idle
	Dim lx, ly, lz
	GetActorLinearFactor(player_actor, lx, ly, lz)
	'SetActorLinearFactor(player_actor, 0, ly, 0)
	Dim ax, ay, az
	GetActorAngularFactor(player_actor, ax, ay, az)
	SetActorAngularFactor(player_actor, 0, 0, 0)
	Dim lfx, lfy, lfz
	GetActorLinearVelocityWorld(player_actor, lfx, lfy, lfz)
	SetActorLinearVelocityWorld(player_actor, 0, lfy, 0)
	Dim afx, afy, afz
	GetActorAngularVelocityWorld(player_actor, afx, afy, afz)
	SetActorAngularVelocityWorld(player_actor, 0, 0, 0)
	ClearActorForces(player_actor)
	action_run = FALSE
	action_jump = FALSE
	
	'If the run key is pressed and the player is on the ground
	'then the current animation is set to the run animation
	If Key(PLAYER_KEY_RUN) And player_ground_test Then
		player_animation = PLAYER_RUN_ANIMATION
		action_run = TRUE
	End If
	
	'If the player can jump then set the current animation
	'to the jump animation
	If Key(PLAYER_KEY_JUMP) And player_jump_ready Then
		player_animation = PLAYER_JUMP_ANIMATION
		action_jump = TRUE
			If Key(PLAYER_KEY_RUN) Then
				player_jump_linear_force = -1500
			End If
	End If
	
	'If the player is on the ground and not running then
	'the current animation is set to the idle animation
	If player_ground_test AND (NOT action_run) Then
		player_animation = PLAYER_IDLE_ANIMATION
		SetActorLinearVelocityWorld(player_actor, 0, lfy, 0)
	End If
	
	'If the player is running then apply an impulse to the
	'player
	If action_run Then
		SetActorLinearFactor(player_actor, 1, ly, 1)
		Dim tx, ty, tz
		GetActorLinearVelocityLocal(player_actor, tx, ty, tz)
		If abs(tz) < 20 Then
			ApplyActorCentralImpulseLocal(player_actor, 0, 0, -player_linear_force)
		End If
	End If
	
	'If the player jumps then apply an upward impulse
	If action_jump Then
		SetActorLinearFactor(player_actor, 1, ly, 1)
		ApplyActorCentralImpulseLocal(player_actor, 0, player_jump_force, 0)
		player_jump_ready = FALSE
	End If
	
	'If the player turns then set a torque
	If Key(PLAYER_KEY_LEFT) Then
		SetActorAngularFactor(player_actor, 0, 1, 0)
		ApplyActorTorqueImpulseWorld(player_actor, 0, -player_angular_force, 0)
	ElseIf Key(PLAYER_KEY_RIGHT) Then
		SetActorAngularFactor(player_actor, 0, 1, 0)
		ApplyActorTorqueImpulseWorld(player_actor, 0, player_angular_force, 0)
	End If
	
	Dim x, y, z
	GetActorPosition(player_actor, x, y, z)

	'Cast a downward ray to check if the player is on the ground
	n = CastRay3D(x, y, z, x, y + min_bby - 5, z)
	
	'If n returns 0 hits, then the player is in the air so we set the animation
	'to the jump animation
	If n = 0 Then
		player_animation = PLAYER_JUMP_ANIMATION
		player_ground_test = FALSE
		player_jump_ready = FALSE
		ApplyActorCentralImpulseLocal(player_actor, 0, 0, player_jump_linear_force)
	End If
	
	'If n returns a hit or player is colliding with level, then set the ground test flag
	If n Or GetActorCollision(player_actor, level_collision) Then
		player_ground_test = TRUE
		If Not Key(PLAYER_KEY_JUMP) Then
			player_jump_ready = TRUE
			player_jump_linear_force = 0
		End If
	End If
	
	'Sets the current animation
	If player_animation <> GetActorCurrentAnimation(player_actor) Then
		SetActorAnimation(player_actor, player_animation, -1)
	End If
End Sub



Sub Camera_Control(cam_canvas)
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
End Sub


title$ = "Simple 3D Game"
w = 640
h = 480
fullscreen = FALSE
vsync = FALSE

'Open a graphics window
OpenWindow( title$, w, h, fullscreen, vsync )

'Open a 3D canvas to view our scene in
scene_canvas = OpenCanvas3D(0, 0, w, h, 1)
ui_canvas = OpenCanvas(w, h, 0, 0, w, h, 1)

SetCanvasZ(scene_canvas, 0)

Sub displayControls(mode)
	Canvas(ui_canvas)
	ClearCanvas()
	SetColor(RGB(255, 255, 255))
	Select Case mode
	Case CONTROL_MODE_PLAYER
		DrawText("ARROW KEYS TO MOVE", 10, 10)
		DrawText("SPACE BAR TO JUMP", 10, 30)
		DrawText("R TO RESET PLAYER POSITION", 10, 50)
		DrawText("PRESS M TO SWITCH TO CAMERA CONTROL", 10, 100)
	Case CONTROL_MODE_CAMERA
		DrawText("W/A/S/D TO MOVE", 10, 10)
		DrawText("R/F TO MOVE UP AND DOWN", 10, 30)
		DrawText("ARROW KEYS TO TURN", 10, 50)
		DrawText("PRESS M TO SWITCH TO PLAYER CONTROL", 10, 100)
	End Select
	Canvas(scene_canvas)
End Sub

'Set our scene canvas as the active canvas
Canvas(scene_canvas)


'Load Assets
asset_dir$ = "assets"

'This SELECT block is just for adding the
'correct OS directory separator
Select Case OS$
	Case "WINDOWS"
		asset_dir$ = asset_dir$ + "\\"
	Default
		asset_dir$ = asset_dir$ + "/"
End Select

'Load Font
mono_font = LoadFont(asset_dir$ + "FreeMono.ttf", 12)
SetFont(mono_font)

'Load character mesh and texture
hero_mesh = LoadMesh(asset_dir$ + "char.ms3d")
hero_texture = LoadImage(asset_dir$ + "survivorMaleB.png")

'Load Level mesh (it is generally not a good idea to load one giant mesh for the
'Stage but this is just a quick demonstration
level_collision_mesh = LoadMesh(asset_dir$ + "level_collision.obj")


'Create our main character actor (this adds it to our 3D scene)
hero = CreateAnimatedActor(hero_mesh)
SetActorScale(hero, 4, 4, 4)
SetActorSolid(hero, TRUE)
SetActorCollisionShape(hero, SHAPE_TYPE_CAPSULE, 40)
SetActorGravity(hero, 0, -150, 0)
'SetActorDamping(hero, 0.3, 0)

GetActorAABB(hero, min_bbx, min_bby, min_bbz, max_bbx, max_bby, max_bbz)
'hero_ground_test = CreateCubeActor( abs(max_bbz-min_bbz)/2 )

'Apply a Texture our main character
SetActorTexture(hero, 0, hero_texture)


'Create our level actor (adds it to our 3D scene)
level_collision = CreateOctreeActor(level_collision_mesh)
SetActorScale(level_collision, 4, 4, 4)
SetActorSolid(level_collision, TRUE)
SetActorCollisionShape(level_collision, SHAPE_TYPE_TRIMESH, 0)

'We are going to get the main character material and disable lighting for this demo
hero_material = GetActorMaterial(hero, 0)
SetMaterialLighting(hero_material, FALSE)

'Add Light
scene_light1 = CreateLightActor()
SetActorPosition(scene_light1, 90, 430, 600)
SetLightType(scene_light1, LIGHT_TYPE_POINT)
SetLightRadius(scene_light1, 900)
RotateActor(scene_light1, 90, 230, 0)

scene_light2 = CreateLightActor()
SetActorPosition(scene_light2, 235, 400, 580)
SetLightType(scene_light2, LIGHT_TYPE_POINT)
SetLightRadius(scene_light2, 600)
RotateActor(scene_light2, 0, 290, 0)

scene_light3 = CreateLightActor()
SetActorPosition(scene_light3, 320, 150, 680)
SetLightType(scene_light3, LIGHT_TYPE_POINT)
SetLightRadius(scene_light3, 600)
RotateActor(scene_light3, 0, 300, 0)


'Add animations to our character
PLAYER_IDLE_ANIMATION = CreateActorAnimation(hero, 1, 12, 12)
PLAYER_RUN_ANIMATION = CreateActorAnimation(hero, 13, 36, 30)
PLAYER_JUMP_ANIMATION = CreateActorAnimation(hero, 24, 24, 1)

'Set the starting animation to idle_animation and set loops to -1 to loop infinitely
SetActorPosition(hero, 80, 85, 570)

SetCameraPosition(90, 100, 528)
SetCameraRotation(0, 0, 0)

player_camera_distance = Distance2D(80, 570, 90, 528)

control_mode = 0

displayControls(control_mode)

While Not Key(K_ESCAPE)
	
	If Key(K_P) Then
		Dim cx, cy, cz, rx, ry, rz
		GetCameraPosition(cx, cy, cz)
		GetCameraRotation(rx, ry, rz)
		Print "Cam Data: Position = ("; cx; ", "; cy; ", "; cz; ")  Rotation = ("; rx; ", "; ry; ", "; rz; ")"
	End If
	
	If Key(K_M) Then
		control_mode = Not control_mode
		While Key(K_M)
			Update()
		Wend
		mode_switch = TRUE
		displayControls(control_mode)
	End If
	
	Select Case control_mode
	Case CONTROL_MODE_PLAYER
		Player_Control(hero)
		Player_Camera(hero)
	Case CONTROL_MODE_CAMERA
		Camera_Control(scene_canvas)
	End Select
	
	Update()
Wend




