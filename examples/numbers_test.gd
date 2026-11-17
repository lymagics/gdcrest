extends GdUnitTestSuite


func test_computes_a_square_root_closely_enough() -> void:
	Assertion.new(
		"sqrt(2) must be 1.41421 to five decimal places",
		sqrt(2.0),
		IsCloseTo.new(1.41421, 0.000005),
	).affirm()


func test_eases_out_above_the_linear_value() -> void:
	Assertion.new(
		"An ease-out curve must be ahead of linear motion halfway through",
		ease(0.5, 0.5),
		GreaterThan.new(0.5),
	).affirm()


func test_keeps_a_seeded_random_number_in_range() -> void:
	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = 913
	Assertion.new(
		"randf_range() must stay inside the range it was given",
		random.randf_range(-2.5, 2.5),
		IsBetween.new(-2.5, 2.5),
	).affirm()


func test_gives_nan_for_the_square_root_of_a_negative_number() -> void:
	Assertion.new(
		"sqrt() of a negative number must be NAN, not zero",
		sqrt(-4.0),
		IsNan.new(),
	).affirm()
