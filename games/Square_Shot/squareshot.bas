'
'Square Shot
'
'by n00b on rcbasic forums
'@n00b on rcbasic.freeforums.net
'
'This was coded in RCBasic
'http://www.rcbasic.com
'
'The controls:
'Move - Arrow Keys
'Shoot - SPACE
'
'--------------------------------------------------------  

Randomize(Timer())
WindowOpen(0,"Square Shot", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480, 0)
CanvasOpen(0, 640, 480, 0, 0, 640, 480, 0)
SHOT_SFX = 0
EXPLOSION_SFX = 1
MAX_ENEMIES = 10
ENEMY_MAX_BULLETS = 20
Dim enemy_pos[MAX_ENEMIES,2]
Dim enemy_status[MAX_ENEMIES]
Dim enemy_bullet[MAX_ENEMIES, ENEMY_MAX_BULLETS, 3]
Dim enemy_bullet_status[MAX_ENEMIES, ENEMY_MAX_BULLETS]
Dim enemy_speed[MAX_ENEMIES]
enemy_w = 20
enemy_h = 20
enemy_bullet_w = 5
enemy_bullet_h = 5
ENEMY_STATUS_DEAD = 0
ENEMY_STATUS_ALIVE = 1
FIRE_UP = 0
FIRE_DOWN = 1
FIRE_LEFT = 2
FIRE_RIGHT = 3
player_x = 10
player_y = 200
player_w = 20
player_h = 20
player_alive = true
dim player_bullet[100,4]
player_bullet_w = 5
player_bullet_h = 5
player_speed = 1.75
player_bullet_speed = 2
score = 0
LoadFont(0, "FreeMono.ttf", 12)
LoadFont(1, "FreeMono.ttf", 16)
LoadMusic("assets/Mercury.wav")
LoadSound(SHOT_SFX, "assets/sfx_weapon_singleshot13.wav")
LoadSound(EXPLOSION_SFX, "assets/sfx_exp_short_hard1.wav")
SetSoundVolume(SHOT_SFX, 48)
dim title_frame[3]
title_frame[0] = 0
title_frame[1] = 1
title_frame[2] = 2
DPAD_BUTTON_WIDTH = 80
DPAD_BUTTON_HEIGHT = 80
dim dpad[8,2]
dim dpad_image[8]
dim dpad_status[8]
UP_BUTTON_IMAGE = 0
LEFT_BUTTON_IMAGE = 1
DOWN_BUTTON_IMAGE = 2
RIGHT_BUTTON_IMAGE = 3
LoadImage_Ex(0,"assets/up_button.png",-1)
LoadImage_Ex(1,"assets/left_button.png",-1)
LoadImage_Ex(2,"assets/down_button.png",-1)
LoadImage_Ex(3,"assets/right_button.png",-1)
PlayMusic(-1)
dpad_move_offset_x = 10
dpad_move_offset_y = 10
dpad_shoot_offset_x = 10
dpad_shoot_offset_y = 10
'UP
dpad[0,0] = DPAD_BUTTON_WIDTH + dpad_move_offset_x
dpad[0,1] = 480 - (DPAD_BUTTON_HEIGHT*3) - dpad_move_offset_y
dpad_image[0] = UP_BUTTON_IMAGE
'LEFT
dpad[1,0] = 0 + dpad_move_offset_x
dpad[1,1] = 480 - (DPAD_BUTTON_HEIGHT*2) - dpad_move_offset_y
dpad_image[1] = LEFT_BUTTON_IMAGE
'DOWN
dpad[2,0] = DPAD_BUTTON_WIDTH + dpad_move_offset_x
dpad[2,1] = 480 - DPAD_BUTTON_HEIGHT - dpad_move_offset_y
dpad_image[2] = DOWN_BUTTON_IMAGE
'RIGHT
dpad[3,0] = DPAD_BUTTON_WIDTH*2 + dpad_move_offset_x
dpad[3,1] = 480 - (DPAD_BUTTON_HEIGHT*2) - dpad_move_offset_y
dpad_image[3] = RIGHT_BUTTON_IMAGE
'SHOOT_UP
dpad[4,0] = 640 - (DPAD_BUTTON_WIDTH*2) - dpad_shoot_offset_x
dpad[4,1] = 480 - (DPAD_BUTTON_HEIGHT*3) - dpad_shoot_offset_y
dpad_image[4] = UP_BUTTON_IMAGE
'SHOOT_LEFT
dpad[5,0] = 640 - (DPAD_BUTTON_WIDTH*3) - dpad_shoot_offset_x
dpad[5,1] = 480 - (DPAD_BUTTON_HEIGHT*2) - dpad_shoot_offset_y
dpad_image[5] = LEFT_BUTTON_IMAGE
'SHOOT_DOWN
dpad[6,0] = 640 - (DPAD_BUTTON_WIDTH*2) - dpad_shoot_offset_x
dpad[6,1] = 480 - DPAD_BUTTON_HEIGHT - dpad_shoot_offset_y
dpad_image[6] = DOWN_BUTTON_IMAGE
'SHOOT_RIGHT
dpad[7,0] = 640 - DPAD_BUTTON_WIDTH - dpad_shoot_offset_x
dpad[7,1] = 480 - (DPAD_BUTTON_HEIGHT*2) - dpad_shoot_offset_y
dpad_image[7] = RIGHT_BUTTON_IMAGE
DPAD_MOVE_UP = 0
DPAD_MOVE_LEFT = 1
DPAD_MOVE_DOWN = 2
DPAD_MOVE_RIGHT = 3
DPAD_SHOOT_UP = 4
DPAD_SHOOT_LEFT = 5
DPAD_SHOOT_DOWN = 6
DPAD_SHOOT_RIGHT = 7
ENEMY_IMAGE = 4
ENEMY_BULLET_IMAGE = 5
PLAYER_IMAGE = 6
PLAYER_BULLET_IMAGE = 7
LoadImage(4,"assets/enemy.png")
LoadImage(5,"assets/enemy_bullet.png")
LoadImage(6,"assets/player.png")
LoadImage(7,"assets/player_bullet.png")
sub init()
	enemy_w = 20
	enemy_h = 20
	enemy_bullet_w = 5
	enemy_bullet_h = 5
	player_x = 10
	player_y = 200
	player_w = 20
	player_h = 20
	player_alive = true
	player_bullet_w = 5
	player_bullet_h = 5
	player_speed = 1.75
	player_bullet_speed = 2
	score = 0
	for i = 0 to 99
		player_bullet[i,0] = 0
		player_bullet[i,1] = 0
		player_bullet[i,2] = 0
	next
	for i = 0 to MAX_ENEMIES-1
		enemy_pos[i,0] = rand(40) + 600
		enemy_pos[i,1] = rand(440)
		enemy_speed[i] = rand(3)+2
		enemy_status[i] = ENEMY_STATUS_ALIVE
		for bullet = 0 to ENEMY_MAX_BULLETS-1 mod 3
			enemy_bullet[i, bullet, 2] = -1.5
			enemy_bullet[i, bullet, 0] = 700
		next
		for bullet = 1 to ENEMY_MAX_BULLETS-1 mod 3
			enemy_bullet[i, bullet, 2] = 0
			enemy_bullet[i, bullet, 0] = 700
		next
		for bullet = 2 to ENEMY_MAX_BULLETS-1 mod 3
			enemy_bullet[i, bullet, 2] = 1.5
			enemy_bullet[i, bullet, 0] = 700
		next
	next
