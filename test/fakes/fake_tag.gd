class_name FakeTag
extends RefCounted

var _label: String


func _init(label: String) -> void:
	_label = label


func _to_string() -> String:
	return "tag " + _label
