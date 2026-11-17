extends GdUnitTestSuite


func test_capitalizes_a_snake_case_name() -> void:
	Assertion.new(
		"capitalize() must turn a snake_case name into words with capitals",
		"move_speed".capitalize(),
		IsEqual.new("Move Speed"),
	).affirm()


func test_parses_an_int_from_text() -> void:
	Assertion.new(
		"to_int() must read a negative number from text",
		"-17".to_int(),
		IsEqual.new(-17),
	).affirm()


func test_keeps_int_and_float_apart() -> void:
	Assertion.new(
		"to_float() must give a float, which IsEqual never confuses with the int 3",
		"3".to_float(),
		IsNot.new(IsEqual.new(3)),
	).affirm()
