extends SubViewportContainer

class_name FancyDateDisplay

@onready var dateScene: FancyDate2DScene = $SubViewport/FancyDate2DScene

func _ready() -> void:
	var set_diameter: Callable = func ():
		dateScene.on_diameter_change(min(size.x, size.y))
	
	set_diameter.call()
	
	connect("resized", set_diameter)

func populate_days(days, counts) -> void:
	dateScene.populate_day_rays(days, counts)
