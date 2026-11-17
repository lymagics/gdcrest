class_name HasItem
extends Matcher

const Expectation := preload("res://addons/gdcrest/core/expectation.gd")
const Items := preload("res://addons/gdcrest/core/items.gd")
const Misfit := preload("res://addons/gdcrest/core/misfit.gd")

var _item: Variant


func _init(item: Variant) -> void:
	_item = item


func matches(actual: Variant) -> bool:
	return Items.new(actual).sequential() and _found(Items.new(actual).array())


func description() -> String:
	return "a collection containing %s" % Expectation.new(_item).description()


func mismatch(actual: Variant) -> String:
	return (
		"no item was %s" % Expectation.new(_item).description()
		if Items.new(actual).sequential()
		else str(Misfit.new(actual))
	)


func _found(list: Array) -> bool:
	var expectation: Matcher = Expectation.new(_item)
	return list.any(func(item: Variant) -> bool: return expectation.matches(item))
