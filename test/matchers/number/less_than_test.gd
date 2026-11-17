extends GdUnitTestSuite


func test_matches_a_smaller_int() -> void:
	(
		assert_bool(LessThan.new(10.0).matches(9))
		. override_failure_message("LessThan must match 9 below 10.0")
		. is_true()
	)


func test_rejects_the_bound_itself() -> void:
	(
		assert_bool(LessThan.new(0.0).matches(-0.0))
		. override_failure_message("LessThan must reject negative zero against a zero bound")
		. is_false()
	)


func test_matches_the_smallest_int() -> void:
	(
		assert_bool(LessThan.new(0.0).matches(-9223372036854775808))
		. override_failure_message("LessThan must match the int64 minimum below zero")
		. is_true()
	)


func test_rejects_nan() -> void:
	(
		assert_bool(LessThan.new(INF).matches(NAN))
		. override_failure_message("LessThan must reject NAN")
		. is_false()
	)


func test_rejects_a_vector() -> void:
	(
		assert_bool(LessThan.new(100.0).matches(Vector2(1, 1)))
		. override_failure_message("LessThan must reject a vector")
		. is_false()
	)


func test_describes_the_bound() -> void:
	(
		assert_str(LessThan.new(-2.5).description())
		. override_failure_message("LessThan must describe its bound")
		. is_equal("a number less than -2.5")
	)


func test_reports_the_actual_number() -> void:
	(
		assert_str(LessThan.new(10.0).mismatch(12))
		. override_failure_message("LessThan must report the number it got")
		. is_equal("was 12")
	)
