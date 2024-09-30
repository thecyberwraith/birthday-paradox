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
