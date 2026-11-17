class_name IsApproximately
extends Matcher

const Literal := preload("res://addons/gdcrest/core/literal.gd")
const Misfit := preload("res://addons/gdcrest/core/misfit.gd")

var _expected: Variant


func _init(expected: Variant) -> void:
	_expected = expected


func matches(actual: Variant) -> bool:
	return _comparable(actual) and bool(actual.is_equal_approx(_expected))


func description() -> String:
	return "approximately %s" % Literal.new(_expected)


func mismatch(actual: Variant) -> String:
	return "was %s" % Literal.new(actual) if _comparable(actual) else str(Misfit.new(actual))


func _comparable(actual: Variant) -> bool:
	return (
		typeof(actual) == typeof(_expected)
		and (
			typeof(_expected)
			in [
				TYPE_VECTOR2,
				TYPE_VECTOR3,
				TYPE_VECTOR4,
				TYPE_QUATERNION,
				TYPE_COLOR,
				TYPE_TRANSFORM2D,
				TYPE_TRANSFORM3D,
				TYPE_BASIS,
				TYPE_PLANE,
				TYPE_AABB,
				TYPE_RECT2,
			]
		)
	)
