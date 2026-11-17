class_name IsNot
extends Matcher

const Literal := preload("res://addons/gdcrest/core/literal.gd")

var _origin: Matcher


func _init(origin: Matcher) -> void:
	_origin = origin


func matches(actual: Variant) -> bool:
	return not _origin.matches(actual)


func description() -> String:
	return "not " + _origin.description()


func mismatch(actual: Variant) -> String:
	return "was %s" % Literal.new(actual)
