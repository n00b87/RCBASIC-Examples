'----------------------------------------------------------------
'   TITLE: Sprite Test
'   AUTHOR: n00b
'   DATE: Dec 15, 2024
'
'   DESCRIPTION: Demo of the new Sprite System introduced in RCBasic 4
'----------------------------------------------------------------


title$ = "Sprite Test"
w = 640
h = 480
fullscreen = FALSE
vsync = FALSE

'Open a graphics window
OpenWindow( title$, w, h, fullscreen, vsync )

'Open a Sprite Canvas
sprite_canvas = OpenCanvasSpriteLayer(0, 0, w, h)

'A canvas for text and UI
ui_canvas = OpenCanvas(w, h, 0, 0, w, h, 1)

'Load Sprite Image and Font
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

sp_image = LoadImage(asset_dir$ + "graizor.png")
m_font = LoadFont(asset_dir$ + "FreeMono.ttf", 16)

Canvas(ui_canvas)
SetColor(RGB(255,255,255))
DrawText("USE ARROW KEYS TO MOVE LEFT AND RIGHT", 10, 10)


'Must be in a sprite canvas to create sprites
Canvas(sprite_canvas)

'The frame width will be used to determine the size of each animation
'frame as well as the size of the physics body
sprite = CreateSprite(sp_image, 64, 64)
SetSpritePosition(sprite, 200, 10)
SetSpriteSolid(sprite, TRUE)
SetSpriteType(sprite, SPRITE_TYPE_DYNAMIC)

'Create Some animations for the sprite
walk_right = CreateSpriteAnimation(sprite, 4, 12)
SetSpriteAnimationFrame(sprite, walk_right, 0, 0)
SetSpriteAnimationFrame(sprite, walk_right, 1, 1)
SetSpriteAnimationFrame(sprite, walk_right, 2, 2)
SetSpriteAnimationFrame(sprite, walk_right, 3, 3)

walk_left = CreateSpriteAnimation(sprite, 4, 12)
SetSpriteAnimationFrame(sprite, walk_left, 0, 28)
SetSpriteAnimationFrame(sprite, walk_left, 1, 29)
SetSpriteAnimationFrame(sprite, walk_left, 2, 30)
SetSpriteAnimationFrame(sprite, walk_left, 3, 31)

'Create a sprite for our ground
'NOTE: We are just going to create a sprite without an image and draw a rectangle
'      for our ground
ground = CreateSprite(-1, 640, 100)
SetSpriteSolid(ground, TRUE)
SetSpritePosition(ground, 0, 380)
SetSpriteType(ground, SPRITE_TYPE_STATIC)

'Set out sprites animation
SetSpriteAnimation(sprite, walk_right, -1)

'Next we will set our gravity so that our sprite falls to the ground
SetGravity2D(0, 60)


'Since our scene does not scroll in this example I am just going to draw the
'ground on the UI canvas I setup
Canvas(ui_canvas)
SetColor(RGB(0,180,0))
RectFill(0, 380, 640, 100)

While Not Key(K_ESCAPE)

	'We will move our sprite and change the animtion when the arrow keys
	'are pressed
	If Key(K_LEFT) Then
		If GetSpriteAnimation(sprite) <> walk_left Then
			SetSpriteAnimation(sprite, walk_left, -1)
		End If
		SetSpriteLinearVelocity(sprite, -30, 0)
	ElseIf Key(K_RIGHT) Then
		If GetSpriteAnimation(sprite) <> walk_right Then
			SetSpriteAnimation(sprite, walk_right, -1)
		End If
		SetSpriteLinearVelocity(sprite, 30, 0)
	End If
	
	Update()
Wend
