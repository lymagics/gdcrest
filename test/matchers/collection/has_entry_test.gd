extends GdUnitTestSuite


func test_matches_a_dictionary_with_the_entry() -> void:
	(
		assert_bool(HasEntry.new("health", 3.0).matches({"name": "idle", "health": 3.0}))
		. override_failure_message("HasEntry must match a dictionary holding the entry")
		. is_true()
	)


func test_matches_key_and_value_matchers() -> void:
	(
		assert_bool(HasEntry.new(StartsWith.new("ra"), GreaterThan.new(1.0)).matches({"range": 2}))
		. override_failure_message("HasEntry must apply matchers to keys and values")
		. is_true()
	)


func test_matches_a_typed_dictionary() -> void:
	var healths: Dictionary[String, float] = {"run": 0.25}
	(
		assert_bool(HasEntry.new("run", 0.25).matches(healths))
		. override_failure_message("HasEntry must accept a typed dictionary")
		. is_true()
	)


func test_rejects_the_right_key_with_the_wrong_value() -> void:
	(
		assert_bool(HasEntry.new("health", 3.0).matches({"health": 3}))
		. override_failure_message("HasEntry must reject an entry whose value doesn't match")
		. is_false()
	)


func test_rejects_an_array_of_pairs() -> void:
	(
		assert_bool(HasEntry.new(0, "a").matches(["a"]))
		. override_failure_message("HasEntry must reject an array")
		. is_false()
	)


func test_describes_the_entry() -> void:
	(
		assert_str(HasEntry.new("health", 3.0).description())
		. override_failure_message("HasEntry must describe the entry it expects")
		. is_equal('a dictionary with entry "health": 3.0')
	)


func test_reports_the_value_of_the_matching_key() -> void:
	(
		assert_str(HasEntry.new("health", 4.5).mismatch({"health": 3.0}))
		. override_failure_message("HasEntry must report the value found under the key")
		. is_equal('"health" was 3.0')
	)


func test_reports_a_missing_key() -> void:
	(
		assert_str(HasEntry.new("health", 4.5).mismatch({"name": "jump"}))
		. override_failure_message("HasEntry must say when no key matched")
		. is_equal('no key was "health"')
	)
