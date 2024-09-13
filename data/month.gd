extends Resource

class_name Month

var max_days: int
var name: String
var abbr: String
var ordinal: int

func _init(p_name = "MONTH", p_abbr = "Abbreviation", p_max = 30, p_ord = 0):
	max_days = p_max
	name = p_name
	abbr = p_abbr
	ordinal = p_ord

func _to_string() -> String:
	return name
