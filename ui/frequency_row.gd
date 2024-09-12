extends PanelContainer

@onready var label: Label = $HBoxContainer/Label

var day: Day = Day.new(Month.new("?", "?", 1, 1))
var frequency: int = 0

func populate(p_day: Day, p_frequency: int):
	day = p_day
	frequency = p_frequency

func _ready() -> void:
	label.text = "%s has frequency %s" % [day._to_string(), frequency]
