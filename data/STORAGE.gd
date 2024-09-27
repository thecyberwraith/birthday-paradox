extends Node

const DATASET_DIR = "user://datasets/"
const NEW_SAVE_ID = 0

signal repopulate_data(day_list: Array[Day])
signal new_day_added(day: Day)

var window_scene: PackedScene = preload("res://ui/popups/ChooseSaveFileNameWindow.tscn")

## Read Only
var days_list: Array[Day] = []

func add_day_to_dataset(day: Day):
	days_list.append(day)
	new_day_added.emit(day)

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
		var ordinal = CALENDAR.day_to_ordinal(day)
		print('Setting day ', ordinal)
		file.store_8(ordinal)
	print('Data saved with version %s to file %s' % [VERSION, DATASET_DIR + filename])

func _load_dataset_from_file(filename: String) -> void:
	var file: FileAccess = FileAccess.open(DATASET_DIR + filename, FileAccess.READ)
	var _version: int = file.get_8()
	
	days_list = []
	
	while file.get_position() < file.get_length():
		var ordinal = file.get_8()
		print('Getting day ', ordinal)
		days_list.append(Day.from_ordinal(ordinal))

	repopulate_data.emit(days_list)
