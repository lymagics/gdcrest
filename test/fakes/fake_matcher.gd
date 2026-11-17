class_name FakeMatcher
extends Matcher

var _verdict: bool
var _text: String


func _init(verdict: bool, text: String) -> void:
	_verdict = verdict
	_text = text


func matches(_actual: Variant) -> bool:
	return _verdict


func description() -> String:
	return _text


func mismatch(_actual: Variant) -> String:
	return "failed " + _text
