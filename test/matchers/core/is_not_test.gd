extends GdUnitTestSuite


func test_matches_what_its_origin_rejects() -> void:
	(
		assert_bool(IsNot.new(IsEqual.new(11)).matches(12))
		. override_failure_message("IsNot must match 12 when its origin expects 11")
		. is_true()
	)


func test_rejects_what_its_origin_matches() -> void:
	(
		assert_bool(IsNot.new(IsEqual.new("jump")).matches("jump"))
		. override_failure_message("IsNot must reject the value its origin matches")
		. is_false()
	)


func test_matches_null_when_its_origin_rejects_it() -> void:
	(
		assert_bool(IsNot.new(IsEqual.new(0)).matches(null))
		. override_failure_message("IsNot must match null when its origin rejects null")
		. is_true()
	)


func test_describes_the_negated_origin() -> void:
	(
		assert_str(IsNot.new(IsEqual.new(3)).description())
		. override_failure_message("IsNot must prefix its origin's description with not")
		. is_equal("not equal to 3")
	)


func test_reports_the_actual_value() -> void:
	(
		assert_str(IsNot.new(IsEqual.new(3)).mismatch(3))
		. override_failure_message("IsNot must report the value it didn't expect")
		. is_equal("was 3")
	)
