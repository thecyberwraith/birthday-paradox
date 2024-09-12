extends Resource

class_name Month

@export var max_days: int
@export var name: String
@export var abbr: String
@export var ordinal: int

func _init(p_name = "MONTH", p_abbr = "Abbreviation", p_max = 30, p_ord = 0):
	max_days = p_max
	name = p_name
	abbr = p_abbr
	ordinal = p_ord
