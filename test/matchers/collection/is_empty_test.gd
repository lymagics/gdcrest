extends GdUnitTestSuite


func test_matches_an_empty_array() -> void:
	(
		assert_bool(IsEmpty.new().matches([]))
		. override_failure_message("IsEmpty must match an empty array")
		. is_true()
	)


func test_matches_an_empty_packed_vector_array() -> void:
	(
		assert_bool(IsEmpty.new().matches(PackedVector3Array()))
		. override_failure_message("IsEmpty must match an empty packed array")
		. is_true()
	)


func test_matches_an_empty_dictionary() -> void:
	(
		assert_bool(IsEmpty.new().matches({}))
		. override_failure_message("IsEmpty must match an empty dictionary")
		. is_true()
	)


func test_matches_an_empty_text() -> void:
	(
		assert_bool(IsEmpty.new().matches(""))
		. override_failure_message("IsEmpty must match an empty text")
		. is_true()
	)


func test_rejects_an_array_holding_an_empty_array() -> void:
	(
		assert_bool(IsEmpty.new().matches([[]]))
		. override_failure_message("IsEmpty must reject an array that holds an empty array")
		. is_false()
	)


func test_rejects_zero() -> void:
	(
		assert_bool(IsEmpty.new().matches(0))
		. override_failure_message("IsEmpty must reject the number zero")
		. is_false()
	)


func test_describes_an_empty_collection() -> void:
	(
		assert_str(IsEmpty.new().description())
		. override_failure_message("IsEmpty must describe an empty collection")
		. is_equal("an empty collection")
	)


func test_reports_how_many_items_there_were() -> void:
	(
		assert_str(IsEmpty.new().mismatch(PackedByteArray([1, 2, 3])))
		. override_failure_message("IsEmpty must count the items it found")
		. is_equal("had 3 items")
	)


func test_reports_a_single_item_in_the_singular() -> void:
	(
		assert_str(IsEmpty.new().mismatch({"k": 0}))
		. override_failure_message("IsEmpty must say item, not items, for one entry")
		. is_equal("had 1 item")
	)


func test_reports_a_text_by_its_content() -> void:
	(
		assert_str(IsEmpty.new().mismatch("  "))
		. override_failure_message("IsEmpty must report a non-empty text as it is")
		. is_equal('was "  "')
	)
