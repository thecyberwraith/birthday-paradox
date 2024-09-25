@tool
extends Polygon2D

class_name RadialCalendarDayRay

## The angle spread for the ray.
@export_range(0.0001, PI) var angle: float = PI/16

@export_range(0,512,1,"or_greater") var inner_radius: float = 40 :
	set(value):
		#if value > outer_radius:
		#	value = outer_radius
		inner_radius = value
		_reset_vertices()

@export_range(0,512,1,"or_greater") var outer_radius: float = 100 :
	set(value):
		#if value < inner_radius:
		#	value = inner_radius
		outer_radius = value
		_reset_vertices()

func _init(p_angle: float =5, p_inner_radius: float =5, p_outer_radius: float=10):
	angle = p_angle
	inner_radius = p_inner_radius
	outer_radius = p_outer_radius
	_reset_vertices()

func _reset_vertices():
	var ray: Vector2 = Vector2.from_angle(angle / 2)
	var flip: Vector2 = ray.reflect(Vector2.RIGHT)
	
	polygon = [
		ray * inner_radius,
		ray * outer_radius,
		flip * outer_radius,
		flip * inner_radius
	]

func _ready():
	_reset_vertices()
