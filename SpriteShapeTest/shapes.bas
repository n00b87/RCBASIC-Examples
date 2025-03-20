Type Vertex
	Dim x
	Dim y
End Type

Function RotatePoint2D(pt_x, pt_y, center_x, center_y, angleDeg) As Vertex
	angleRad = Radians(-angleDeg)
	cosAngle = Cos(angleRad)
	sinAngle = Sin(angleRad)
	dx = (pt_x-center_x)
	dy = (pt_y-center_y)

	Dim v as Vertex
	v.x = center_x + (dx*cosAngle-dy*sinAngle)
	v.y = center_y + (dx*sinAngle+dy*cosAngle)
	Return v
End Function

Function CreateVertex(x, y) As Vertex
	Dim v as Vertex
	v.x = x
	v.y = y
	Return v
End Function

Sub SetPolyShape(sprite, ByRef v As Vertex, v_count)
	SetSpriteCollisionShape(sprite, SPRITE_SHAPE_POLYGON)
	
	Dim x[v_count]
	Dim y[v_count]
	
	For i = 0 to v_count-1
		x[i] = v[i].x
		y[i] = v[i].y
	Next
	
	SetSpritePolygon(sprite, x, y, v_count)
End Sub

Sub SetCircleShape(sprite, radius)
	SetSpriteCollisionShape(sprite, SPRITE_SHAPE_CIRCLE)
	SetSpriteRadius(sprite, radius)
End Sub

Sub SetChainShape(sprite, ByRef v As Vertex, v_count)
	Print "DBG: "; v_count
	Print ""
	Print ""
	
	SetSpriteCollisionShape(sprite, SPRITE_SHAPE_CHAIN)
	
	Dim x[v_count]
	Dim y[v_count]
	
	For i = 0 to v_count-1
		x[i] = v[i].x
		y[i] = v[i].y
	Next
	SetSpriteChain(sprite, x, y, v_count, x[0]-1, y[0]-1, x[v_count-1]+1, y[v_count-1]+1)
	SetSpriteSolid(sprite, TRUE)
End Sub
