extends GdUnitTestSuite


func test_matches_when_every_matcher_matches() -> void:
	(
		assert_bool(AllOf.new([StartsWith.new("Level"), EndsWith.new("77")]).matches("Level 77"))
		. override_failure_message("AllOf must match a value that every part matches")
		. is_true()
	)


func test_rejects_when_one_matcher_fails() -> void:
	(
		assert_bool(
			AllOf.new([FakeMatcher.new(true, "hot"), FakeMatcher.new(false, "big")]).matches(1)
		)
		. override_failure_message("AllOf must reject a value that one part rejects")
		. is_false()
	)


func test_matches_anything_when_empty() -> void:
	(
		assert_bool(AllOf.new([]).matches(null))
		. override_failure_message("AllOf with no parts must match everything")
		. is_true()
	)


func test_joins_descriptions_with_and() -> void:
	(
		assert_str(
			(
				AllOf
				. new([StartsWith.new("Level 77"), IsNot.new(IsEqual.new("Level 77"))])
				. description()
			)
		)
		. override_failure_message("AllOf must join its parts' descriptions with and")
		. is_equal('a text starting with "Level 77" and not equal to "Level 77"')
	)


func test_reports_the_first_failing_mismatch() -> void:
	(
		assert_str(
			(
				AllOf
				. new(
					[
						FakeMatcher.new(true, "a"),
						FakeMatcher.new(false, "b"),
						FakeMatcher.new(false, "c")
					]
				)
				. mismatch(0)
			)
		)
		. override_failure_message("AllOf must report the mismatch of the first part that failed")
		. is_equal("failed b")
	)
