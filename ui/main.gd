extends Control

var days: Array[Day] = []

@onready var month_option: OptionButton = $PanelContainer/HSplitContainer/MarginContainer/VBoxContainer/HBoxContainer/MonthInput
@onready var day_option: SpinBox = $PanelContainer/HSplitContainer/MarginContainer/VBoxContainer/HBoxContainer/DayInput
@onready var add_button: Button = $PanelContainer/HSplitContainer/MarginContainer/VBoxContainer/HBoxContainer/AddNewDayButton

@onready var frequencyTable: FrequencyTable = $PanelContainer/HSplitContainer/MarginContainer/VBoxContainer/ScrollContainer/FrequencyTable
@onready var fancyDisplay: FancyDateDisplay = $PanelContainer/HSplitContainer/FancyDateDisplay

func _ready() -> void:
	month_option.connect("item_selected", _month_selected)
	add_button.connect("pressed", _day_added)
	
	for i in CALENDAR.Months.size():
		month_option.add_item(CALENDAR.Months[i].name, i)

	month_option.select(0)
	_month_selected(0)

func _month_selected(idx: int) -> void:
	day_option.max_value = CALENDAR.Months[idx].max_days

func _day_added() -> void:
	var day = Day.new(CALENDAR.Months[month_option.selected], int(day_option.value))
	days.append(day)
	
	frequencyTable.populate_data(days)
