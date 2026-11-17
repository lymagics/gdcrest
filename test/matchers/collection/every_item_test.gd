extends GdUnitTestSuite


func test_matches_when_every_item_matches() -> void:
	(
		assert_bool(EveryItem.new(GreaterThan.new(0.0)).matches([1, 2.5, 99]))
		. override_failure_message("EveryItem must match when every item is positive")
		. is_true()
	)


func test_matches_an_empty_array() -> void:
	(
		assert_bool(EveryItem.new(IsNan.new()).matches([]))
		. override_failure_message("EveryItem must match an empty array")
		. is_true()
	)


func test_rejects_one_failing_item() -> void:
	(
		assert_bool(EveryItem.new(GreaterThan.new(0.0)).matches(PackedInt32Array([3, 0, 4])))
		. override_failure_message("EveryItem must reject an array with one failing item")
		. is_false()
	)


func test_checks_nested_arrays_as_items() -> void:
	(
		assert_bool(EveryItem.new(IsEmpty.new()).matches([[], [], {}]))
		. override_failure_message("EveryItem must apply its matcher to nested collections")
		. is_true()
	)


func test_rejects_null() -> void:
	(
		assert_bool(EveryItem.new(Anything.new()).matches(null))
		. override_failure_message("EveryItem must reject null")
		. is_false()
	)


func test_describes_its_matcher() -> void:
	(
		assert_str(EveryItem.new(GreaterThan.new(0.0)).description())
		. override_failure_message("EveryItem must describe the matcher every item must meet")
		. is_equal("a collection where every item is a number greater than 0.0")
	)


func test_reports_the_first_failing_item() -> void:
	(
		assert_str(EveryItem.new(GreaterThan.new(0.0)).mismatch([4, 2, -1, -2]))
		. override_failure_message("EveryItem must report the index and mismatch of a bad item")
		. is_equal("item 2 was -1")
	)
