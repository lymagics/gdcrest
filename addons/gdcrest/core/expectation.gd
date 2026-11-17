extends Matcher

const Literal := preload("res://addons/gdcrest/core/literal.gd")

var _origin: Variant


func _init(origin: Variant) -> void:
	_origin = origin


func matches(actual: Variant) -> bool:
	return _matcher().matches(actual)


func description() -> String:
	return (_origin as Matcher).description() if _origin is Matcher else str(Literal.new(_origin))


func mismatch(actual: Variant) -> String:
	return _matcher().mismatch(actual)


func _matcher() -> Matcher:
	return _origin if _origin is Matcher else IsEqual.new(_origin)
