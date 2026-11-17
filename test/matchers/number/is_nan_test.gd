extends GdUnitTestSuite


func test_matches_nan() -> void:
	(
		assert_bool(IsNan.new().matches(INF - INF))
		. override_failure_message("IsNan must match the NAN that INF - INF yields")
		. is_true()
	)


func test_rejects_zero() -> void:
	(
		assert_bool(IsNan.new().matches(0.0))
		. override_failure_message("IsNan must reject zero")
		. is_false()
	)


func test_rejects_a_nan_text() -> void:
	(
		assert_bool(IsNan.new().matches("nan"))
		. override_failure_message("IsNan must reject the text nan")
		. is_false()
	)


func test_describes_itself_as_nan() -> void:
	(
		assert_str(IsNan.new().description())
		. override_failure_message("IsNan must describe itself as NAN")
		. is_equal("NAN")
	)


func test_reports_the_actual_float() -> void:
	(
		assert_str(IsNan.new().mismatch(0.0))
		. override_failure_message("IsNan must report the float it got")
		. is_equal("was 0.0")
	)


func test_reports_the_type_of_an_int() -> void:
	(
		assert_str(IsNan.new().mismatch(0))
		. override_failure_message("IsNan must name the type of an int")
		. is_equal("was an int: 0")
	)
