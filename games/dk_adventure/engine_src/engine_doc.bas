Function LoadBkg(bkg_image$)
-------------------------------------------------
'Loads an image
'returns slot or -1 on failure


Function LoadFrameSheet(img_file$, frame_width, frame_height)
----------------------------------------------------------------------
'Loads a framesheet splitting the sheet up into frames of given width and height
'returns the frame number

Sub ClearFrameSheet(f_num)
----------------------------------------------------------------------
'Clears a framesheet


Sub Sprite_SetHitBox(sprite, hb_shape, x, y, w_r, h)
----------------------------------------------------------------
'Sets the hitbox shape and dimensions of a sprite
'hb_shape values: GEOMETRY_LINE = 1, GEOMETRY_RECT = 2, GEOMETRY_CIRCLE = 3


Function GetLineIntersect(p0_x, p0_y, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y, ByRef i_x, ByRef i_y)
---------------------------------------------------------------------------------------------------
'Gets the intersection between 2 lines
'returns 1 on success and 0 on failure


Function Sprite_GetHit(sprite1, sprite2)
-------------------------------------------------------------------
'Checks for collision between 2 sprites
'returns true if there is a collision and false if there isn't


Sub SetSpriteHit(sprite, hitbox_line, rect_line, hit_x, hit_y)
----------------------------------------------------------------------
'Sets world  hit direction flag - ie. WORLDHIT_LEFT = true, etc.
'hit_x, hit_y - where the sprite collided with the world
'hitbox_line - LEFT, RIGHT, TOP, or BOTTOM of sprite
'rect_line - LEFT, RIGHT, TOP, or BOTTOM of world geometry
'sprite - pretty obvious


Sub GetSpriteHit(sprite, from, ByRef x, ByRef y)
------------------------------------------------------------------------
'Gets the position of a sprite collision from a given direction


Sub GetSpriteHitFromWorld(sprite, from, ByRef x, ByRef y)
------------------------------------------------------------------------
'Gets the position of sprite collision with world geometry from given direction


Function Sprite_GetWorldHit(sprite, x, y)
-------------------------------------------------------------------------
'Sets sprite hit flag (FROM_TOP, FROM_LEFT, ect.) if there is a collision and returns true, returns false if there is no collision


Sub Sprite_CheckCollisions(layer)
---------------------------------------------------------------------------
'Checks for sprite collisions with other sprites


Sub SaveSprite(sprite, spr_name$)
---------------------------------------------------------------------------
'Pretty obvious what this does


Function LoadSprite(spr_name$)
------------------------------------------------------------------------------
'ballooons


Sub ClearSprite(sprite)
-----------------------------------------------------------------------------
'Clears a sprite


Function CreateSprite(f_sheet)
'Creates a new sprite with the given frame sheet


Sub KillSprite(sprite)
----------------------------------------------------------------------------
'Removes sprite from current scene


Sub Sprite_SetChild(parent_sprite, child_sprite, child_offset_x, child_offset_y)
---------------------------------------------------------------------------------------
'Set a child sprite to the given parent sprite, child sprite is offset given number of pixels from parent


Sub Sprite_ReleaseChild(child_sprite)
-----------------------------------------------------------------------------------------
'Release child sprite from its parent


Sub DrawSpriteFrame(sprite, frame_num, x, y, angle, zx, zy)
-------------------------------------------------------------------------------------------
'Draws sprite frame at given position, rotated and scaled


Sub Sprite_GetFrame(sprite, frame_num, ByRef x, ByRef y, ByRef w, ByRef h)
-------------------------------------------------------------------------------------------
'Gets the position of the given frame of the sprite in the sprite frame sheet


Function Sprite_NewAnimation(sprite)
----------------------------------------------------------------------------------
'Add a new animation to a sprite
'returns the animation number


Sub Sprite_SetAnimationFrame(sprite, anim_num, frame_num, frame)
----------------------------------------------------------------------------------
'sets the frame (frame_num) in the animation (anim_num) to the given frame in the sprites frame sheet (frame)


Sub Sprite_SetFPS(sprite, fps)
------------------------------------------------------------------------------------
'Yeaaah


Sub Sprite_Play(sprite, anim_num, anim_loops)
-------------------------------------------------------------------------------------
'Balls


Function Sprite_GetAnimation(sprite)
--------------------------------------------------------------------------------
'returns current animation for the given sprite


Sub Sprite_Stop(sprite)
--------------------------------------------------------------------------
'Stops a sprite animation


Function Sprite_AnimationIsPlaying(sprite)
----------------------------------------------------------------------------------
'returns something


Function Sprite_AnimationEnd(sprite)
--------------------------------------------------------------------------------
'returns true if sprite has reached the end of its animation


Sub Sprite_SetAnimationFrameCount(sprite, anim_num, n)
--------------------------------------------------------------------------------
'sets the number of frames in a sprite animation


Sub Sprite_Position(sprite, x, y)
------------------------------------------------------------------------------
'sets a sprite's position
'x and y are in world coordinates
'this routine checks for world collision before moving the sprite


