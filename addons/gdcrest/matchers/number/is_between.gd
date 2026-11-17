class_name IsBetween
extends Matcher

const Literal := preload("res://addons/gdcrest/core/literal.gd")
const Misfit := preload("res://addons/gdcrest/core/misfit.gd")

var _low: float
var _high: float


func _init(low: float, high: float) -> void:
	_low = low
	_high = high


func matches(actual: Variant) -> bool:
	return (
		typeof(actual) in [TYPE_INT, TYPE_FLOAT]
		and _low <= float(actual)
		and float(actual) <= _high
	)


func description() -> String:
	return "a number from %s to %s" % [Literal.new(_low), Literal.new(_high)]


func mismatch(actual: Variant) -> String:
	return (
		"was %s, %s" % [Literal.new(actual), _side(float(actual))]
		if typeof(actual) in [TYPE_INT, TYPE_FLOAT]
		else str(Misfit.new(actual))
	)


func _side(number: float) -> String:
	return (
		"below %s" % Literal.new(_low)
		if number < _low
		else "above %s" % Literal.new(_high) if number > _high else "not a number"
	)