end sub
function playerContact(x, y)
	if not player_alive then
		return false
	end if
	dim cx[4]
	dim cy[4]
	cx[0] = x
	cy[0] = y
	cx[1] = x+enemy_w
	cy[1] = y
	cx[2] = x+enemy_w
	cy[2] = y+enemy_h
	cx[3] = x
	cy[3] = y+enemy_h
	for i = 0 to 3
		if cx[i] >= player_x and cx[i] < (player_x+player_w) and cy[i] >= player_y and cy[i] < (player_y+player_h) then
			return true
		end if
	next
	return false
end function
function playerIsHit(x,y)
	if not player_alive then
		return false
	end if
	dim cx[4]
	dim cy[4]
	cx[0] = x
	cy[0] = y
	cx[1] = x+enemy_bullet_w
	cy[1] = y
	cx[2] = x+enemy_bullet_w
	cy[2] = y+enemy_bullet_h
	cx[3] = x
	cy[3] = y+enemy_bullet_h
	for i = 0 to 3
		if cx[i] >= player_x and cx[i] < (player_x+player_w) and cy[i] >= player_y and cy[i] < (player_y+player_h) then
			return true
		end if
	next
	return false
end function
function enemyIsHit(e,x,y)
	'print "ee start"
	if enemy_status[e] = ENEMY_STATUS_DEAD then
		'print "ee false"
		return false
	end if
	if x > 640 then
		return false
	end if
	dim cx[4]
	dim cy[4]
	cx[0] = x
	cy[0] = y
	cx[1] = x+player_bullet_w
	cy[1] = y
	cx[2] = x+player_bullet_w
	cy[2] = y+player_bullet_h
	cx[3] = x
	cy[3] = y+player_bullet_h
	for i = 0 to 3
		if cx[i] >= enemy_pos[e,0] and cx[i] < (enemy_pos[e,0]+enemy_w) and cy[i] >= enemy_pos[e,1] and cy[i] < (enemy_pos[e,1]+enemy_h) then
			score = score + 10
			'print "ee true"
			return true
		end if
	next
	'print "ee false"
	return false
