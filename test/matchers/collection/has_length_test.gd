extends GdUnitTestSuite


func test_matches_an_array_of_that_length() -> void:
	(
		assert_bool(HasLength.new(3).matches(["idle", null, 0.5]))
		. override_failure_message("HasLength must match an array of three items against 3")
		. is_true()
	)


func test_matches_a_length_matcher() -> void:
	(
		assert_bool(HasLength.new(GreaterThan.new(1.0)).matches({"a": 1, "b": 2}))
		. override_failure_message("HasLength must apply a matcher to the length")
		. is_true()
	)


func test_counts_unicode_characters_in_text() -> void:
	(
		assert_bool(HasLength.new(4).matches("Київ"))
		. override_failure_message("HasLength must count characters, not bytes")
		. is_true()
	)


func test_rejects_a_different_length() -> void:
	(
		assert_bool(HasLength.new(1).matches(PackedStringArray(["a", "b"])))
		. override_failure_message("HasLength must reject a packed array of another length")
		. is_false()
	)


func test_rejects_null() -> void:
	(
		assert_bool(HasLength.new(0).matches(null))
		. override_failure_message("HasLength must reject null")
		. is_false()
	)


func test_describes_a_plain_length() -> void:
	(
		assert_str(HasLength.new(3).description())
		. override_failure_message("HasLength must describe the length it expects")
		. is_equal("a collection with length 3")
	)


func test_describes_a_length_matcher() -> void:
	(
		assert_str(HasLength.new(LessThan.new(5.0)).description())
		. override_failure_message("HasLength must describe its length matcher")
		. is_equal("a collection with length a number less than 5.0")
	)


func test_reports_the_actual_length() -> void:
	(
		assert_str(HasLength.new(3).mismatch([1, 2]))
		. override_failure_message("HasLength must report the length it found")
		. is_equal("had length 2")
	)
