extends GdUnitTestSuite


func test_matches_a_text_the_pattern_finds() -> void:
	(
		assert_bool(MatchesRegex.new("^[a-z]+-\\d$").matches("jump-2"))
		. override_failure_message("MatchesRegex must match a text the pattern finds")
		. is_true()
	)


func test_rejects_a_text_the_pattern_misses() -> void:
	(
		assert_bool(MatchesRegex.new("^[A-Z]{3}$").matches("jump-2"))
		. override_failure_message("MatchesRegex must reject a text the pattern doesn't find")
		. is_false()
	)


func test_rejects_a_packed_string_array() -> void:
	(
		assert_bool(MatchesRegex.new(".*").matches(PackedStringArray(["a"])))
		. override_failure_message("MatchesRegex must reject a packed string array")
		. is_false()
	)


func test_describes_the_pattern() -> void:
	(
		assert_str(MatchesRegex.new("^idle$").description())
		. override_failure_message("MatchesRegex must describe its pattern")
		. is_equal('a text matching the pattern "^idle$"')
	)


func test_reports_the_actual_text() -> void:
	(
		assert_str(MatchesRegex.new("^[A-Z]+$").mismatch("jump-2"))
		. override_failure_message("MatchesRegex must report the text it got")
		. is_equal('was "jump-2"')
	)
