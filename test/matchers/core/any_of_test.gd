extends GdUnitTestSuite


func test_matches_when_one_matcher_matches() -> void:
	(
		assert_bool(AnyOf.new([IsEqual.new(5), IsEqual.new(-5)]).matches(-5))
		. override_failure_message("AnyOf must match a value that one part matches")
		. is_true()
	)


func test_rejects_when_no_matcher_matches() -> void:
	(
		assert_bool(AnyOf.new([IsEqual.new("idle"), IsEqual.new("jump")]).matches("run"))
		. override_failure_message("AnyOf must reject a value that no part matches")
		. is_false()
	)


func test_rejects_everything_when_empty() -> void:
	(
		assert_bool(AnyOf.new([]).matches(0))
		. override_failure_message("AnyOf with no parts must match nothing")
		. is_false()
	)


func test_joins_descriptions_with_or() -> void:
	(
		assert_str(AnyOf.new([IsEqual.new(1), IsNan.new()]).description())
		. override_failure_message("AnyOf must join its parts' descriptions with or")
		. is_equal("equal to 1 or NAN")
	)


func test_reports_the_actual_value() -> void:
	(
		assert_str(AnyOf.new([IsEqual.new(1), IsEqual.new(2)]).mismatch(7))
		. override_failure_message("AnyOf must report the value no part matched")
		. is_equal("was 7")
	)
