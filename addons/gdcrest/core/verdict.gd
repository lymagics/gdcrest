extends RefCounted

var _reason: String
var _actual: Variant
var _matcher: Matcher


func _init(reason: String, actual: Variant, matcher: Matcher) -> void:
	_reason = reason
	_actual = actual
	_matcher = matcher


func deliver(report: Report) -> void:
	var blank: bool = _reason.strip_edges().is_empty()
	if not blank and _matcher.matches(_actual):
		report.accept()
	else:
		report.reject(_complaint() if blank else _text(), _line())


func _text() -> String:
	return (
		"%s\nExpected: %s\n     but: %s"
		% [_reason, _matcher.description(), _matcher.mismatch(_actual)]
	)


func _complaint() -> String:
	return "The assertion has no reason; write a sentence saying what must be true"


func _line() -> int:
	var frames: Array = get_stack().filter(
		func(frame: Dictionary) -> bool:
			return not String(frame["source"]).begins_with("res://addons/gdcrest/")
	)
	return int(frames[0]["line"]) if not frames.is_empty() else -1
