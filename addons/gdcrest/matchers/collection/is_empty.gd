class_name IsEmpty
extends Matcher

const Items := preload("res://addons/gdcrest/core/items.gd")
const Literal := preload("res://addons/gdcrest/core/literal.gd")
const Misfit := preload("res://addons/gdcrest/core/misfit.gd")


func matches(actual: Variant) -> bool:
	return _sized(actual) and _size(actual) == 0


func description() -> String:
	return "an empty collection"


func mismatch(actual: Variant) -> String:
	return (
		"was %s" % Literal.new(actual)
		if typeof(actual) == TYPE_STRING
		else _counted(_size(actual)) if _sized(actual) else str(Misfit.new(actual))
	)


func _sized(actual: Variant) -> bool:
	return typeof(actual) in [TYPE_STRING, TYPE_DICTIONARY] or Items.new(actual).sequential()


func _size(actual: Variant) -> int:
	return String(actual).length() if typeof(actual) == TYPE_STRING else int(actual.size())


func _counted(size: int) -> String:
	return "had 1 item" if size == 1 else "had %d items" % size
