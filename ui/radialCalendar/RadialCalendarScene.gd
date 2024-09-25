extends Node2D

class_name FancyDate2DScene

const MAX_LENGTH_FACTOR = 0.9
const MIN_LENGTH_FACTOR = 0.05

const RESOLUTION = 1080
const RAY_LENGTH_MAX = RESOLUTION * MAX_LENGTH_FACTOR / 2.0
const RAY_LENGTH_MIN = RESOLUTION * MIN_LENGTH_FACTOR / 2.0

const RPM = 2.0

@onready var days: Node2D = $Days

@export var day_gradient: Gradient

func _process(delta):
	rotate(delta * RPM / 60 * 2*PI)

func on_diameter_change(diameter: int) -> void:
	scale = Vector2(1,1) * (diameter * 1.0 / RESOLUTION)

## Takes an iterable of days and produces a ray for each.
func populate_day_rays(new_days: Array[Day], counts):
	for child in days.get_children():
		child.queue_free()
		
	if new_days.size() == 0:
		return
		
	var min_diff: int = _get_min_difference_between_days(new_days)
	var ANGLE: float = min(PI/8, 2*PI*(min_diff*1.0/CALENDAR.DAYS_IN_YEAR))
		
	var max_frequency = counts[new_days[0]._to_string()]
		
	for day in new_days:
		var length = 1.0 * counts[day._to_string()] / max_frequency * RAY_LENGTH_MAX
		var ray: RadialCalendarDayRay = RadialCalendarDayRay.new(ANGLE, RAY_LENGTH_MIN, length)
		ray.color = day_gradient.sample(CALENDAR.day_to_float(day))
		var angle = 2*PI*CALENDAR.day_to_float(day)
		ray.rotate(angle)
		ray.translate(Vector2.from_angle(angle) * RAY_LENGTH_MIN)

		days.add_child(ray)

## Get the smallest number of days between any two unique days in the list
func _get_min_difference_between_days(new_days: Array[Day]) -> int:
	var day_set = Dictionary()
	for day: Day in new_days:
		day_set[day] = null
	
	var day_ords = []
	for day: Day in day_set.keys():
		day_ords.push_back(CALENDAR.day_to_ordinal(day))
	
	day_ords.sort()
	
	var min_diff: int = CALENDAR.DAYS_IN_YEAR
	for i in day_ords.size():
		var diff: int = wrapi(day_ords[wrapi(i+1,0,day_ords.size())] - day_ords[i],0,CALENDAR.DAYS_IN_YEAR)
		if diff < min_diff:
			min_diff = diff
	
	if day_set.size() == 1:
		min_diff = CALENDAR.DAYS_IN_YEAR
	
	return min_diff
