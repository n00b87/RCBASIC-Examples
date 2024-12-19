'Some useful functions for common task

Type Vector2D
	Dim x
	Dim y
End Type

'NOTE: This function is not used
Function LocatePointOnLine(start_x, start_y, end_x, end_y, distance_from_start) As Vector2D
	Dim pnt As Vector2D
	t = distance_from_start / Distance2D(start_x, start_y, end_x, end_y)
	pnt.x = ((1 - t) * start_x + t * end_x)
	pnt.y = ((1 - t) * start_y + t * end_y)
	Return pnt
End Function

Function RotatePoint2D(pt_x, pt_y, center_x, center_y, angleDeg) As Vector2D
	angleRad = Radians(-angleDeg)
	cosAngle = Cos(angleRad)
	sinAngle = Sin(angleRad)
	dx = (pt_x-center_x)
	dy = (pt_y-center_y)

	Dim v as Vector2D
	v.x = center_x + (dx*cosAngle-dy*sinAngle)
	v.y = center_y + (dx*sinAngle+dy*cosAngle)
	Return v
End Function

Function GetHeading2D(ax, ay, bx, by)
    PI = 3.1415926535
    x = bx - ax
    y = by - ay
    return Atan2(y, x) * (180 / PI)
End Function