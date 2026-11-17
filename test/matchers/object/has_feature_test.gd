extends GdUnitTestSuite


func test_matches_when_the_method_result_matches() -> void:
	(
		assert_bool(HasFeature.new("radius", IsEqual.new(6.5)).matches(FakeCircle.new(6.5)))
		. override_failure_message("HasFeature must match when radius() matches")
		. is_true()
	)


func test_rejects_when_the_method_result_differs() -> void:
	(
		assert_bool(HasFeature.new("radius", GreaterThan.new(1.0)).matches(FakeCircle.new(0.0)))
		. override_failure_message("HasFeature must reject when radius() doesn't match")
		. is_false()
	)


func test_rejects_an_object_without_the_method() -> void:
	(
		assert_bool(HasFeature.new("radius", Anything.new()).matches(FakeTag.new("idle")))
		. override_failure_message("HasFeature must reject an object without the method")
		. is_false()
	)


func test_rejects_a_freed_object() -> void:
	var node: Node = Node.new()
	node.free()
	(
		assert_bool(HasFeature.new("get_name", Anything.new()).matches(node))
		. override_failure_message("HasFeature must reject a freed object without crashing")
		. is_false()
	)


func test_rejects_a_plain_value() -> void:
	(
		assert_bool(HasFeature.new("length", Anything.new()).matches("text"))
		. override_failure_message("HasFeature must reject a value that is not an object")
		. is_false()
	)


func test_describes_the_method_and_its_matcher() -> void:
	(
		assert_str(HasFeature.new("radius", IsEqual.new(3.0)).description())
		. override_failure_message("HasFeature must describe the method and what it must return")
		. is_equal("an object whose radius() is equal to 3.0")
	)


func test_reports_the_method_result() -> void:
	(
		assert_str(HasFeature.new("radius", IsEqual.new(3.0)).mismatch(FakeCircle.new(0.0)))
		. override_failure_message("HasFeature must report what the method returned")
		. is_equal("radius() was 0.0")
	)


func test_reports_a_missing_method() -> void:
	(
		assert_str(HasFeature.new("radius", Anything.new()).mismatch(FakeTag.new("run")))
		. override_failure_message("HasFeature must say the object has no such method")
		. is_equal("has no method radius()")
	)
