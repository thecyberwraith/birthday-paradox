extends Control

var MONTHS: Array[Month] = [
	Month.new("January", "JAN", 31, 1),
	Month.new("February", "FEB", 29, 2),
	Month.new("March", "MAR", 31, 3),
	Month.new("April", "APR", 30, 4),
	Month.new("May", "MAY", 31, 5),
	Month.new("June", "JUN", 30, 6),
	Month.new("July", "JUL", 31, 7),
	Month.new("August", "AUG", 31, 8),
	Month.new("September", "SEP", 30, 9),
	Month.new("October", "OCT", 31, 10),
	Month.new("November", "NOV", 30, 11),
	Month.new("December", "DEC", 31, 12)
]

var days: Array[Day] = []

@onready var month_option: OptionButton = $PanelContainer/HSplitContainer/MarginContainer/VBoxContainer/HBoxContainer/MonthInput
@onready var day_option: SpinBox = $PanelContainer/HSplitContainer/MarginContainer/VBoxContainer/HBoxContainer/DayInput
@onready var add_button: Button = $PanelContainer/HSplitContainer/MarginContainer/VBoxContainer/HBoxContainer/AddNewDayButton

func _ready() -> void:
	month_option.connect("item_selected", _month_selected)
	add_button.connect("pressed", _day_added)
	
	for i in MONTHS.size():
		month_option.add_item(MONTHS[i].name, i)

	month_option.select(0)
	_month_selected(0)

func _month_selected(idx: int):
	day_option.max_value = MONTHS[idx].max_days

func _day_added():
	var day = Day.new(MONTHS[month_option.selected], int(day_option.value))
	days.append(day)
	print(days)
