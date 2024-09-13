extends SubViewportContainer

class_name FancyDateDisplay

@onready var dateScene: FancyDate2DScene = $SubViewport/FancyDate2DScene

func _ready() -> void:
	var set_radius: Callable = func ():
		dateScene.radius = min(size.x, size.y) / 2.0
	
	set_radius.call()
	
	connect("resized", set_radius)

func populate_days(days: Array[Day]) -> void:
	pass
