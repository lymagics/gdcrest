extends GdUnitTestSuite

const Expectation := preload("res://addons/gdcrest/core/expectation.gd")


func test_treats_a_plain_value_as_equality() -> void:
	(
		assert_bool(Expectation.new(-12).matches(-12))
		. override_failure_message("Expectation must match a plain value by equality")
		. is_true()
	)


func test_delegates_to_a_matcher() -> void:
	(
		assert_bool(Expectation.new(LessThan.new(0.0)).matches(-12))
		. override_failure_message("Expectation must ask the matcher it was given")
		. is_true()
	)


func test_describes_a_plain_value_as_its_literal() -> void:
	(
		assert_str(Expectation.new(&"jump").description())
		. override_failure_message("Expectation must describe a plain value as its literal")
		. is_equal('&"jump"')
	)


func test_describes_a_matcher_by_its_description() -> void:
	(
		assert_str(Expectation.new(EndsWith.new("x")).description())
		. override_failure_message("Expectation must describe a matcher by its own words")
		. is_equal('a text ending with "x"')
	)


func test_reports_the_mismatch_of_equality() -> void:
	(
		assert_str(Expectation.new(5).mismatch(6))
		. override_failure_message("Expectation must report what equality would report")
		. is_equal("was 6")
	)
