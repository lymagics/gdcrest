extends Report

var _actual: Variant


func _init(actual: Variant) -> void:
	_actual = actual


func accept() -> void:
	GdUnitAssertImpl.new(_actual).report_success()


func reject(text: String, line: int) -> void:
	GdUnitAssertImpl.new(_actual).report_error(text, line)
