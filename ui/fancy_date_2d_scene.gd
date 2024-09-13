extends Node2D

class_name FancyDate2DScene

var radius: int:
	set(value):
		radius = value
		_on_radius_changed()

@onready var center: Sprite2D = $CenterCircle
@onready var days: Node2D = $Days

func _on_radius_changed() -> void:
	var center_diameter = 0.25 * radius
	var factor = center_diameter / center.texture.get_width()
	center.scale.x = factor
	center.scale.y = factor

	for child in days.get_children():
		child.queue_free()
	
	var ray_length = 0.6 * radius
	
	const DAYS = 3
	for i in DAYS:
		var ray = FancyDateDayRay.new(3, 3, ray_length)

		var angle = 2*PI*i/DAYS
		ray.rotate(angle)
		ray.translate(Vector2.from_angle(angle) * radius * 0.25)

		days.add_child(ray)

## Takes an iterable of days and produces a ray for each.
func populate_day_rays(new_days, counts):
	print("Here come the days.")

func _ready() -> void:
	_on_radius_changed()
