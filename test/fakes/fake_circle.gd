class_name FakeCircle
extends RefCounted

var _radius: float


func _init(size: float) -> void:
	_radius = size


func radius() -> float:
	return _radius


func equal_to(other: FakeCircle) -> bool:
	return other.radius() == _radius
