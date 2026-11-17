extends GdUnitTestSuite


func test_names_a_scene_file_by_its_folder_and_extension() -> void:
	Assertion.new(
		"A scene path must start in res://scenes/ and end in .tscn",
		"res://scenes/levels/forest.tscn",
		AllOf.new([StartsWith.new("res://scenes/"), EndsWith.new(".tscn")]),
	).affirm()


func test_accepts_either_image_format() -> void:
	Assertion.new(
		"get_extension() must find png or webp for an imported texture",
		"res://art/hero.webp".get_extension(),
		AnyOf.new([IsEqual.new("png"), IsEqual.new("webp")]),
	).affirm()


func test_checks_every_item_against_a_composed_rule() -> void:
	Assertion.new(
		"split_floats() must give only values from zero to one",
		"0.25,1,0,0.5".split_floats(","),
		EveryItem.new(AllOf.new([IsBetween.new(0.0, 1.0), IsNot.new(IsNan.new())])),
	).affirm()


func test_bounds_a_length_with_two_matchers() -> void:
	Assertion.new(
		"A generated save slot name must be between 4 and 16 characters long",
		"slot_%03d" % 7,
		HasLength.new(AllOf.new([GreaterThan.new(3.0), LessThan.new(17.0)])),
	).affirm()
