class_name StartsWith
extends Matcher

const Literal := preload("res://addons/gdcrest/core/literal.gd")
const Misfit := preload("res://addons/gdcrest/core/misfit.gd")

var _prefix: String


func _init(prefix: String) -> void:
	_prefix = prefix


func matches(actual: Variant) -> bool:
	return typeof(actual) == TYPE_STRING and String(actual).begins_with(_prefix)


func description() -> String:
	return "a text starting with %s" % Literal.new(_prefix)


func mismatch(actual: Variant) -> String:
	return (
		"was %s" % Literal.new(actual) if typeof(actual) == TYPE_STRING else str(Misfit.new(actual))
	)
