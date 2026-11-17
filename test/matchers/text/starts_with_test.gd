extends GdUnitTestSuite


func test_matches_a_text_with_the_prefix() -> void:
	(
		assert_bool(StartsWith.new("idle").matches("idle-4b"))
		. override_failure_message("StartsWith must match a text that begins with its prefix")
		. is_true()
	)


func test_matches_any_text_for_an_empty_prefix() -> void:
	(
		assert_bool(StartsWith.new("").matches(""))
		. override_failure_message("StartsWith with an empty prefix must match an empty text")
		. is_true()
	)


func test_matches_a_unicode_prefix() -> void:
	(
		assert_bool(StartsWith.new("Привіт").matches("Привіт світ"))
		. override_failure_message("StartsWith must match a Unicode prefix")
		. is_true()
	)


func test_rejects_a_text_with_the_prefix_elsewhere() -> void:
	(
		assert_bool(StartsWith.new("idle").matches("run-idle"))
		. override_failure_message("StartsWith must reject a text with the prefix in the middle")
		. is_false()
	)


func test_rejects_a_string_name() -> void:
	(
		assert_bool(StartsWith.new("ru").matches(&"run"))
		. override_failure_message("StartsWith must reject a StringName, which is not a String")
		. is_false()
	)


func test_describes_the_prefix() -> void:
	(
		assert_str(StartsWith.new("idle").description())
		. override_failure_message("StartsWith must describe its prefix")
		. is_equal('a text starting with "idle"')
	)


func test_reports_the_actual_text() -> void:
	(
		assert_str(StartsWith.new("idle").mismatch("run"))
		. override_failure_message("StartsWith must report the text it got")
		. is_equal('was "run"')
	)


func test_reports_the_type_of_an_array() -> void:
	(
		assert_str(StartsWith.new("idle").mismatch(["idle"]))
		. override_failure_message("StartsWith must name the type of an array")
		. is_equal('was an Array: ["idle"]')
	)
