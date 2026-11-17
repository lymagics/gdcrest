extends GdUnitTestSuite


func test_matches_exactly_these_items_in_order() -> void:
	(
		assert_bool(Contains.new(["idle", "run", "jump"]).matches(["idle", "run", "jump"]))
		. override_failure_message("Contains must match the same items in the same order")
		. is_true()
	)


func test_matches_item_matchers_in_order() -> void:
	(
		assert_bool(Contains.new([LessThan.new(0.0), 0]).matches(PackedInt32Array([-9, 0])))
		. override_failure_message("Contains must apply matchers position by position")
		. is_true()
	)


func test_rejects_the_same_items_in_another_order() -> void:
	(
		assert_bool(Contains.new([1, 2]).matches([2, 1]))
		. override_failure_message("Contains must reject the right items in the wrong order")
		. is_false()
	)


func test_rejects_an_extra_item() -> void:
	(
		assert_bool(Contains.new(["a"]).matches(["a", "a"]))
		. override_failure_message("Contains must reject an array with an extra item")
		. is_false()
	)


func test_rejects_a_dictionary() -> void:
	(
		assert_bool(Contains.new([]).matches({}))
		. override_failure_message("Contains must reject a dictionary")
		. is_false()
	)


func test_describes_the_items_and_their_order() -> void:
	(
		assert_str(Contains.new(["idle", "run", "jump"]).description())
		. override_failure_message("Contains must describe the exact items in order")
		. is_equal('exactly ["idle", "run", "jump"], in this order')
	)


func test_reports_the_first_wrong_item() -> void:
	(
		assert_str(Contains.new(["idle", "run", "jump"]).mismatch(["idle", "walk", "jump"]))
		. override_failure_message("Contains must report the index and value of the wrong item")
		. is_equal('item 1 was "walk"')
	)


func test_reports_a_shorter_array() -> void:
	(
		assert_str(Contains.new([1, 2, 3]).mismatch([1, 2]))
		. override_failure_message("Contains must report how many items it found")
		. is_equal("had 2 items instead of 3")
	)
