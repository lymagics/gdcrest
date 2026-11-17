extends GdUnitTestSuite


func test_matches_an_array_holding_every_item_in_any_order() -> void:
	(
		assert_bool(HasItems.new(["jump", "idle"]).matches(["idle", "run", "jump"]))
		. override_failure_message("HasItems must match when every item is present in any order")
		. is_true()
	)


func test_matches_item_matchers() -> void:
	(
		assert_bool(HasItems.new([IsNan.new(), 2.5]).matches(PackedFloat64Array([2.5, NAN])))
		. override_failure_message("HasItems must accept matchers among its items")
		. is_true()
	)


func test_matches_anything_when_given_no_items() -> void:
	(
		assert_bool(HasItems.new([]).matches([]))
		. override_failure_message("HasItems with no items must match an empty array")
		. is_true()
	)


func test_rejects_an_array_missing_an_item() -> void:
	(
		assert_bool(HasItems.new(["idle", "jump"]).matches(["idle"]))
		. override_failure_message("HasItems must reject an array missing one item")
		. is_false()
	)


func test_rejects_null() -> void:
	(
		assert_bool(HasItems.new([]).matches(null))
		. override_failure_message("HasItems must reject null")
		. is_false()
	)


func test_describes_the_items() -> void:
	(
		assert_str(HasItems.new(["idle", 7]).description())
		. override_failure_message("HasItems must list the items it looks for")
		. is_equal('a collection containing ["idle", 7], in any order')
	)


func test_reports_the_first_missing_item() -> void:
	(
		assert_str(HasItems.new(["idle", "jump", "run"]).mismatch(["idle"]))
		. override_failure_message("HasItems must report the first item it couldn't find")
		. is_equal('"jump" was missing')
	)
