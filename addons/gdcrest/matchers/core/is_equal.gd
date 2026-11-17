class_name IsEqual
extends Matcher

const Literal := preload("res://addons/gdcrest/core/literal.gd")
const Misfit := preload("res://addons/gdcrest/core/misfit.gd")

var _expected: Variant


func _init(expected: Variant) -> void:
	_expected = expected


func matches(actual: Variant) -> bool:
	return (
		typeof(actual) == typeof(_expected)
		and (_same_object(actual) if typeof(_expected) == TYPE_OBJECT else actual == _expected)
	)


func description() -> String:
	return "equal to %s" % Literal.new(_expected)


func mismatch(actual: Variant) -> String:
	return (
		"was %s" % Literal.new(actual)
		if typeof(actual) == typeof(_expected)
		else str(Misfit.new(actual))
	)


func _same_object(actual: Variant) -> bool:
	var alive: bool = is_instance_valid(actual) and is_instance_valid(_expected)
	return alive and _related(actual) and _equal(actual)


func _related(actual: Variant) -> bool:
	var script: Script = (_expected as Object).get_script()
	return (
		is_instance_of(actual, script)
		if script != null
		else (actual as Object).is_class((_expected as Object).get_class())
	)


func _equal(actual: Variant) -> bool:
	var expected: Object = _expected
	return (
		bool(expected.call("equal_to", actual))
		if expected.has_method("equal_to")
		else is_same(actual, expected)
	)
