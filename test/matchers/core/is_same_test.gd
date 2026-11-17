extends GdUnitTestSuite


func test_matches_the_very_same_instance() -> void:
	var circle: FakeCircle = FakeCircle.new(2.75)
	(
		assert_bool(IsSame.new(circle).matches(circle))
		. override_failure_message("IsSame must match the instance it was given")
		. is_true()
	)


func test_rejects_an_equal_but_different_instance() -> void:
	(
		assert_bool(IsSame.new(FakeCircle.new(8.5)).matches(FakeCircle.new(8.5)))
		. override_failure_message("IsSame must reject another instance even if it is equal")
		. is_false()
	)


func test_rejects_null() -> void:
	(
		assert_bool(IsSame.new(FakeTag.new("swim")).matches(null))
		. override_failure_message("IsSame must reject null")
		. is_false()
	)


func test_rejects_a_plain_value() -> void:
	(
		assert_bool(IsSame.new(FakeTag.new("fly")).matches(42))
		. override_failure_message("IsSame must reject a value that is not an object")
		. is_false()
	)


func test_describes_the_expected_instance() -> void:
	(
		assert_str(IsSame.new(FakeTag.new("idle")).description())
		. override_failure_message("IsSame must describe the instance it expects")
		. is_equal("the same instance as tag idle")
	)


func test_reports_another_instance() -> void:
	(
		assert_str(IsSame.new(FakeTag.new("idle")).mismatch(FakeTag.new("run")))
		. override_failure_message("IsSame must report the other instance it got")
		. is_equal("was another tag run")
	)


func test_reports_the_type_of_a_plain_value() -> void:
	(
		assert_str(IsSame.new(FakeTag.new("idle")).mismatch(7))
		. override_failure_message("IsSame must name the type of a value that is not an object")
		. is_equal("was an int: 7")
	)
