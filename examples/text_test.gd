extends GdUnitTestSuite


func test_keeps_the_folder_in_a_base_directory() -> void:
	Assertion.new(
		"get_base_dir() must keep the folders of a resource path",
		"res://ui/menus/pause.tscn".get_base_dir(),
		EndsWith.new("/menus"),
	).affirm()


func test_mentions_the_key_in_a_formatted_hint() -> void:
	Assertion.new(
		"A key hint must mention the key it asks for",
		"Press %s to jump" % OS.get_keycode_string(KEY_SPACE),
		ContainsText.new("Space"),
	).affirm()


func test_formats_the_epoch_as_an_iso_date() -> void:
	Assertion.new(
		"get_date_string_from_unix_time() must give an ISO date",
		Time.get_date_string_from_unix_time(0),
		MatchesRegex.new("^\\d{4}-\\d{2}-\\d{2}$"),
	).affirm()
