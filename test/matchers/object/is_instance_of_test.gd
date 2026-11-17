extends GdUnitTestSuite


func test_matches_an_instance_of_a_script_class() -> void:
	(
		assert_bool(IsInstanceOf.new(FakeCircle).matches(FakeCircle.new(0.5)))
		. override_failure_message("IsInstanceOf must match an instance of its script class")
		. is_true()
	)


func test_matches_an_instance_of_an_interface() -> void:
	(
		assert_bool(IsInstanceOf.new(Matcher).matches(Anything.new()))
		. override_failure_message("IsInstanceOf must match an implementation of an interface")
		. is_true()
	)


func test_matches_a_built_in_type() -> void:
	(
		assert_bool(IsInstanceOf.new(TYPE_VECTOR2I).matches(Vector2i(3, -3)))
		. override_failure_message("IsInstanceOf must match a value of a built-in type")
		. is_true()
	)


func test_matches_a_native_class() -> void:
	(
		assert_bool(IsInstanceOf.new(RefCounted).matches(FakeTag.new("idle")))
		. override_failure_message("IsInstanceOf must match a subclass of a native class")
		. is_true()
	)


func test_rejects_an_instance_of_another_class() -> void:
	(
		assert_bool(IsInstanceOf.new(FakeCircle).matches(FakeTag.new("run")))
		. override_failure_message("IsInstanceOf must reject an instance of another class")
		. is_false()
	)


func test_rejects_null() -> void:
	(
		assert_bool(IsInstanceOf.new(FakeCircle).matches(null))
		. override_failure_message("IsInstanceOf must reject null")
		. is_false()
	)


func test_rejects_everything_for_a_type_that_is_not_a_type() -> void:
	(
		assert_bool(IsInstanceOf.new("FakeCircle").matches(FakeCircle.new(1.0)))
		. override_failure_message("IsInstanceOf must reject values when its type is a text")
		. is_false()
	)


func test_describes_a_script_class_by_name() -> void:
	(
		assert_str(IsInstanceOf.new(FakeCircle).description())
		. override_failure_message("IsInstanceOf must describe a script class by its name")
		. is_equal("an instance of FakeCircle")
	)


func test_describes_a_built_in_type_by_name() -> void:
	(
		assert_str(IsInstanceOf.new(TYPE_PACKED_STRING_ARRAY).description())
		. override_failure_message("IsInstanceOf must describe a built-in type by its name")
		. is_equal("an instance of PackedStringArray")
	)


func test_reports_the_class_of_the_actual_object() -> void:
	(
		assert_str(IsInstanceOf.new(FakeCircle).mismatch(FakeTag.new("jump")))
		. override_failure_message("IsInstanceOf must name the class it got")
		. is_equal("was a FakeTag")
	)


func test_reports_an_int_with_its_article() -> void:
	(
		assert_str(IsInstanceOf.new(FakeCircle).mismatch(12))
		. override_failure_message("IsInstanceOf must use the article an before int")
		. is_equal("was an int")
	)
