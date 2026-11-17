class_name IsCloseTo
extends Matcher

const Literal := preload("res://addons/gdcrest/core/literal.gd")
const Misfit := preload("res://addons/gdcrest/core/misfit.gd")

var _expected: float
var _delta: float


func _init(expected: float, delta: float) -> void:
	_expected = expected
	_delta = delta


func matches(actual: Variant) -> bool:
	return typeof(actual) in [TYPE_INT, TYPE_FLOAT] and _distance(actual) <= _delta


func description() -> String:
	return "a number within %s of %s" % [Literal.new(_delta), Literal.new(_expected)]


func mismatch(actual: Variant) -> String:
	return (
		"was %s, %s away" % [Literal.new(actual), Literal.new(_distance(actual))]
		if typeof(actual) in [TYPE_INT, TYPE_FLOAT]
		else str(Misfit.new(actual))
	)


func _distance(actual: Variant) -> float:
	return absf(float(actual) - _expected)
