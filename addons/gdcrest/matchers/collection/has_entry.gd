class_name HasEntry
extends Matcher

const Expectation := preload("res://addons/gdcrest/core/expectation.gd")
const Literal := preload("res://addons/gdcrest/core/literal.gd")
const Misfit := preload("res://addons/gdcrest/core/misfit.gd")

var _key: Variant
var _value: Variant


func _init(key: Variant, value: Variant) -> void:
	_key = key
	_value = value


func matches(actual: Variant) -> bool:
	return typeof(actual) == TYPE_DICTIONARY and _found(actual)


func description() -> String:
	return (
		"a dictionary with entry %s: %s"
		% [Expectation.new(_key).description(), Expectation.new(_value).description()]
	)


func mismatch(actual: Variant) -> String:
	return _difference(actual) if typeof(actual) == TYPE_DICTIONARY else str(Misfit.new(actual))


func _found(entries: Dictionary) -> bool:
	var expectation: Matcher = Expectation.new(_value)
	return _keys(entries).any(func(key: Variant) -> bool: return expectation.matches(entries[key]))


func _difference(entries: Dictionary) -> String:
	var keys: Array = _keys(entries)
	return (
		"%s %s" % [Literal.new(keys[0]), Expectation.new(_value).mismatch(entries[keys[0]])]
		if not keys.is_empty()
		else "no key was %s" % Expectation.new(_key).description()
	)


func _keys(entries: Dictionary) -> Array:
	var expectation: Matcher = Expectation.new(_key)
	return entries.keys().filter(func(key: Variant) -> bool: return expectation.matches(key))
