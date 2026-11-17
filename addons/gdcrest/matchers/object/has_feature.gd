class_name HasFeature
extends Matcher

const Misfit := preload("res://addons/gdcrest/core/misfit.gd")

var _method: String
var _matcher: Matcher


func _init(method: String, matcher: Matcher) -> void:
	_method = method
	_matcher = matcher


func matches(actual: Variant) -> bool:
	return _capable(actual) and _matcher.matches((actual as Object).call(_method))


func description() -> String:
	return "an object whose %s() is %s" % [_method, _matcher.description()]


func mismatch(actual: Variant) -> String:
	return (
		"%s() %s" % [_method, _matcher.mismatch((actual as Object).call(_method))]
		if _capable(actual)
		else _complaint(actual)
	)


func _capable(actual: Variant) -> bool:
	return _alive(actual) and (actual as Object).has_method(_method)


func _alive(actual: Variant) -> bool:
	return typeof(actual) == TYPE_OBJECT and is_instance_valid(actual)


func _complaint(actual: Variant) -> String:
	return "has no method %s()" % _method if _alive(actual) else str(Misfit.new(actual))
