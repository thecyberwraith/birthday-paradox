extends Window

## Lets user select a string that differs from given list of strings.
class_name ChooseSaveFileNameWindow

var _bad_names: Array[String] = []

@onready var line_edit: LineEdit = $MarginContainer/VBoxContainer/LineEdit
@onready var button: Button = $MarginContainer/VBoxContainer/Button

signal accepted(string: String)
signal cancelled

func _ready() -> void:
	line_edit.text_changed.connect(func (new_string: String):
		button.disabled = (new_string.length() == 0) or (new_string in _bad_names)
	)

func show_and_avoid_list(bad_names: Array[String]) -> void:
	_bad_names = bad_names
	close_requested.connect(func ():
		cancelled.emit()
		queue_free()
	)
	button.pressed.connect(func() :
		accepted.emit(line_edit.text)
		queue_free()
	)
