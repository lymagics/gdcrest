class_name EndsWith
extends Matcher

const Literal := preload("res://addons/gdcrest/core/literal.gd")
const Misfit := preload("res://addons/gdcrest/core/misfit.gd")

var _suffix: String


func _init(suffix: String) -> void:
	_suffix = suffix


func matches(actual: Variant) -> bool:
	return typeof(actual) == TYPE_STRING and String(actual).ends_with(_suffix)


func description() -> String:
	return "a text ending with %s" % Literal.new(_suffix)


func mismatch(actual: Variant) -> String:
	return (
		"was %s" % Literal.new(actual) if typeof(actual) == TYPE_STRING else str(Misfit.new(actual))
	)
