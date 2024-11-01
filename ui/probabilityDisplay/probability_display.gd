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
	
	_update_stored_probability(max_collisions_present+1, sorted_days.size()+1)
	
	empirical_label.text = "Probability next collides with x others:"
	
	for i in range(max_collisions_present+1):
		empirical_container.add_child(_create_empirical_probability(i, frequencies))

func _update_stored_probability(collisions: int, samples: int) -> void:
	var probability = "No data"
	var key = "%s" % collisions
	if key in probabilities["colliding"]:
		var data = probabilities["colliding"][key]

		if samples < collisions:
			probability = "0 %"
		elif samples < data["start"]:
			probability = "~0 %"
		elif (samples > data["start"] + data["probabilities"].size()):
			if data["probabilities"][-1] > 99.99:
				probability = ">99.9999%"
			else:
				probability = "?"
		else:
			probability = ("%s" % data["probabilities"][samples-data["start"]]) + " %"
	
	theoretical_label.text = "Uniform probability next is %s colliding in %s choices: %s" % [
		collisions,
		samples,
		probability
	]

func _create_empirical_probability(collisions: int, frequencies: Dictionary) -> Label:
	var label := Label.new()
	var options := 0
	for day in frequencies:
		if frequencies[day] == collisions:
			options += 1
	
	if collisions == 0:
		options = Calendar.DAYS_IN_YEAR - frequencies.size()

	label.text = "[x=%s has %s]" % [collisions, options]
	print("Option ", label.text)
	return label
