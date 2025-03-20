OpenWindow("Tile Scrolling", 640, 480, 0, 0)


'Tilemaps are drawn on a paint canvas like they are regular images
tile_layer = OpenCanvas(640, 480, 0, 0, 640, 480, 1)

'Here is the order for creating a tile map
'1. Load an image with your tiles (your tiles can be any size you want)
tiles_image = LoadImage("tiles.png")

'2. Create a TileSet object (This is where you will tell RCBasic your tile size)
'        NOTE ON TILESETS: TileSets are where you can animate your tiles
'
tileset = CreateTileSet(tiles_image, 32, 32)

'3. Create a TileMap using your TileSet
'        NOTE ON TILEMAPS: TileMaps are as the name suggest the actual maps
'
tilemap = CreateTileMap(tileset, 9999, 9999) 'I am creating a large map here just to show that it doesn't have an impact on performance

'Now we can fill our Tilemap with tiles
'
'The first tile in your image is tile 0 and it increases by 1 going across

'Tile 60 is just a blank tile
FillTile(tilemap, 60, 0, 0, 9999, 9999)

'7 is water top
FillTile(tilemap, 7, 0, 13, 9999, 1)

'9 is solid blue
FillTile(tilemap, 9, 0, 14, 9999, 10)


Print "Fill done"


'Now we can animate tile 7 (the water top) to give it some waves
SetTileAnimationLength(tileset, 7, 2)
SetTileAnimationFrame(tileset, 7, 0, 7) 'The first frame (frame 0) will be tile 7
SetTileAnimationFrame(tileset, 7, 1, 8) 'The second frame (frame 1) will be tile 8
SetTileAnimationSpeed(tileset, 7, 12) 'Animate at 12 frames per second

offset_x = 0
offset_y = 0

'PRESS LEFT AND RIGHT TO SCROLL TILEMAP
While Not Key(K_ESCAPE)
	If Key(K_LEFT) Then
		offset_x = offset_x - 2
	ElseIf Key(K_RIGHT) Then
		offset_x = offset_x + 2
	End If
	DrawTileMap(tilemap, 0, 0, 640, 480, offset_x, offset_y)
	Update()
Wend
