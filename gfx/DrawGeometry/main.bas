WindowOpen(0, "tst", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480, WINDOW_VISIBLE, 1)
CanvasOpen(0, 640, 480, 0, 0, 640, 480, 1)

ClearCanvas

LoadImage(0, "tst.bmp")

Dim vertices[3, 8]
Dim indices[3]

indices[0] = 0
indices[1] = 1
indices[2] = 2

'Top Center of Triangle
vertices[0, 0] = 320	'screen x position
vertices[0, 1] = 10	'screen y postion
vertices[0, 2] = 255	'red
vertices[0, 3] = 255	'green
vertices[0, 4] = 255	'blue
vertices[0, 5] = 255	'alpha
vertices[0, 6] = 0.5	'texture x
vertices[0, 7] = 0.5	'texture y

'Bottom Left of Triangle
vertices[1, 0] = 640	'screen x position
vertices[1, 1] = 450	'screen y postion
vertices[1, 2] = 255	'red
vertices[1, 3] = 255	'green
vertices[1, 4] = 255	'blue
vertices[1, 5] = 255	'alpha
vertices[1, 6] = 0		'texture x
vertices[1, 7] = 1		'texture y

'Bottom Right of Triangle
vertices[2, 0] = 30	'screen x position
vertices[2, 1] = 450	'screen y postion
vertices[2, 2] = 255	'red
vertices[2, 3] = 255	'green
vertices[2, 4] = 255	'blue
vertices[2, 5] = 255	'alpha
vertices[2, 6] = 1		'texture x
vertices[2, 7] = 1		'texture y


DrawGeometry(0, 3, vertices, 3, indices)
Update()

WaitKey()
