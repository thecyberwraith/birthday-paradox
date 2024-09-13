@tool
extends Polygon2D

class_name FancyDateDayRay

## The number of vertices per hemisphere.
@export_range(2,100,1,"or_greater") var segments: int = 10 :
	set(value):
		segments = value
		_reset_vertices()

## Sets the overall length of the ray. Must be larger than the thickness.
@export_range(0,512,1,"or_greater") var length: int = 40 :
	set(value):
		if value < thick:
			length = thick
		length = value
		_reset_vertices()

## Sets the thickness of the ray. Must be smaller than the length.
@export_range(0,512,1,"or_greater") var thick: int = 5 :
	set(value):
		if value > length:
			value = length
		thick = value
		_reset_vertices()

func _init(p_segs=5, p_thick=5, p_length=10):
	segments = p_segs
	thick = p_thick
	length = p_length

func _reset_vertices():
	var vertices: Array[Vector2] = []
	var radius = thick / 2.0
	var base_offset = Vector2.RIGHT * radius
	
	for i in segments:
		var angle: float = i*PI/(segments-1) + (PI/2)
		vertices.append(base_offset + Vector2.from_angle(angle)*radius)
	
	base_offset += Vector2.RIGHT * (length - thick)
	for i in segments:
		var angle: float = i*PI/(segments-1) + (3*PI/2)
		vertices.append(base_offset + Vector2.from_angle(angle)*radius)
		
	polygon = vertices

func _ready():
	_reset_vertices()
