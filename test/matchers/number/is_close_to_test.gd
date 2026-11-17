extends GdUnitTestSuite


func test_matches_a_float_within_delta() -> void:
	(
		assert_bool(IsCloseTo.new(3.0, 0.25).matches(3.125))
		. override_failure_message("IsCloseTo must match 3.125 within 0.25 of 3.0")
		. is_true()
	)


func test_matches_a_value_exactly_delta_away() -> void:
	(
		assert_bool(IsCloseTo.new(-2.0, 0.5).matches(-2.5))
		. override_failure_message("IsCloseTo must include the bound itself")
		. is_true()
	)


func test_matches_an_int_within_delta() -> void:
	(
		assert_bool(IsCloseTo.new(10.0, 1.0).matches(11))
		. override_failure_message("IsCloseTo must accept an int as a number")
		. is_true()
	)


func test_rejects_a_float_beyond_delta() -> void:
	(
		assert_bool(IsCloseTo.new(1.0, 0.125).matches(1.25))
		. override_failure_message("IsCloseTo must reject 1.25 when it is 0.25 away from 1.0")
		. is_false()
	)


func test_rejects_nan() -> void:
	(
		assert_bool(IsCloseTo.new(0.0, INF).matches(NAN))
		. override_failure_message("IsCloseTo must reject NAN even with an infinite delta")
		. is_false()
	)


func test_rejects_a_numeric_text() -> void:
	(
		assert_bool(IsCloseTo.new(5.0, 1.0).matches("5"))
		. override_failure_message("IsCloseTo must reject a text that looks like a number")
		. is_false()
	)


func test_describes_delta_and_expected_value() -> void:
	(
		assert_str(IsCloseTo.new(3.0, 0.5).description())
		. override_failure_message("IsCloseTo must describe its delta and expected value")
		. is_equal("a number within 0.5 of 3.0")
	)


func test_reports_the_value_and_its_distance() -> void:
	(
		assert_str(IsCloseTo.new(3.0, 0.125).mismatch(3.25))
		. override_failure_message("IsCloseTo must report the value and how far away it was")
		. is_equal("was 3.25, 0.25 away")
	)


func test_reports_the_type_of_null() -> void:
	(
		assert_str(IsCloseTo.new(3.0, 0.125).mismatch(null))
		. override_failure_message("IsCloseTo must report null as null")
		. is_equal("was null")
	)
