extends RefCounted

const Kind := preload("res://addons/gdcrest/core/kind.gd")
const Literal := preload("res://addons/gdcrest/core/literal.gd")

var _value: Variant


func _init(value: Variant) -> void:
	_value = value


func _to_string() -> String:
	var text: String = _text()
	return text if text.length() <= 200 else text.left(100) + "..." + text.right(97)


func _text() -> String:
	var kind: int = typeof(_value)
	var lists: Array[int] = [
		TYPE_ARRAY,
		TYPE_PACKED_BYTE_ARRAY,
		TYPE_PACKED_INT32_ARRAY,
		TYPE_PACKED_INT64_ARRAY,
		TYPE_PACKED_FLOAT32_ARRAY,
		TYPE_PACKED_FLOAT64_ARRAY,
		TYPE_PACKED_STRING_ARRAY,
		TYPE_PACKED_VECTOR2_ARRAY,
		TYPE_PACKED_VECTOR3_ARRAY,
		TYPE_PACKED_COLOR_ARRAY,
		TYPE_PACKED_VECTOR4_ARRAY,
	]
	var renderers: Dictionary[int, Callable] = {
		TYPE_NIL: func() -> String: return "null",
		TYPE_STRING: _quoted,
		TYPE_STRING_NAME: func() -> String: return "&" + _quoted(),
		TYPE_FLOAT: _decimal,
		TYPE_DICTIONARY: _dictionary,
		TYPE_OBJECT: _object,
	}
	var renderer: Callable = _list if kind in lists else renderers.get(kind, _plain)
	return renderer.call()


func _plain() -> String:
	return str(_value)


func _quoted() -> String:
	return (
		'"'
		+ (String(_value).replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n").replace(
			"\t", "\\t"
		))
		+ '"'
	)


func _decimal() -> String:
	var number: float = _value
	var text: String = var_to_str(number)
	var finite: String = (
		text
		if text.contains(".")
		else text.replace("e", ".0e") if text.contains("e") else text + ".0"
	)
	var signed: String = (
		"-" + finite if number == 0.0 and String.num(number).begins_with("-") else finite
	)
	return (
		"NAN"
		if is_nan(number)
		else ("INF" if number > 0.0 else "-INF") if is_inf(number) else signed
	)


func _list() -> String:
	var items: Array = Array(_value)
	return "[" + _joined(items.slice(0, 20).map(_rendered), items.size()) + "]"


func _dictionary() -> String:
	var entries: Dictionary = _value
	var keys: Array = entries.keys().slice(0, 20)
	var pairs: Array = keys.map(
		func(key: Variant) -> String: return _rendered(key) + ": " + _rendered(entries[key])
	)
	return "{" + _joined(pairs, entries.size()) + "}"


func _joined(parts: Array, total: int) -> String:
	var text: String = ", ".join(PackedStringArray(parts))
	return text if total <= parts.size() else text + ", ... (%d more)" % (total - parts.size())


func _rendered(item: Variant) -> String:
	return str(Literal.new(item))


func _object() -> String:
	var custom: bool = is_instance_valid(_value) and (_value as Object).has_method("_to_string")
	return str(_value) if custom else "<%s#%d>" % [Kind.new(_value), _identity()]


func _identity() -> int:
	return (_value as Object).get_instance_id() if is_instance_valid(_value) else 0
