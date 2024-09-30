extends Node

const DATASET_DIR = "user://datasets/"
const NEW_SAVE_ID = 0

## Called when new data is provided to completely replace the old data.
signal repopulate_data(day_list: Array[Day], sorted_days: Array[Day], frequencies: Dictionary)

## Called when a single new day is added.
signal new_day_added(day: Day, sorted_days: Array[Day], frequencies: Dictionary)

var window_scene: PackedScene = preload("res://ui/popups/ChooseSaveFileNameWindow.tscn")

## External Read Only
var days_list: Array[Day] = []

## Returns the unique days in an array, and a dictionary from days to counts.
## The unique days are ordered from most frequent to least.
func _create_day_frequency_and_sort():
	var day_counts: Dictionary = Dictionary()
	var ordered_days: Array[Day] = []
	
	for day in days_list:
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

func add_day_to_dataset(day: Day):
	days_list.append(day)
	var aggregate = _create_day_frequency_and_sort()
	new_day_added.emit(day, aggregate[0], aggregate[1])

func load_dataset_names() -> Array[String]:
	if not DirAccess.dir_exists_absolute(DATASET_DIR):
		DirAccess.make_dir_absolute(DATASET_DIR)
		return []
	
	var names: Array[String] = []
	
	for item in DirAccess.get_files_at(DATASET_DIR):
		names.append(item)
	
	return names

func populate_menu(menu: PopupMenu) -> void:
	var filenames = load_dataset_names()
	
	menu.add_item("New", NEW_SAVE_ID)
	
	if filenames.size() > 0:
		var load_menu = PopupMenu.new()
		load_menu.name = "Load"
		for i in filenames.size():
			load_menu.add_item(filenames[i], i)
		load_menu.id_pressed.connect(_load_dataset_by_index)
		menu.add_submenu_node_item("Load", load_menu)
	
	var save_menu = PopupMenu.new()

	for i in filenames.size():
		save_menu.add_item(filenames[i], i)
	
	save_menu.add_item("New Dataset", filenames.size())
	
	save_menu.id_pressed.connect(_save_dataset_to_index)
	menu.add_submenu_node_item("Save", save_menu)
	
	menu.id_pressed.connect(_reset_data)

func _reset_data(_idx: int) -> void:
	print('Resetting the data.')
	days_list = []
	repopulate_data.emit(days_list, days_list, Dictionary())

func _load_dataset_by_index(idx: int) -> void:
	_load_dataset_from_file(load_dataset_names()[idx])

func _save_dataset_to_index(idx: int) -> void:
	var filenames = load_dataset_names()
	if idx == filenames.size():
		print('Saving to new file')
		var window: ChooseSaveFileNameWindow = window_scene.instantiate()
		get_tree().root.add_child(window)
		window.accepted.connect(_save_dataset_to_file)
		window.show_and_avoid_list(filenames)
	else:
		_save_dataset_to_file(filenames[idx])

### File Saving/Writing Methods
const VERSION = 1

func _save_dataset_to_file(filename: String) -> void:
	var file: FileAccess = FileAccess.open(DATASET_DIR + filename, FileAccess.WRITE)
	file.store_8(VERSION)
	for day in days_list:
		var ordinal = Calendar.day_to_ordinal(day)
		file.store_8(ordinal)
	print('Data saved with version %s to file %s' % [VERSION, DATASET_DIR + filename])

func _load_dataset_from_file(filename: String) -> void:
	var file: FileAccess = FileAccess.open(DATASET_DIR + filename, FileAccess.READ)
	var _version: int = file.get_8()
	
	days_list = []
	
	while file.get_position() < file.get_length():
		var ordinal = file.get_8()
		days_list.append(Day.from_ordinal(ordinal))
	
	var aggregate = _create_day_frequency_and_sort()
	repopulate_data.emit(days_list, aggregate[0], aggregate[1])
