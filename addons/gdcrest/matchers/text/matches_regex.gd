class_name MatchesRegex
extends Matcher

const Literal := preload("res://addons/gdcrest/core/literal.gd")
const Misfit := preload("res://addons/gdcrest/core/misfit.gd")

var _pattern: String


func _init(pattern: String) -> void:
	_pattern = pattern


func matches(actual: Variant) -> bool:
	return typeof(actual) == TYPE_STRING and _found(actual)


func description() -> String:
	return "a text matching the pattern %s" % Literal.new(_pattern)


func mismatch(actual: Variant) -> String:
	return (
		"was %s" % Literal.new(actual) if typeof(actual) == TYPE_STRING else str(Misfit.new(actual))
	)


func _found(text: String) -> bool:
	var expression: RegEx = RegEx.new()
	return expression.compile(_pattern) == OK and expression.search(text) != null
