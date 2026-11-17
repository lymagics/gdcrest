extends GdUnitTestSuite


func test_splits_text_in_its_original_order() -> void:
	Assertion.new(
		"split() must keep the parts in the order they appear",
		"idle,run,jump".split(","),
		Contains.new(["idle", "run", "jump"]),
	).affirm()


func test_lists_dictionary_keys_whatever_their_order() -> void:
	Assertion.new(
		"keys() must return exactly the keys that were stored",
		{"volume": 0.8, "muted": false, "language": "uk"}.keys(),
		ContainsInAnyOrder.new(["language", "muted", "volume"]),
	).affirm()


func test_finds_the_input_actions_a_menu_needs() -> void:
	Assertion.new(
		"The built-in input actions must include accepting and cancelling",
		InputMap.get_actions(),
		HasItems.new([&"ui_accept", &"ui_cancel"]),
	).affirm()


func test_finds_one_item_with_a_matcher() -> void:
	Assertion.new(
		"range(100) must reach past ninety",
		range(100),
		HasItem.new(GreaterThan.new(90.0)),
	).affirm()


func test_drops_empty_parts_when_asked() -> void:
	Assertion.new(
		"split() without empty parts must give nothing for a text of only commas",
		",,,".split(",", false),
		IsEmpty.new(),
	).affirm()


func test_counts_the_parts_of_a_version() -> void:
	Assertion.new(
		"A semantic version must split into three parts",
		"v1.12.0".trim_prefix("v").split("."),
		HasLength.new(3),
	).affirm()


func test_reports_the_engine_major_version() -> void:
	Assertion.new(
		"The engine running these examples must be Godot 4",
		Engine.get_version_info(),
		HasEntry.new("major", 4),
	).affirm()


func test_parses_json_numbers_as_floats() -> void:
	Assertion.new(
		"JSON numbers must come back as floats, so 12 becomes 12.0",
		JSON.parse_string('{"health": 12, "name": "slime"}'),
		HasEntry.new("health", 12.0),
	).affirm()