Function Sprite_Move(sprite, x, y)
-----------------------------------------------------------------------------
'moves a sprite by x, y amount from its current position
'x and y are the amount of pixels to move from the current position
'this routine also checks for world collision before moving the sprite


Sub Sprite_Scale(sprite, zx, zy)
--------------------------------------------------------------------------
'sets the sprites scale


Sub Sprite_Rotate(sprite, angle)
--------------------------------------------------------------------------
'sets the sprites rotation


Sub Sprite_SetLayer(sprite, spr_layer)
-------------------------------------------------------------------------
'sets the layer the sprite is drawn on
'this will also determine what layer the sprites collision is checked on


Sub TileSet_GetFrame(frame_num, ByRef x, ByRef y, ByRef w, ByRef h)
-------------------------------------------------------------------------
'gets a frames position in a tileset's frame sheet


Sub CreateTileSet(img_file$, tile_width, tile_height)
-------------------------------------------------------------------------
'i wonder what this does? (sarcasm)


Sub Tile_AddFrame(tile, t_frame)
---------------------------------------------------------------------------
'adds t_frame to tile animation
'this will increase number of frames in tile's animation


Sub Tile_SetFrame(tile, frame_num, t_frame)
--------------------------------------------------------------------------
'changes a frame in a tile's animation to t_frame


Sub Tile_RemoveFrame(tile)
-------------------------------------------------------------------------
'Decreases number of frames in a tiles animation by 1


Sub TileSet_SetFPS( t_fps )
-------------------------------------------------------------------------
'Scooby Doo


Sub CreateMap(width_in_tiles, height_in_tiles, vpx, vpy, vpw, vph, sect_w, sect_h)
---------------------------------------------------------------------------------------
'creates an empty map
'only need to use this in the editor


Sub SaveTileSet()
------------------------------------------------------------------------
'Saves tileset
'only need to use this in the editor


Sub LoadTileSet(tset$)
------------------------------------------------------------------------
'loads a tileset
'its used by loadmap


Sub SaveMap(map_name$)
------------------------------------------------------------------------
'you know how we do


Sub LoadMap(map_name$, vpx, vpy, vpw, vph)
'Loads a map
'viewport describes where it is drawn on the screen


Sub ClearMap()
'Clears the map


Sub Map_SetOffset(x, y)
----------------------------------------------------------------------
'sets the maps offset


Sub Map_Scroll(x, y)
---------------------------------------------------------------------
'scrolls a map by a certain number of pixels


Sub Map_ScreenToWorld(ByRef x, ByRef y)
-------------------------------------------------------------------- 
'converts screen coordinates to world coordinates


Sub Map_WorldToScreen(ByRef x, ByRef y)
--------------------------------------------------------------------
'converts world coordinates to screen coordinates


Sub Map_ScreenToWorldGrid(ByRef x, ByRef y)
--------------------------------------------------------------------
'converts screen coordinates to a grid position


Sub Map_ShowLayer(layer)
--------------------------------------------------------------------
'shows a layer


Sub Map_HideLayer(layer)
-------------------------------------------------------------------
'boobies


Sub Map_SetLayer(layer)
---------------------------------------------------------------------
'sets the current layer for drawing on


Sub Map_SetOffsetInterval(layer, i)
---------------------------------------------------------------------
'sets layer offset interval for parralax


Sub Map_SetTile(tile_num, x, y)
---------------------------------------------------------------------
'places a tile on the map


Sub Map_SetBkg(image)
---------------------------------------------------------------------
'Set background image for the map


Sub Map_ShowBkg(layer)
---------------------------------------------------------------------
'sets background on given layer visible


Sub Map_HideBkg(layer)
---------------------------------------------------------------------
'hides background on given layer


Sub Map_PlayVideo(vloops)
----------------------------------------------------------------------
'needs work


Function Map_Geometry_AddRect(x, y, w, h)
---------------------------------------------------------------------
'adds a rectangle geometry
'returns geometry number


Function Map_Geometry_AddLine(x1, y1, x2, y2)
----------------------------------------------------------------------
'adds a line geometry
'returns geometry number


Function Map_Geometry_AddCircle(x, y, r)
----------------------------------------------------------------------
'adds a circle geometry
'returns geometry number


Sub Map_Geometry_Edit(g_num, g_type, n1, n2, n3, n4)
----------------------------------------------------------------------
'changes a map geometry


Sub Map_Geometry_Remove()
----------------------------------------------------------------------
'removes the last map geometry that was added


Sub Map_SetLayerFlag(flag, n)
----------------------------------------------------------------------
'sets a layer flag to true or false


Sub DrawTileFrame(frame_num, x, y)
----------------------------------------------------------------------
'draws a tile frame at x,y position
'x and y are in screen coordinates


Sub DrawGeometry( g_num, layer, mx, my )
----------------------------------------------------------------------
'i wonder what this does


Sub Render()
----------------------------------------------------------------------
'it displays stuff



'GAME SPECIFIC STUFF
sub NPC_ResetList()

sub NPC_AddSprite(sprite)

sub NPC_SetDialog(sprite, txt$)

function NPC_Hit(sprite)
