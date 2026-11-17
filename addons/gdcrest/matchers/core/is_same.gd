class_name IsSame
extends Matcher

const Literal := preload("res://addons/gdcrest/core/literal.gd")
const Misfit := preload("res://addons/gdcrest/core/misfit.gd")

var _expected: Object


func _init(expected: Object) -> void:
	_expected = expected


func matches(actual: Variant) -> bool:
	return typeof(actual) == TYPE_OBJECT and is_same(actual, _expected)


func description() -> String:
	return "the same instance as %s" % Literal.new(_expected)


func mismatch(actual: Variant) -> String:
	return (
		"was another %s" % Literal.new(actual)
		if typeof(actual) == TYPE_OBJECT and actual != null
		else str(Misfit.new(actual))
	)
