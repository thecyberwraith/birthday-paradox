extends Control

var days: Array[Day] = []

@onready var month_option: OptionButton = $PanelContainer/HSplitContainer/MarginContainer/VBoxContainer/HBoxContainer/MonthInput
@onready var day_option: SpinBox = $PanelContainer/HSplitContainer/MarginContainer/VBoxContainer/HBoxContainer/DayInput
@onready var add_button: Button = $PanelContainer/HSplitContainer/MarginContainer/VBoxContainer/HBoxContainer/AddNewDayButton

@onready var frequencyTable: FrequencyTable = $PanelContainer/HSplitContainer/MarginContainer/VBoxContainer/ScrollContainer/FrequencyTable
@onready var fancyDisplay: FancyDateDisplay = $PanelContainer/HSplitContainer/FancyDateDisplay

signal new_day_set_found
signal new_day_added

func _ready() -> void:
	month_option.item_selected.connect(_month_selected)
	add_button.pressed.connect(_day_added)
	
	var consumers = [frequencyTable, fancyDisplay]
	
	for consumer in consumers:
		new_day_set_found.connect(consumer.populate_days)
	
	for i in CALENDAR.Months.size():
		month_option.add_item(CALENDAR.Months[i].name, i)

	month_option.select(0)
	_month_selected(0)

func _month_selected(idx: int) -> void:
	day_option.max_value = CALENDAR.Months[idx].max_days

func _day_added() -> void:
	var day = Day.new(CALENDAR.Months[month_option.selected], int(day_option.value))
	days.append(day)
	
	var results = _create_day_decomposition()
	
	new_day_set_found.emit(results[0], results[1])
	new_day_added.emit(day)
	
## Returns the unique days in an array, and a dictionary from days to counts.
## The unique days are ordered from most frequent to least.
func _create_day_decomposition():
	var day_counts: Dictionary = Dictionary()
	var ordered_days: Array[Day] = []
	
	for day in days:
		var key = day._to_string()
		
		if not key in day_counts:
			day_counts[key] = 0
			ordered_days.append(day)
		
		day_counts[key] += 1
	
	ordered_days.sort_custom(func freqSort(x,y):
		if day_counts[x.to_string()] > day_counts[y._to_string()]:
			return true
		return false
		)
	
	return [ordered_days, day_counts]
