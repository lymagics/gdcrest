extends RefCounted

var _value: Variant


func _init(value: Variant) -> void:
	_value = value


func sequential() -> bool:
	return (
		typeof(_value)
		in [
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
	)


func array() -> Array:
	assert(sequential(), "Items can't list a value that is neither an Array nor a packed array")
	return Array(_value)
