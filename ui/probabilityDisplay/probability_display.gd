extends Control

func _ready() -> void:
	print(probability_of_collisions(365, 1, 23))


###############################################
### Beyond here be mathematical dragons
###############################################
class Partition:
	var elements: Array[int]
	
	func _init(parts: Array[int] = []) -> void:
		self.elements = parts

	func grow_all() -> void:
		for i in range(len(self.elements)):
			self.elements[i] += 1
	
	func add_part() -> void:
		self.elements.append(1)

	func sum() -> int:
		var value: int = 0
		for part in self.elements:
			value += part
		
		return value
	
	func length() -> int:
		return len(self.elements)

	func _to_string() -> String:
		return "Part: %s" % self.elements
	
	func max_part_size() -> int:
		if self.num_parts() == 0:
			return 0
		
		return self.elements[0]
	
	func num_parts() -> int:
		return len(self.elements)

func partitions_with_at_most_N_parts_bounded_by_k(n: int, max_parts: int, max_part_size: int) -> Array[Partition]:
	var partitions: Array[Partition] = []
	for i in range(1,min(n, max_parts)+1):
		partitions.append_array(partitions_with_fixed_parts_bounded_by_k(n, i, max_part_size))
	
	return partitions

func partitions_with_fixed_parts_bounded_by_k(n: int, parts: int, max_part_size: int) -> Array[Partition]:
	if max_part_size <= 0:
		return []
	if n == parts:
		var new_parts: Array[int] = []
		for _i in range(n):
			new_parts.append(1)
		return [Partition.new(new_parts)] # Return n parts each of size 1
	elif parts == 1:
		if max_part_size >= n:
			return [Partition.new([n])]  # There is only one way to have a partitions with one part.
		return []
	elif parts > n:
		return []

	# Otherwise, recurse.

	var new_partitions: Array[Partition] = []
	# Consider children partitions where we add one to each partition
	# Since we increase the size of all these partitions, we must require
	# that the parts are k-1 in size or smaller, otherwise we will make
	# them too big.
	for partition in partitions_with_fixed_parts_bounded_by_k(n-parts, parts, max_part_size-1):
		partition.grow_all()
		new_partitions.append(partition)

	# Consider children partitions where we add a new partition. We
	# do not modify the part sizes, so we don't need to change the part
	# size bound.
	for partition in partitions_with_fixed_parts_bounded_by_k(n-1, parts-1, max_part_size):
		partition.add_part()
		new_partitions.append(partition)
	
	return new_partitions

## Used to define a ratio of products of factorials. The evaluation deferred.
class FactorialRatio:
	var numerator: Array[int]
	var denominator: Array[int]
	
	func _init():
		numerator = []
		denominator = []
	
	func multiply_by_factorial(int: n):
		numerator.append(n)
	
	func divide_by_factorial(int: n):
		denominator.append(n)

func factorial(n: int) -> int:
	if n < 0:
		push_error("Asked for factorial for negative integer!")
		return 0

	if not n in factorial_cache:
		factorial_cache[n] = n * factorial(n-1)

	return factorial_cache[n]

func number_of_sequences_with_partition_diagram(p: Partition, N: int):
	var ways_to_assign_index: int = factorial(p.sum())
	@warning_ignore("integer_division") # Mathematically, it is an integer
	var ways_to_assign_symbols: int = factorial(N) / factorial(N-p.length())# Handle assigning the 0 size blocks ahead of time

	var size_blocks: Dictionary = Dictionary()

	for part in p.elements:
		ways_to_assign_index /= factorial(part)
		if not part in size_blocks:
			size_blocks[part] = 0
			
		size_blocks[part] += 1
		for block in size_blocks.values():
			ways_to_assign_symbols /= factorial(block)

	return ways_to_assign_index * ways_to_assign_symbols

func probability_of_collisions(days_in_year: int, collision_size: int, samples: int) -> float:
	var count: int = 0
	for partition in partitions_with_at_most_N_parts_bounded_by_k(samples, days_in_year, collision_size):
		count += number_of_sequences_with_partition_diagram(partition, days_in_year)

	return 1 - (float(count) / float(days_in_year**samples))
