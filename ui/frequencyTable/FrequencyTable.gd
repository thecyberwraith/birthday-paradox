extends VBoxContainer

class_name FrequencyTable

const freqRowTemplate = preload("res://ui/frequencyTable/FrequencyTableRow.tscn")

func populate_days(days: Array[Day], counts: Dictionary) -> void:
	for child in get_children():
		child.queue_free()
	
	var striated = Dictionary()
	
	for day in days:
		var count = counts[day._to_string()]
		
		if not striated.has(count):
			striated[count] = Dictionary()
		
		striated[count][day._to_string()] = day
	
	var sorted_keys = striated.keys()
	
	sorted_keys.sort()
	sorted_keys.reverse()
	
	for count in sorted_keys:
		var row = freqRowTemplate.instantiate()
		row.populate(count, striated[count])
		add_child(row)
