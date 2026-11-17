extends GdUnitTestSuite

const Misfit := preload("res://addons/gdcrest/core/misfit.gd")


func test_names_the_type_and_value() -> void:
	(
		assert_str(str(Misfit.new("3")))
		. override_failure_message("Misfit must give the type and value of a wrong value")
		. is_equal('was a String: "3"')
	)


func test_uses_an_before_a_vowel() -> void:
	(
		assert_str(str(Misfit.new(AABB())))
		. override_failure_message("Misfit must use an before a type name starting with a vowel")
		. starts_with("was an AABB: ")
	)


func test_reports_null_plainly() -> void:
	(
		assert_str(str(Misfit.new(null)))
		. override_failure_message("Misfit must report null without a type")
		. is_equal("was null")
	)
