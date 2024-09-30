extends PanelContainer

@onready var label: Label = $VBoxContainer/Label
@onready var daysContainer: HFlowContainer = $VBoxContainer/DaysContainer

var days: Dictionary = Dictionary()
var frequency: int = 0

func populate(p_frequency: int, p_days: Dictionary):
	days = p_days
	frequency = p_frequency

func _ready() -> void:
	label.text = "Frequency %s" % [frequency]
	
	for child in daysContainer.get_children():
		child.queue_free()
	
	var sorted_days: Array[Day] = []
	for d in days.values():
		sorted_days.append(d)
	
	sorted_days.sort_custom(func (x,y):
		return Calendar.day_to_ordinal(x) < Calendar.day_to_ordinal(y)
	)
	for day in sorted_days:
		var day_label = Label.new()
		day_label.text = day._to_string()
		daysContainer.add_child(day_label)
