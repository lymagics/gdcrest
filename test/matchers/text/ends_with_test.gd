extends GdUnitTestSuite


func test_matches_a_text_with_the_suffix() -> void:
	(
		assert_bool(EndsWith.new(".tres").matches("theme.tres"))
		. override_failure_message("EndsWith must match a text that ends with its suffix")
		. is_true()
	)


func test_rejects_a_text_that_only_begins_with_the_suffix() -> void:
	(
		assert_bool(EndsWith.new("jump").matches("jumping"))
		. override_failure_message("EndsWith must reject a text with characters after the suffix")
		. is_false()
	)


func test_rejects_null() -> void:
	(
		assert_bool(EndsWith.new("x").matches(null))
		. override_failure_message("EndsWith must reject null")
		. is_false()
	)


func test_describes_the_suffix() -> void:
	(
		assert_str(EndsWith.new("idle").description())
		. override_failure_message("EndsWith must describe its suffix")
		. is_equal('a text ending with "idle"')
	)


func test_reports_the_actual_text() -> void:
	(
		assert_str(EndsWith.new("idle").mismatch("run"))
		. override_failure_message("EndsWith must report the text it got")
		. is_equal('was "run"')
	)
