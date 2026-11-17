extends GdUnitTestSuite


func test_matches_a_text_containing_the_part() -> void:
	(
		assert_bool(ContainsText.new("run").matches("a running start"))
		. override_failure_message("ContainsText must match a text with its part in the middle")
		. is_true()
	)


func test_is_case_sensitive() -> void:
	(
		assert_bool(ContainsText.new("Run").matches("a running start"))
		. override_failure_message("ContainsText must compare letter case exactly")
		. is_false()
	)


func test_rejects_an_int() -> void:
	(
		assert_bool(ContainsText.new("4").matches(42))
		. override_failure_message("ContainsText must reject an int")
		. is_false()
	)


func test_describes_the_part() -> void:
	(
		assert_str(ContainsText.new("idle").description())
		. override_failure_message("ContainsText must describe its part")
		. is_equal('a text containing "idle"')
	)


func test_reports_the_actual_text() -> void:
	(
		assert_str(ContainsText.new("idle").mismatch("jump"))
		. override_failure_message("ContainsText must report the text it got")
		. is_equal('was "jump"')
	)
