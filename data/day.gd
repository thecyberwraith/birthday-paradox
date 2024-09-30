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

## Takes a day from the standard calendar and returns the
## ordinal (count from Jan 1) to the end of the year (366 days).
func to_ordinal() -> int:
	var days: int = 0
	for a_month in Calendar.Months:
		if month == a_month:
			break
		
		days += a_month.max_days

	return days + day

## Takes the ordinal and converts it to a number between 0 (inclusive) and 1
## (exclusive)
func to_float() -> float:
	return (to_ordinal() - 1.0) / Calendar.DAYS_IN_YEAR
