class_name EveryItem
extends Matcher

const Items := preload("res://addons/gdcrest/core/items.gd")
const Misfit := preload("res://addons/gdcrest/core/misfit.gd")

var _matcher: Matcher


func _init(matcher: Matcher) -> void:
	_matcher = matcher


func matches(actual: Variant) -> bool:
	return Items.new(actual).sequential() and _wrong(Items.new(actual).array()) == -1


func description() -> String:
	return "a collection where every item is %s" % _matcher.description()


func mismatch(actual: Variant) -> String:
	return (
		_difference(Items.new(actual).array())
		if Items.new(actual).sequential()
		else str(Misfit.new(actual))
	)


func _difference(list: Array) -> String:
	var index: int = _wrong(list)
	return "item %d %s" % [index, _matcher.mismatch(list[index])] if index != -1 else "matched"


func _wrong(list: Array) -> int:
	return list.find_custom(func(item: Variant) -> bool: return not _matcher.matches(item))
