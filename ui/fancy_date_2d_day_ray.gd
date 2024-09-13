@tool
extends Polygon2D

class_name FancyDateDayRay

## The number of vertices per hemisphere.
@export_range(2,100,1,"or_greater") var segments: int = 10 :
	set(value):
		segments = value
		_reset_vertices()

## Sets the overall height of the ray. Must be larger than the width.
@export_range(0,512,1,"or_greater") var height: int = 40 :
	set(value):
		if value < width:
			height = width
		height = value
		_reset_vertices()

## Sets the thickness of the ray. Must be smaller than the height.
@export_range(0,512,1,"or_greater") var width: int = 5 :
	set(value):
		if value > height:
			value = height
		width = value
		_reset_vertices()

func _reset_vertices():
	var vertices: Array[Vector2] = []
	var half = segments / 2
	var radius = width / 2
	var base_offset = Vector2.UP * radius
	
	for i in segments:
		var angle: float = i*PI/(segments-1)
		vertices.append(base_offset + Vector2.from_angle(angle)*radius)
	
	base_offset += Vector2.UP * (height - width)
	for i in segments:
		var angle: float = i*PI/(segments-1) + PI
		vertices.append(base_offset + Vector2.from_angle(angle)*radius)
	
	polygon = vertices
