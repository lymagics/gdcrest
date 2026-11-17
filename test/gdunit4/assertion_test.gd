extends GdUnitTestSuite


func test_passes_when_the_value_matches() -> void:
	Assertion.new(
		"A list built by hand must hold its three states in order",
		["idle", "run", "jump"],
		Contains.new(["idle", "run", "jump"]),
	).affirm()


func test_passes_a_composed_matcher() -> void:
	Assertion.new(
		"A level name must carry its number without being only the number",
		"Level 77",
		AllOf.new([EndsWith.new("77"), IsNot.new(IsEqual.new("77"))]),
	).affirm()
