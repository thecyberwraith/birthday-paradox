extends Node

const DATASET_DIR = "user://datasets"

enum DataMenuItems {New, Load, Save}

signal repopulate_data(day_list: Array[Day])
signal new_day_added(day: Day)

## Read Only
var days_list: Array[Day] = []

func add_day_to_dataset(day: Day):
	days_list.append(day)
	new_day_added.emit(day)
func load_dataset_names() -> Array[String]:
	if not DirAccess.dir_exists_absolute(DATASET_DIR):
		return []
	
	var names: Array[String] = Array()
	
	for item in DirAccess.get_files_at(DATASET_DIR):
		names.append(item)
	
	return names

func populate_menu(menu: PopupMenu) -> void:
	var filenames = load_dataset_names()
	
	menu.add_item("New", DataMenuItems.New)
	
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

func _load_dataset_by_index(_idx: int) -> void:
	repopulate_data.emit(days_list)

func _save_dataset_to_index(idx: int) -> void:
	var filenames = load_dataset_names()
	if idx == filenames.size():
		print('Saving to new file')
	else:
		print('Saving to ', filenames[idx])
