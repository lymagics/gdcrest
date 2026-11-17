class_name HasItems
extends Matcher

const Expectation := preload("res://addons/gdcrest/core/expectation.gd")
const Items := preload("res://addons/gdcrest/core/items.gd")
const Misfit := preload("res://addons/gdcrest/core/misfit.gd")

var _items: Array


func _init(items: Array) -> void:
	_items = items


func matches(actual: Variant) -> bool:
	return Items.new(actual).sequential() and _missing(actual).is_empty()


func description() -> String:
	return "a collection containing %s, in any order" % _listed()


func mismatch(actual: Variant) -> String:
	return (
		"%s was missing" % _missing(actual)[0].description()
		if Items.new(actual).sequential()
		else str(Misfit.new(actual))
	)


func _listed() -> String:
	var texts: Array = _expectations().map(func(item: Matcher) -> String: return item.description())
	return "[%s]" % ", ".join(PackedStringArray(texts))


func _expectations() -> Array[Matcher]:
	var expectations: Array[Matcher] = []
	expectations.assign(_items.map(func(item: Variant) -> Matcher: return Expectation.new(item)))
	return expectations


func _missing(actual: Variant) -> Array[Matcher]:
	var list: Array = Items.new(actual).array()
	return _expectations().filter(
		func(expectation: Matcher) -> bool:
			return not list.any(func(item: Variant) -> bool: return expectation.matches(item))
	)
