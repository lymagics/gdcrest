extends GdUnitTestSuite


func test_counts_by_twos() -> void:
	Assertion.new(
		"range() with a step of 2 from 0 must give only even numbers",
		range(0, 20, 2),
		EveryItem.new(IsEven.new()),
	).affirm()


func test_rounds_half_up_to_an_even_number() -> void:
	Assertion.new(
		"roundi(5.5) must round up to 6",
		roundi(5.5),
		IsEven.new(),
	).affirm()
