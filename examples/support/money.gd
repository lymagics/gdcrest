class_name Money
extends RefCounted

var _cents: int
var _currency: String


func _init(amount: int, code: String) -> void:
	_cents = amount
	_currency = code


func cents() -> int:
	return _cents


func currency() -> String:
	return _currency


func plus(other: Money) -> Money:
	return Money.new(_cents + other.cents(), _currency)


func equal_to(other: Money) -> bool:
	return other.cents() == _cents and other.currency() == _currency


func _to_string() -> String:
	return "%.2f %s" % [_cents / 100.0, _currency]
