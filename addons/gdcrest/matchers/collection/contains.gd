class_name Contains
extends Matcher

const Expectation := preload("res://addons/gdcrest/core/expectation.gd")
const Items := preload("res://addons/gdcrest/core/items.gd")
const Misfit := preload("res://addons/gdcrest/core/misfit.gd")

var _items: Array


func _init(items: Array) -> void:
	_items = items


func matches(actual: Variant) -> bool:
	return (
		Items.new(actual).sequential()
		and Items.new(actual).array().size() == _items.size()
		and _wrong(Items.new(actual).array()) == -1
	)


func description() -> String:
	var texts: Array = _items.map(
		func(item: Variant) -> String: return Expectation.new(item).description()
	)
	return "exactly [%s], in this order" % ", ".join(PackedStringArray(texts))


func mismatch(actual: Variant) -> String:
	return (
		_difference(Items.new(actual).array())
		if Items.new(actual).sequential()
		else str(Misfit.new(actual))
	)


func _difference(list: Array) -> String:
	var index: int = _wrong(list)
	return (
		"item %d %s" % [index, Expectation.new(_items[index]).mismatch(list[index])]
		if index != -1
		else "had %d items instead of %d" % [list.size(), _items.size()]
	)


func _wrong(list: Array) -> int:
	return range(mini(list.size(), _items.size())).find_custom(
		func(index: int) -> bool: return not Expectation.new(_items[index]).matches(list[index])
	)