end function
sub PlayerEnd()
	dim c[2]
	c[0] = rgb(255,0,0)
	c[1] = rgb(0,255,255)
	playsound(EXPLOSION_SFX, EXPLOSION_SFX, 1)
	t = timer()
	for i = 0 to player_w
		SetColor(c[i mod 2])
		CircleFill(player_x + player_w/2, player_y+player_h/2, i*2)
		Update()
		wait(5)
	next
	while timer()-t < 1200
	wend
end sub
		
sub GameUpdate()
	'print "start"
	for i = 0 to MAX_ENEMIES-1
		select case enemy_status[i]
		case ENEMY_STATUS_DEAD
			enemy_pos[i,0] = 640
			enemy_pos[i, 1] = rand(480)
			enemy_status[i] = ENEMY_STATUS_ALIVE
			enemy_speed[i] = rand(3) + 1.5
		case ENEMY_STATUS_ALIVE
			enemy_pos[i,0] = enemy_pos[i,0] - enemy_speed[i]
		end select
		if enemy_pos[i,0] < 1 then
			enemy_status[i] = ENEMY_STATUS_DEAD
		end if
		if enemy_status[i] = ENEMY_STATUS_ALIVE and playerContact(enemy_pos[i,0], enemy_pos[i,1])  then
			player_alive = false
			PlayerEnd()
			return
		end if
		for bullet = 0 to ENEMY_MAX_BULLETS-1
			if enemy_bullet_status[i,bullet] then
				enemy_bullet[i, bullet, 0] = enemy_bullet[i, bullet, 0] - (enemy_speed[i]+1)
				enemy_bullet[i, bullet, 1] = enemy_bullet[i, bullet, 1] + enemy_bullet[i, bullet, 2]
			end if
			if enemy_bullet_status[i, bullet] and playerIsHit(enemy_bullet[i,bullet,0], enemy_bullet[i,bullet,1])  then
				player_alive = false
				PlayerEnd()
				return
			end if
			if enemy_bullet[i, bullet, 0] <= 0 OR enemy_bullet[i,bullet,1] <= 0 or enemy_bullet[i,bullet,1] > 480 then
				enemy_bullet_status[i, bullet] = false
			end if
			if enemy_pos[i,0] < 600 and (not enemy_bullet_status[i, bullet]) then
				enemy_bullet_status[i, bullet] = true
				enemy_bullet[i, bullet, 0] = enemy_pos[i,0]
				enemy_bullet[i, bullet, 1] = enemy_pos[i,1] + (enemy_h/2)
			end if
			if not enemy_bullet_status[i,bullet] then
				enemy_bullet_status[i,bullet] = true
				enemy_bullet[i,bullet,0] = enemy_pos[i,0]
				enemy_bullet[i,bullet,1] = enemy_pos[i,1] + (enemy_h/2)
			end if
		next
		'print "this"
		for p_bullet = 0 to 30
			if player_bullet[p_bullet,0] > 640 then
				player_bullet[p_bullet,2] = false
			end if
			'print "if 2"
			if player_bullet[p_bullet,2] then
				select case player_bullet[p_bullet,3]
				case FIRE_UP
					player_bullet[p_bullet, 1] = player_bullet[p_bullet, 1] - player_bullet_speed
				case FIRE_DOWN
					player_bullet[p_bullet, 1] = player_bullet[p_bullet, 1] + player_bullet_speed
				case FIRE_RIGHT
					player_bullet[p_bullet, 0] = player_bullet[p_bullet, 0] + player_bullet_speed
				case FIRE_LEFT
					player_bullet[p_bullet, 0] = player_bullet[p_bullet, 0] - player_bullet_speed
				end select
			end if
			'print "if 3"
			if player_bullet[p_bullet,2] and enemyIsHit(i,player_bullet[p_bullet,0],player_bullet[p_bullet,1])  then
				enemy_status[i] = ENEMY_STATUS_DEAD
				player_bullet[p_bullet,2] = false
				player_bullet[p_bullet,0] = -100
			end if
			'print "NEXT!!!!"
		next
		'print "giddy"
	next
