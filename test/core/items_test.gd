extends GdUnitTestSuite

const Items := preload("res://addons/gdcrest/core/items.gd")


func test_accepts_a_packed_vector_array() -> void:
	(
		assert_bool(Items.new(PackedVector4Array()).sequential())
		. override_failure_message("Items must treat a packed array as a list")
		. is_true()
	)


func test_refuses_a_dictionary() -> void:
	(
		assert_bool(Items.new({"a": 1}).sequential())
		. override_failure_message("Items must not treat a dictionary as a list")
		. is_false()
	)


func test_lists_a_packed_array_as_an_array() -> void:
	(
		assert_array(Items.new(PackedStringArray(["idle", "run"])).array())
		. override_failure_message("Items must turn a packed array into an Array")
		. contains_exactly(["idle", "run"])
	)
