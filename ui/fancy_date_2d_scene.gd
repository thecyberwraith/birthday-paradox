extends Node2D

class_name FancyDate2DScene

var radius: int:
	set(value):
		radius = value
		_on_radius_changed()

var ray_length: float:
	get:
		return 0.6 * radius

@onready var center: Sprite2D = $CenterCircle
@onready var days: Node2D = $Days

@export var day_gradient: Gradient

func _on_radius_changed() -> void:
	var center_diameter = 0.25 * radius
	var factor = center_diameter / center.texture.get_width()
	center.scale.x = factor
	center.scale.y = factor


## Takes an iterable of days and produces a ray for each.
func populate_day_rays(new_days, counts):
	for child in days.get_children():
		child.queue_free()
		
	if new_days.size() == 0:
		return
	
	var max_days = counts[new_days[0]._to_string()]
		
	for day in new_days:
		var length: int = int(1.0 * counts[day._to_string()] / max_days * ray_length)
		var ray: FancyDateDayRay = FancyDateDayRay.new(3, 3, length)
		ray.color = day_gradient.sample(CALENDAR.day_to_float(day))
		ray.antialiased = true
		var angle = 2*PI*CALENDAR.day_to_float(day)
		ray.rotate(angle)
		ray.translate(Vector2.from_angle(angle) * radius * 0.25)

		days.add_child(ray)

func _ready() -> void:
	_on_radius_changed()