end sub
sub player_fire(fire_dir)
	for p_bullet = 0 to 30
		if not player_bullet[p_bullet,2] then
			player_bullet[p_bullet,3] = fire_dir
			select case fire_dir
			case FIRE_UP
				player_bullet[p_bullet,2] = true
				player_bullet[p_bullet,0] = player_x+ (player_w/2)
				player_bullet[p_bullet,1] = player_y
			case FIRE_DOWN
				player_bullet[p_bullet,2] = true
				player_bullet[p_bullet,0] = player_x+ (player_w/2)
				player_bullet[p_bullet,1] = player_y + player_h
			case FIRE_LEFT
				player_bullet[p_bullet,2] = true
				player_bullet[p_bullet,0] = player_x+player_w
				player_bullet[p_bullet,1] = player_y + (player_h/2)
			case FIRE_RIGHT
				player_bullet[p_bullet,2] = true
				player_bullet[p_bullet,0] = player_x
				player_bullet[p_bullet,1] = player_y + (player_h/2)
			end select
			playsound(SHOT_SFX, SHOT_SFX, 1)
			return
		end if
	next
end sub
sub Control()
	if key(K_LEFT) and player_x > 0 then
		player_x = player_x -player_speed
	elseif key(K_RIGHT) and (player_x+player_w) < 640 then
		player_x = player_x +player_speed
	end if
	if key(K_UP) and player_y > 0 then
		player_y = player_y - player_speed
	elseif key(K_DOWN) and (player_y+player_h) < 480 then
		player_y = player_y + player_speed
	end if
	if key(K_SPACE) then
		player_fire(FIRE_RIGHT)
	end if
end sub
function touch_button(status, x, y, check_button)
	if not status then
		return false
	end if
	if x >= dpad[check_button,0] and x < dpad[check_button,0] + DPAD_BUTTON_WIDTH and y >= dpad[check_button,1] and y < dpad[check_button,1] + DPAD_BUTTON_HEIGHT then
		return true
	end if
	return false
end function
sub Control_Touch()
	touch_status = 0
	touch_x = -1
	touch_y = -1
	touch_dx = -1
	touch_dy = -1
	GetTouch(touch_status, touch_x, touch_y, touch_dx, touch_dy)
	if touch_button(touch_status, touch_x, touch_y, DPAD_MOVE_LEFT) and player_x > 0 then
		player_x = player_x -player_speed
	elseif touch_button(touch_status, touch_x, touch_y, DPAD_MOVE_RIGHT) and (player_x+player_w) < 640 then
		player_x = player_x +player_speed
	end if
	if touch_button(touch_status, touch_x, touch_y, DPAD_MOVE_UP) and player_y > 0 then
		player_y = player_y - player_speed
	elseif touch_button(touch_status, touch_x, touch_y, DPAD_MOVE_DOWN) and (player_y+player_h) < 480 then
		player_y = player_y + player_speed
	end if
	if touch_button(touch_status, touch_x, touch_y, DPAD_SHOOT_RIGHT) then
		player_fire(FIRE_RIGHT)
	end if
