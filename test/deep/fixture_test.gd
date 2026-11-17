extends GdUnitTestSuite


func test_passes_through_gdunit4() -> void:
	Assertion.new(
		"Fixture: the passing assertion must reach gdUnit4 as a success",
		["idle", "run", "jump"],
		Contains.new(["idle", "run", "jump"]),
	).affirm()


func test_fails_through_gdunit4() -> void:
	Assertion.new(
		"split() must keep the parts in the order they appear",
		"idle,jump,run".split(","),
		Contains.new(["idle", "run", "jump"]),
	).affirm()
