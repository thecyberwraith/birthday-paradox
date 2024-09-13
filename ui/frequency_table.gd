extends VBoxContainer

class_name FrequencyTable

const freqRowTemplate = preload("res://ui/frequency_table_row.tscn")

func populate_days(data: Array[Day]) -> void:
	var day_counts: Dictionary = Dictionary()
	var ordered_days: Array[Day] = []
	
	for day in data:
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
	
	for child in get_children():
		child.queue_free()
	
	for day in ordered_days:
		var row = freqRowTemplate.instantiate()
		row.populate(day, day_counts[day._to_string()])
		add_child(row)
