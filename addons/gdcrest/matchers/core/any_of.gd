class_name AnyOf
extends Matcher

const Literal := preload("res://addons/gdcrest/core/literal.gd")

var _matchers: Array[Matcher]


func _init(matchers: Array[Matcher]) -> void:
	_matchers = matchers


func matches(actual: Variant) -> bool:
	return _matchers.any(func(matcher: Matcher) -> bool: return matcher.matches(actual))


func description() -> String:
	return " or ".join(
		PackedStringArray(
			_matchers.map(func(matcher: Matcher) -> String: return matcher.description())
		)
	)


func mismatch(actual: Variant) -> String:
	return "was %s" % Literal.new(actual)
