extends RefCounted

const Kind := preload("res://addons/gdcrest/core/kind.gd")
const Literal := preload("res://addons/gdcrest/core/literal.gd")

var _value: Variant


func _init(value: Variant) -> void:
	_value = value


func _to_string() -> String:
	return "was null" if _value == null else "was %s: %s" % [_typed(), Literal.new(_value)]


func _typed() -> String:
	var kind: String = str(Kind.new(_value))
	return ("an " if kind.left(1).to_lower() in ["a", "e", "i", "o", "u"] else "a ") + kind
