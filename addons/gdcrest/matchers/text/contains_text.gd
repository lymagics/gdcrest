class_name ContainsText
extends Matcher

const Literal := preload("res://addons/gdcrest/core/literal.gd")
const Misfit := preload("res://addons/gdcrest/core/misfit.gd")

var _part: String


func _init(part: String) -> void:
	_part = part


func matches(actual: Variant) -> bool:
	return typeof(actual) == TYPE_STRING and String(actual).contains(_part)


func description() -> String:
	return "a text containing %s" % Literal.new(_part)


func mismatch(actual: Variant) -> String:
	return (
		"was %s" % Literal.new(actual) if typeof(actual) == TYPE_STRING else str(Misfit.new(actual))
	)
