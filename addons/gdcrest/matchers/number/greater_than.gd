class_name GreaterThan
extends Matcher

const Literal := preload("res://addons/gdcrest/core/literal.gd")
const Misfit := preload("res://addons/gdcrest/core/misfit.gd")

var _bound: float


func _init(bound: float) -> void:
	_bound = bound


func matches(actual: Variant) -> bool:
	return typeof(actual) in [TYPE_INT, TYPE_FLOAT] and float(actual) > _bound


func description() -> String:
	return "a number greater than %s" % Literal.new(_bound)


func mismatch(actual: Variant) -> String:
	return (
		"was %s" % Literal.new(actual)
		if typeof(actual) in [TYPE_INT, TYPE_FLOAT]
		else str(Misfit.new(actual))
	)