end sub
sub Render()
	ClearCanvas()
	'SetColor(RGB(0,200,0))
	'RectFill(player_x, player_y, player_w, player_h)
	DrawImage(PLAYER_IMAGE, player_x, player_y)
	for i = 0 to MAX_ENEMIES-1
		'SetColor(RGB(200,0,0))
		if enemy_status[i] = ENEMY_STATUS_ALIVE then
			'RectFill(enemy_pos[i,0], enemy_pos[i,1], enemy_w, enemy_h)
			DrawImage(ENEMY_IMAGE, enemy_pos[i,0], enemy_pos[i,1])
		end if
		'SetColor(RGB(0,200,200))
		for b = 0 to ENEMY_MAX_BULLETS-1
			if enemy_bullet_status[i,b] then
				'RectFill(enemy_bullet[i,b,0], enemy_bullet[i,b,1], enemy_bullet_w, enemy_bullet_h)
				DrawImage(ENEMY_BULLET_IMAGE, enemy_bullet[i,b,0], enemy_bullet[i,b,1])
			end if
		next
	next
	'SetColor(RGB(255,255,255))
	for i = 0 to 99
		if player_bullet[i,2] then
			'RectFill(player_bullet[i,0], player_bullet[i,1], player_bullet_w, player_bullet_h)
			DrawImage(PLAYER_BULLET_IMAGE, player_bullet[i,0], player_bullet[i,1])
		end if
	next
	SetColor(RGB(255,255,255))
	DrawText("Score:" +str(score), 10, 10)
	if OS = "ANDROID" then
		iw = 0
		ih = 0
		for i = 0 to 7
			GetImageSize(dpad_image[i], iw, ih)
			DrawImage(dpad_image[i], dpad[i,0] + (DPAD_BUTTON_WIDTH/2) - (iw/2), dpad[i,1] + (DPAD_BUTTON_HEIGHT/2) - (ih/2))
		next
	end if
	Update()
	wait(5)
end sub
START_OPTION_EXIT = 0
START_OPTION_PLAY = 1
function StartScreen()
	current_title_frame = 0
	touch_status = 0
	touch_x = -1
	touch_y = -1
	touch_dx = -1
	touch_dy = -1
	while not key(k_escape)
		ClearCanvas()
		if OS = "ANDROID" then
			GetTouch(touch_status, touch_x, touch_y, touch_dx, touch_dy)
			if touch_status then
				return START_OPTION_PLAY
			end if
		else
			if key(k_return) then
				return START_OPTION_PLAY
			end if
		end if
		SetColor(RGB(255,255,255))
		Font(1)
		DrawText("Square Shot", 220, 150)
		Font(0)
		if OS = "ANDROID" then
			DrawText("Tap the Screen to Play", 200, 350)
		else
			DrawText("Press Enter to Play", 200, 350)
			DrawText("Press Escape to Quit", 200, 360)
			DrawText("Programmed by the n00b", 200, 420)
		end if
		Update()
		wait(5)
	wend
	return START_OPTION_EXIT
end function
function FinalView()
	touch_status = 0
	touch_x = -1
	touch_y = -1
	touch_dx = -1
	touch_dy = -1
	while true
		if OS = "ANDROID" then
			GetTouch(touch_status, touch_x, touch_y, touch_dx, touch_dy)
			if touch_status then
				return START_OPTION_PLAY
			end if
		else
			if key(k_y) then
				return START_OPTION_PLAY
			elseif key(k_n) then
				return START_OPTION_EXIT
			end if
		end if
		ClearCanvas()
		SetColor(RGB(0,0,200))
		RectFill(100, 100, 440, 120)
		SetColor(RGB(255,255,255))
		Font(1)
		DrawText("Your Score is: " + str(score), 110, 110)
		DrawText("Play Again? (Y/N)", 120, 150)
		Update()
	wend
end function
sub GameLoop()
	init()
	while true
		if OS = "ANDROID" then
			Control_Touch()
		else
			Control()
		end if
		GameUpdate()
		if not player_alive then
			return
		end if
		Render()
	wend
end sub
game_status = -1
while game_status <> START_OPTION_EXIT
	game_status = StartScreen
	select case game_status
	case START_OPTION_PLAY
		GameLoop
		game_status = FinalView
		wait(20)
	case START_OPTION_EXIT
		exit while
	default
		exit while
	end select
wend
DeleteMusic()
DeleteSound(0)
DeleteSound(1)
DeleteFont(0)
DeleteFont(1)
WindowClose(0)
End
