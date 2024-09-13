extends VBoxContainer

class_name FrequencyTable

const freqRowTemplate = preload("res://ui/frequency_table_row.tscn")

func populate_days(days: Array[Day], counts: Dictionary) -> void:
	for child in get_children():
		child.queue_free()
	
	for day in days:
		var row = freqRowTemplate.instantiate()
		row.populate(day, counts[day._to_string()])
		add_child(row)
