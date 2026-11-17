class_name AllOf
extends Matcher

var _matchers: Array[Matcher]


func _init(matchers: Array[Matcher]) -> void:
	_matchers = matchers


func matches(actual: Variant) -> bool:
	return _matchers.all(func(matcher: Matcher) -> bool: return matcher.matches(actual))


func description() -> String:
	return " and ".join(
		PackedStringArray(
			_matchers.map(func(matcher: Matcher) -> String: return matcher.description())
		)
	)


func mismatch(actual: Variant) -> String:
	var failed: Array[Matcher] = _matchers.filter(
		func(matcher: Matcher) -> bool: return not matcher.matches(actual)
	)
	return failed[0].mismatch(actual) if not failed.is_empty() else "matched all of them"
