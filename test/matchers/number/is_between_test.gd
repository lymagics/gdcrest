extends GdUnitTestSuite


func test_matches_a_value_inside_the_range() -> void:
	(
		assert_bool(IsBetween.new(1.0, 2.0).matches(1.5))
		. override_failure_message("IsBetween must match 1.5 between 1.0 and 2.0")
		. is_true()
	)


func test_matches_the_low_end_of_the_range() -> void:
	(
		assert_bool(IsBetween.new(-4.0, 4.0).matches(-4))
		. override_failure_message("IsBetween must include the low end")
		. is_true()
	)


func test_matches_the_high_end_of_the_range() -> void:
	(
		assert_bool(IsBetween.new(-4.0, 4.0).matches(4.0))
		. override_failure_message("IsBetween must include the high end")
		. is_true()
	)


func test_rejects_a_value_below_the_range() -> void:
	(
		assert_bool(IsBetween.new(1.0, 2.0).matches(0.9))
		. override_failure_message("IsBetween must reject 0.9 below 1.0")
		. is_false()
	)


func test_rejects_infinity() -> void:
	(
		assert_bool(IsBetween.new(0.0, 1e308).matches(INF))
		. override_failure_message("IsBetween must reject infinity above a huge range")
		. is_false()
	)


func test_rejects_null() -> void:
	(
		assert_bool(IsBetween.new(0.0, 1.0).matches(null))
		. override_failure_message("IsBetween must reject null")
		. is_false()
	)


func test_describes_the_range() -> void:
	(
		assert_str(IsBetween.new(1.0, 2.0).description())
		. override_failure_message("IsBetween must describe both ends of its range")
		. is_equal("a number from 1.0 to 2.0")
	)


func test_reports_a_value_below_the_range() -> void:
	(
		assert_str(IsBetween.new(1.0, 2.0).mismatch(0.75))
		. override_failure_message("IsBetween must say a value fell below the low end")
		. is_equal("was 0.75, below 1.0")
	)


func test_reports_a_value_above_the_range() -> void:
	(
		assert_str(IsBetween.new(1.0, 2.0).mismatch(30))
		. override_failure_message("IsBetween must say a value rose above the high end")
		. is_equal("was 30, above 2.0")
	)
