class_name ContainsInAnyOrder
extends Matcher

const Expectation := preload("res://addons/gdcrest/core/expectation.gd")
const Items := preload("res://addons/gdcrest/core/items.gd")
const Literal := preload("res://addons/gdcrest/core/literal.gd")
const Misfit := preload("res://addons/gdcrest/core/misfit.gd")

var _items: Array


func _init(items: Array) -> void:
	_items = items


func matches(actual: Variant) -> bool:
	return (
		Items.new(actual).sequential()
		and _strangers(Items.new(actual).array()).is_empty()
		and _pending(Items.new(actual).array()).is_empty()
	)


func description() -> String:
	var texts: Array = _items.map(
		func(item: Variant) -> String: return Expectation.new(item).description()
	)
	return "exactly [%s], in any order" % ", ".join(PackedStringArray(texts))


func mismatch(actual: Variant) -> String:
	return (
		_difference(Items.new(actual).array())
		if Items.new(actual).sequential()
		else str(Misfit.new(actual))
	)


func _difference(list: Array) -> String:
	var strangers: Array = _strangers(list)
	var pending: Array[Matcher] = _pending(list)
	return (
		"%s was not expected" % Literal.new(strangers[0])
		if not strangers.is_empty()
		else "%s was missing" % pending[0].description() if not pending.is_empty() else "matched"
	)


func _pending(list: Array) -> Array[Matcher]:
	var pending: Array[Matcher] = _expectations()
	for item: Variant in list:
		_claimed(pending, item)
	return pending


func _strangers(list: Array) -> Array:
	var pending: Array[Matcher] = _expectations()
	return list.filter(func(item: Variant) -> bool: return not _claimed(pending, item))


func _claimed(pending: Array[Matcher], item: Variant) -> bool:
	var index: int = pending.find_custom(
		func(matcher: Matcher) -> bool: return matcher.matches(item)
	)
	if index != -1:
		pending.remove_at(index)
	return index != -1


func _expectations() -> Array[Matcher]:
	var expectations: Array[Matcher] = []
	expectations.assign(_items.map(func(item: Variant) -> Matcher: return Expectation.new(item)))
	return expectations
