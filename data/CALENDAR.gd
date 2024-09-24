extends Node

var Months: Array[Month] = [
	Month.new("January", "JAN", 31, 1),
	Month.new("February", "FEB", 29, 2),
	Month.new("March", "MAR", 31, 3),
	Month.new("April", "APR", 30, 4),
	Month.new("May", "MAY", 31, 5),
	Month.new("June", "JUN", 30, 6),
	Month.new("July", "JUL", 31, 7),
	Month.new("August", "AUG", 31, 8),
	Month.new("September", "SEP", 30, 9),
	Month.new("October", "OCT", 31, 10),
	Month.new("November", "NOV", 30, 11),
	Month.new("December", "DEC", 31, 12)
]

var DAYS_IN_YEAR: int = 366

## Takes a day from the standard calendar and returns the
## ordinal (count from Jan 1) to the end of the year (366 days).
func day_to_ordinal(day: Day) -> int:
	var days: int = 0
	for month in Months:
		if day.month == month:
			break
		
		days += month.max_days

	return days + day.day

func day_to_float(day: Day) -> float:
	return (day_to_ordinal(day) - 1.0) / DAYS_IN_YEAR
