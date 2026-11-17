extends GdUnitTestSuite


func test_matches_an_array_with_the_item() -> void:
	(
		assert_bool(HasItem.new("run").matches(["idle", "run", "jump"]))
		. override_failure_message("HasItem must match an array that holds the item")
		. is_true()
	)


func test_matches_an_item_matcher() -> void:
	(
		assert_bool(HasItem.new(GreaterThan.new(100.0)).matches(PackedInt64Array([3, 900])))
		. override_failure_message("HasItem must apply a matcher to each item")
		. is_true()
	)


func test_matches_a_typed_array() -> void:
	var names: Array[StringName] = [&"idle", &"run"]
	(
		assert_bool(HasItem.new(&"run").matches(names))
		. override_failure_message("HasItem must accept a typed array")
		. is_true()
	)


func test_rejects_an_empty_array() -> void:
	(
		assert_bool(HasItem.new(null).matches([]))
		. override_failure_message("HasItem must reject an empty array")
		. is_false()
	)


func test_rejects_a_text_holding_the_item() -> void:
	(
		assert_bool(HasItem.new("a").matches("abc"))
		. override_failure_message("HasItem must reject a text, which is not a collection")
		. is_false()
	)


func test_describes_the_item() -> void:
	(
		assert_str(HasItem.new("run").description())
		. override_failure_message("HasItem must describe the item it looks for")
		. is_equal('a collection containing "run"')
	)


func test_reports_the_missing_item() -> void:
	(
		assert_str(HasItem.new("run").mismatch(["idle"]))
		. override_failure_message("HasItem must say no item was the one it looked for")
		. is_equal('no item was "run"')
	)


func test_reports_the_type_of_a_dictionary() -> void:
	(
		assert_str(HasItem.new(1).mismatch({1: 1}))
		. override_failure_message("HasItem must name the type of a dictionary")
		. is_equal("was a Dictionary: {1: 1}")
	)
