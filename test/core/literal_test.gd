extends GdUnitTestSuite

const Literal := preload("res://addons/gdcrest/core/literal.gd")


func test_quotes_text_and_escapes_quotes_tabs_and_newlines() -> void:
	(
		assert_str(str(Literal.new('idle "the\tfirst"\nframe')))
		. override_failure_message(
			"Literal must quote text and escape its quotes, tabs and newlines"
		)
		. is_equal('"idle \\"the\\tfirst\\"\\nframe"')
	)


func test_escapes_backslashes_in_text() -> void:
	(
		assert_str(str(Literal.new("C:\\save")))
		. override_failure_message(
			"Literal must escape a backslash so the text reads unambiguously"
		)
		. is_equal('"C:\\\\save"')
	)


func test_keeps_unicode_text_as_is() -> void:
	(
		assert_str(str(Literal.new("Київ ☕")))
		. override_failure_message("Literal must keep Unicode characters untouched")
		. is_equal('"Київ ☕"')
	)


func test_prefixes_a_string_name_with_ampersand() -> void:
	(
		assert_str(str(Literal.new(&"idle")))
		. override_failure_message("Literal must render a StringName with the & prefix")
		. is_equal('&"idle"')
	)


func test_renders_the_largest_int_as_is() -> void:
	(
		assert_str(str(Literal.new(9223372036854775807)))
		. override_failure_message("Literal must render the int64 maximum digit for digit")
		. is_equal("9223372036854775807")
	)


func test_renders_a_whole_float_with_a_decimal_point() -> void:
	(
		assert_str(str(Literal.new(3.0)))
		. override_failure_message("Literal must render a whole float with a decimal point")
		. is_equal("3.0")
	)


func test_renders_a_float_in_its_shortest_round_trip_form() -> void:
	(
		assert_str(str(Literal.new(1.0 / 3.0)))
		. override_failure_message("Literal must render a third with every round-trip digit")
		. is_equal("0.3333333333333333")
	)


func test_renders_nan_in_capitals() -> void:
	(
		assert_str(str(Literal.new(NAN)))
		. override_failure_message("Literal must render NAN as NAN")
		. is_equal("NAN")
	)


func test_renders_negative_infinity() -> void:
	(
		assert_str(str(Literal.new(-INF)))
		. override_failure_message("Literal must render negative infinity as -INF")
		. is_equal("-INF")
	)


func test_keeps_the_sign_of_negative_zero() -> void:
	(
		assert_str(str(Literal.new(-0.0)))
		. override_failure_message("Literal must keep the minus sign of negative zero")
		. is_equal("-0.0")
	)


func test_adds_a_decimal_point_to_a_float_in_scientific_form() -> void:
	(
		assert_str(str(Literal.new(1e22)))
		. override_failure_message("Literal must give a float in scientific form a decimal point")
		. is_equal("1.0e+22")
	)


func test_renders_null_as_null() -> void:
	(
		assert_str(str(Literal.new(null)))
		. override_failure_message("Literal must render null as the word null")
		. is_equal("null")
	)


func test_renders_nested_arrays_with_literal_items() -> void:
	(
		assert_str(str(Literal.new([1, ["run", 2.5], false])))
		. override_failure_message("Literal must render nested array items with their own forms")
		. is_equal('[1, ["run", 2.5], false]')
	)


func test_cuts_an_array_after_twenty_items() -> void:
	(
		assert_str(str(Literal.new(range(68))))
		. override_failure_message("Literal must show twenty items and count the rest")
		. ends_with("18, 19, ... (48 more)]")
	)


func test_renders_a_packed_array_like_an_array() -> void:
	(
		assert_str(str(Literal.new(PackedFloat32Array([0.5, -2.0]))))
		. override_failure_message("Literal must render a packed float array like an array")
		. is_equal("[0.5, -2.0]")
	)


func test_renders_a_dictionary_with_literal_keys_and_values() -> void:
	(
		assert_str(str(Literal.new({"health": 3.0, 7: &"tag"})))
		. override_failure_message("Literal must render dictionary keys and values as literals")
		. is_equal('{"health": 3.0, 7: &"tag"}')
	)


func test_renders_a_vector_with_godot_text() -> void:
	(
		assert_str(str(Literal.new(Vector3(1, 0, 0.25))))
		. override_failure_message("Literal must render a vector the way Godot prints it")
		. is_equal("(1.0, 0.0, 0.25)")
	)


func test_uses_the_text_of_an_object_that_defines_one() -> void:
	(
		assert_str(str(Literal.new(FakeTag.new("jump"))))
		. override_failure_message("Literal must use the _to_string() text of an object")
		. is_equal("tag jump")
	)


func test_names_the_class_of_an_object_without_text() -> void:
	(
		assert_str(str(Literal.new(FakeCircle.new(4.5))))
		. override_failure_message("Literal must name the class of an object with no text")
		. starts_with("<FakeCircle#")
	)


func test_cuts_long_text_to_two_hundred_characters() -> void:
	(
		assert_int(str(Literal.new("x".repeat(5000))).length())
		. override_failure_message("Literal must cut a huge text down to 200 characters")
		. is_equal(200)
	)


func test_marks_the_cut_in_the_middle_of_long_text() -> void:
	(
		assert_str(str(Literal.new("a".repeat(150) + "b".repeat(150))))
		. override_failure_message("Literal must mark the middle of a cut text with an ellipsis")
		. contains("aaa...bbb")
	)
