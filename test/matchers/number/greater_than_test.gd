extends GdUnitTestSuite


func test_matches_a_larger_float() -> void:
	(
		assert_bool(GreaterThan.new(1.0).matches(1.0000001))
		. override_failure_message("GreaterThan must match a float just above the bound")
		. is_true()
	)


func test_rejects_the_bound_itself() -> void:
	(
		assert_bool(GreaterThan.new(-3.0).matches(-3))
		. override_failure_message("GreaterThan must reject a value equal to the bound")
		. is_false()
	)


func test_matches_the_largest_int() -> void:
	(
		assert_bool(GreaterThan.new(0.0).matches(9223372036854775807))
		. override_failure_message("GreaterThan must match the int64 maximum above zero")
		. is_true()
	)


func test_rejects_negative_infinity() -> void:
	(
		assert_bool(GreaterThan.new(-1e300).matches(-INF))
		. override_failure_message("GreaterThan must reject negative infinity")
		. is_false()
	)


func test_rejects_a_bool() -> void:
	(
		assert_bool(GreaterThan.new(0.0).matches(true))
		. override_failure_message("GreaterThan must reject a bool, which is not a number")
		. is_false()
	)


func test_describes_the_bound() -> void:
	(
		assert_str(GreaterThan.new(1.0).description())
		. override_failure_message("GreaterThan must describe its bound")
		. is_equal("a number greater than 1.0")
	)


func test_reports_the_actual_number() -> void:
	(
		assert_str(GreaterThan.new(1.0).mismatch(-1))
		. override_failure_message("GreaterThan must report the number it got")
		. is_equal("was -1")
	)


func test_reports_the_type_of_a_bool() -> void:
	(
		assert_str(GreaterThan.new(1.0).mismatch(false))
		. override_failure_message("GreaterThan must name the type of a bool")
		. is_equal("was a bool: false")
	)
