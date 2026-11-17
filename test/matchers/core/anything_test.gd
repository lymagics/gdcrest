extends GdUnitTestSuite


func test_matches_null() -> void:
	(
		assert_bool(Anything.new().matches(null))
		. override_failure_message("Anything must match null")
		. is_true()
	)


func test_matches_a_freed_object() -> void:
	var node: Node = Node.new()
	node.free()
	(
		assert_bool(Anything.new().matches(node))
		. override_failure_message("Anything must match even a freed object")
		. is_true()
	)


func test_describes_itself_as_anything() -> void:
	(
		assert_str(Anything.new().description())
		. override_failure_message("Anything must describe itself as anything")
		. is_equal("anything")
	)
