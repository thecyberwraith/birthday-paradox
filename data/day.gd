extends Resource

class_name Day

@export var month: Month
@export var day: int :
	set(value):
		if month.max_days < value:
			value = month.max_days
		elif value < 1:
			value = 1
		day = value

func _init(p_month=Month.new("January", "JAN", 31, 1), p_day=1):
	month = p_month
	day = p_day

func _to_string() -> String:
	return "%s %s" % [month.name, day]

static func from_ordinal(ordinal: int) -> Day:
	assert(ordinal > 0 and ordinal <= Calendar.DAYS_IN_YEAR)
	var new_month = null
	for m in Calendar.Months:
		new_month = m
		if ordinal <= m.max_days:
			break
		ordinal -= m.max_days
	
	return Day.new(new_month, ordinal)
