extends GdUnitTestSuite


func test_matches_the_same_items_in_another_order() -> void:
	(
		assert_bool(
			ContainsInAnyOrder.new(["jump", "idle", "run"]).matches(["idle", "run", "jump"])
		)
		. override_failure_message("ContainsInAnyOrder must match the same items in any order")
		. is_true()
	)


func test_counts_duplicates() -> void:
	(
		assert_bool(ContainsInAnyOrder.new([5, 5]).matches([5]))
		. override_failure_message("ContainsInAnyOrder must expect each listed item once")
		. is_false()
	)


func test_matches_item_matchers() -> void:
	(
		assert_bool(ContainsInAnyOrder.new([StartsWith.new("r"), "idle"]).matches(["idle", "run"]))
		. override_failure_message("ContainsInAnyOrder must accept matchers among its items")
		. is_true()
	)


func test_matches_two_empty_collections() -> void:
	(
		assert_bool(ContainsInAnyOrder.new([]).matches(PackedColorArray()))
		. override_failure_message("ContainsInAnyOrder with no items must match an empty array")
		. is_true()
	)


func test_rejects_a_vector() -> void:
	(
		assert_bool(ContainsInAnyOrder.new([1.0, 2.0]).matches(Vector2(1, 2)))
		. override_failure_message("ContainsInAnyOrder must reject a vector")
		. is_false()
	)


func test_describes_the_items() -> void:
	(
		assert_str(ContainsInAnyOrder.new(["idle", "run"]).description())
		. override_failure_message("ContainsInAnyOrder must describe the exact items")
		. is_equal('exactly ["idle", "run"], in any order')
	)


func test_reports_an_unexpected_item() -> void:
	(
		assert_str(ContainsInAnyOrder.new(["idle", "run"]).mismatch(["idle", "walk"]))
		. override_failure_message("ContainsInAnyOrder must report an item nobody expected")
		. is_equal('"walk" was not expected')
	)


func test_reports_a_missing_item() -> void:
	(
		assert_str(ContainsInAnyOrder.new(["idle", "run"]).mismatch(["run"]))
		. override_failure_message("ContainsInAnyOrder must report an item that never came")
		. is_equal('"idle" was missing')
	)
