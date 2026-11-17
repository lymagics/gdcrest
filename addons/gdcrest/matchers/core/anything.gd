class_name Anything
extends Matcher

const Literal := preload("res://addons/gdcrest/core/literal.gd")


func matches(_actual: Variant) -> bool:
	return true


func description() -> String:
	return "anything"


func mismatch(actual: Variant) -> String:
	return "was %s" % Literal.new(actual)
