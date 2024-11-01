extends Control

var probabilities
@onready var theoretical_label: Label = $VBoxContainer2/theoretical_label
@onready var empirical_label: Label = $VBoxContainer2/VBoxContainer/empirical_label
@onready var empirical_container: HBoxContainer = $VBoxContainer2/VBoxContainer/empirical_container

func _ready() -> void:
	load_probabilities_file()
	Storage.repopulate_data.connect(_repopulate_data)
	Storage.new_day_added.connect(_repopulate_data)

func load_probabilities_file() -> void:
	var file := FileAccess.open("res://data/birthday_probabilities.json", FileAccess.READ)
	var json := JSON.new()
	var error := json.parse(file.get_as_text())
	if error:
		push_error("Could not parse JSON file birthday_probabilites.json")
		return
	
	probabilities = json.data

func _repopulate_data(_unused, sorted_days: Array[Day], frequencies: Dictionary) -> void:
	for child in empirical_container.get_children():
		child.queue_free()
	
	if sorted_days.size() == 0:
		theoretical_label.text = "Waiting for data..."
		empirical_label.text = "Waiting for data..."
		return
	
	var max_collisions_present: int = frequencies.values().max()
	
	theoretical_label.text = "Uniform probability of %s collisions in %s choices" % [
		max_collisions_present,
		sorted_days.size()
	]
	
	empirical_label.text = "Probability of collision with x others:"
	
	for i in range(max_collisions_present+1):
		empirical_container.add_child(_create_empirical_probability(i, frequencies))

func _create_empirical_probability(collisions: int, _frequencies: Dictionary) -> RichTextLabel:
	var label := RichTextLabel.new()
	label.text = "%s shared %s" % [collisions, "?"]
	return label
