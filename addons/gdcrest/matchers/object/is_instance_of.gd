class_name IsInstanceOf
extends Matcher

const Kind := preload("res://addons/gdcrest/core/kind.gd")

var _type: Variant


func _init(type: Variant) -> void:
	_type = type


func matches(actual: Variant) -> bool:
	return _valid() and is_instance_of(actual, _type)


func description() -> String:
	return "an instance of %s" % _named()


func mismatch(actual: Variant) -> String:
	var kind: String = str(Kind.new(actual))
	return "was null" if actual == null else "was %s %s" % [_article(kind), kind]


func _valid() -> bool:
	return (
		(typeof(_type) == TYPE_INT and int(_type) >= 0 and int(_type) < TYPE_MAX)
		or _type is Script
		or (typeof(_type) == TYPE_OBJECT and _native())
	)


func _native() -> bool:
	return is_instance_valid(_type) and (_type as Object).get_class() == "GDScriptNativeClass"


func _named() -> String:
	return (
		type_string(int(_type))
		if typeof(_type) == TYPE_INT
		else _scripted() if _type is Script else "a native class"
	)


func _scripted() -> String:
	var script: Script = _type
	var label: String = script.get_global_name()
	return script.resource_path.get_file() if label.is_empty() else label


func _article(kind: String) -> String:
	return "an" if kind.left(1).to_lower() in ["a", "e", "i", "o", "u"] else "a"
