extends GdUnitTestSuite

const Kind := preload("res://addons/gdcrest/core/kind.gd")


func test_names_a_built_in_type() -> void:
	(
		assert_str(str(Kind.new(PackedInt64Array())))
		. override_failure_message("Kind must name a packed array by its Godot type")
		. is_equal("PackedInt64Array")
	)


func test_names_a_script_class() -> void:
	(
		assert_str(str(Kind.new(FakeTag.new("idle"))))
		. override_failure_message("Kind must name an object by its class_name")
		. is_equal("FakeTag")
	)


func test_names_a_native_object() -> void:
	(
		assert_str(str(Kind.new(RegEx.new())))
		. override_failure_message("Kind must name an engine object by its native class")
		. is_equal("RegEx")
	)


func test_names_a_freed_object() -> void:
	var node: Node = Node.new()
	node.free()
	(
		assert_str(str(Kind.new(node)))
		. override_failure_message("Kind must name a freed object without touching it")
		. is_equal("freed Object")
	)
