class_name IsNan
extends Matcher

const Literal := preload("res://addons/gdcrest/core/literal.gd")
const Misfit := preload("res://addons/gdcrest/core/misfit.gd")


func matches(actual: Variant) -> bool:
	return typeof(actual) == TYPE_FLOAT and is_nan(float(actual))


func description() -> String:
	return "NAN"


func mismatch(actual: Variant) -> String:
	return (
		"was %s" % Literal.new(actual) if typeof(actual) == TYPE_FLOAT else str(Misfit.new(actual))
	)
