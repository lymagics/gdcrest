extends RefCounted

var _value: Variant


func _init(value: Variant) -> void:
	_value = value


func _to_string() -> String:
	return _object() if typeof(_value) == TYPE_OBJECT else type_string(typeof(_value))


func _object() -> String:
	return _script() if is_instance_valid(_value) else "freed Object"


func _script() -> String:
	var instance: Object = _value
	var script: Script = instance.get_script()
	var label: String = String(script.get_global_name()) if script != null else ""
	var native: String = instance.get_class()
	return native if label.is_empty() else label
