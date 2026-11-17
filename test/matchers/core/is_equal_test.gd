extends GdUnitTestSuite


func test_matches_an_equal_negative_int() -> void:
	(
		assert_bool(IsEqual.new(-7).matches(-7))
		. override_failure_message("IsEqual must match -7 against -7")
		. is_true()
	)


func test_rejects_a_different_int() -> void:
	(
		assert_bool(IsEqual.new(4).matches(5))
		. override_failure_message("IsEqual must not match 5 against 4")
		. is_false()
	)


func test_rejects_a_float_equal_in_value_to_an_int() -> void:
	(
		assert_bool(IsEqual.new(3).matches(3.0))
		. override_failure_message("IsEqual must not match the float 3.0 against the int 3")
		. is_false()
	)


func test_rejects_null_for_a_text() -> void:
	(
		assert_bool(IsEqual.new("idle").matches(null))
		. override_failure_message("IsEqual must not match null against a text")
		. is_false()
	)


func test_matches_null_against_null() -> void:
	(
		assert_bool(IsEqual.new(null).matches(null))
		. override_failure_message("IsEqual must match null against null")
		. is_true()
	)


func test_rejects_nan_because_it_compares_exactly() -> void:
	(
		assert_bool(IsEqual.new(NAN).matches(NAN))
		. override_failure_message("IsEqual must not match NAN, since NAN equals nothing")
		. is_false()
	)


func test_matches_equal_nested_arrays() -> void:
	(
		assert_bool(IsEqual.new([1, ["run", {"z": 2}]]).matches([1, ["run", {"z": 2}]]))
		. override_failure_message("IsEqual must match nested arrays with equal contents")
		. is_true()
	)


func test_rejects_a_packed_array_for_an_array() -> void:
	(
		assert_bool(IsEqual.new([8, 9]).matches(PackedInt32Array([8, 9])))
		. override_failure_message("IsEqual must not match a packed array against an Array")
		. is_false()
	)


func test_lets_equal_to_decide_for_objects() -> void:
	(
		assert_bool(IsEqual.new(FakeCircle.new(6.25)).matches(FakeCircle.new(6.25)))
		. override_failure_message("IsEqual must match two circles that equal_to() calls equal")
		. is_true()
	)


func test_rejects_an_object_of_another_class() -> void:
	(
		assert_bool(IsEqual.new(FakeCircle.new(1.5)).matches(FakeTag.new("idle")))
		. override_failure_message("IsEqual must not call equal_to() with an unrelated object")
		. is_false()
	)


func test_rejects_another_instance_without_equal_to() -> void:
	(
		assert_bool(IsEqual.new(FakeTag.new("run")).matches(FakeTag.new("run")))
		. override_failure_message("IsEqual must compare objects without equal_to() by reference")
		. is_false()
	)


func test_describes_the_expected_value() -> void:
	(
		assert_str(IsEqual.new(3).description())
		. override_failure_message("IsEqual must describe itself as equal to its value")
		. is_equal("equal to 3")
	)


func test_reports_the_actual_value_of_the_same_type() -> void:
	(
		assert_str(IsEqual.new(3).mismatch(4))
		. override_failure_message("IsEqual must report the actual int")
		. is_equal("was 4")
	)


func test_reports_the_type_of_a_wrong_value() -> void:
	(
		assert_str(IsEqual.new(3).mismatch("3"))
		. override_failure_message("IsEqual must name the type of a text given for an int")
		. is_equal('was a String: "3"')
	)


# gdlint: disable=unused-argument
@warning_ignore("unused_parameter")
func test_matches_any_fuzzed_int_against_itself(
	fuzzer := Fuzzers.rangei(-1000000, 1000000), fuzzer_iterations := 40, fuzzer_seed := 913
) -> void:
	var number: int = fuzzer.next_value()
	(
		assert_bool(IsEqual.new(number).matches(number))
		. override_failure_message("IsEqual must match every int against itself")
		. is_true()
	)
# gdlint: enable=unused-argument
