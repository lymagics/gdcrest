extends GdUnitTestSuite

const Verdict := preload("res://addons/gdcrest/core/verdict.gd")


func test_accepts_a_value_the_matcher_matches() -> void:
	var journal: Array = []
	Verdict.new("Door 3 must open", 3, FakeMatcher.new(true, "open")).deliver(
		FakeReport.new(journal)
	)
	(
		assert_array(journal)
		. override_failure_message("Verdict must accept once when the matcher matches")
		. contains_exactly(["accepted"])
	)


func test_rejects_with_reason_expectation_and_mismatch() -> void:
	var journal: Array = []
	Verdict.new("Level 77 must load", 0, FakeMatcher.new(false, "loaded")).deliver(
		FakeReport.new(journal)
	)
	(
		assert_str(str(journal[0]))
		. override_failure_message("Verdict must reject with the three-line message")
		. is_equal("Level 77 must load\nExpected: loaded\n     but: failed loaded")
	)


func test_reports_the_line_of_the_calling_test() -> void:
	var journal: Array = []
	var report: FakeReport = FakeReport.new(journal)
	Verdict.new("Gate 9 must open", -1, FakeMatcher.new(false, "open")).deliver(report)
	(
		assert_int(int(journal[1]))
		. override_failure_message("Verdict must report line 33, where this test calls it")
		. is_equal(33)
	)


func test_rejects_a_blank_reason_even_when_the_value_matches() -> void:
	var journal: Array = []
	Verdict.new(" \t", "ok", FakeMatcher.new(true, "anything")).deliver(FakeReport.new(journal))
	(
		assert_str(str(journal[0]))
		. override_failure_message("Verdict must reject an assertion whose reason is blank")
		. contains("has no reason")
	)
