'----------------------------------------------------------------
'   TITLE: Tiling Demo
'   AUTHOR: n00b
'   DATE: Dec 13, 2024
'
'   DESCRIPTION: Drawing animated tiles using RCBasic 4 built-in 
'                tiling
'----------------------------------------------------------------

OpenWindow("Tiles", 480, 320, 0, 1)

tile_canvas = OpenCanvas(480, 320, 0, 0, 480, 320, 0)

Canvas(tile_canvas)

water_sheet = LoadImage("water_tile.png")

test_tileset = CreateTileSet(water_sheet, 16, 16)

SetTileAnimationLength(test_tileset, 0, 2)
SetTileAnimationFrame(test_tileset, 0, 1, 1)
SetTileAnimationSpeed(test_tileset, 0, 12)

map = CreateTileMap(test_tileset, 100, 100)
FillTile(map, 0, 0, 0, 100, 100)

While Not Key(K_ESCAPE)
	DrawTileMap(map, 0, 0, 480, 320, 0, 0)
	Update()
	
Wend
