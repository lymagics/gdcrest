class_name HasLength
extends Matcher

const Expectation := preload("res://addons/gdcrest/core/expectation.gd")
const Items := preload("res://addons/gdcrest/core/items.gd")
const Misfit := preload("res://addons/gdcrest/core/misfit.gd")

var _length: Variant


func _init(length: Variant) -> void:
	_length = length


func matches(actual: Variant) -> bool:
	return _sized(actual) and Expectation.new(_length).matches(_size(actual))


func description() -> String:
	return "a collection with length %s" % Expectation.new(_length).description()


func mismatch(actual: Variant) -> String:
	return "had length %d" % _size(actual) if _sized(actual) else str(Misfit.new(actual))


func _sized(actual: Variant) -> bool:
	return typeof(actual) in [TYPE_STRING, TYPE_DICTIONARY] or Items.new(actual).sequential()


func _size(actual: Variant) -> int:
	return String(actual).length() if typeof(actual) == TYPE_STRING else int(actual.size())
