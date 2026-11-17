class_name IsEven
extends Matcher


func matches(actual: Variant) -> bool:
	return actual is int and int(actual) % 2 == 0


func description() -> String:
	return "an even int"


func mismatch(actual: Variant) -> String:
	return "was %d, an odd int" % actual if actual is int else "was %s" % [actual]
