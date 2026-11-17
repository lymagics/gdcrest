extends GdUnitTestSuite


func test_matches_a_nearly_equal_vector() -> void:
	(
		assert_bool(IsApproximately.new(Vector3(1, 0, 0.2)).matches(Vector3(1, 0, 0.1 + 0.1)))
		. override_failure_message("IsApproximately must match a vector off by rounding error")
		. is_true()
	)


func test_matches_a_nearly_equal_transform() -> void:
	(
		assert_bool(
			IsApproximately.new(Transform3D.IDENTITY).matches(
				Transform3D.IDENTITY.rotated(Vector3.UP, TAU)
			)
		)
		. override_failure_message("IsApproximately must match a transform turned a full circle")
		. is_true()
	)


func test_matches_a_nearly_equal_color() -> void:
	(
		assert_bool(IsApproximately.new(Color(0.3, 0.6, 0.9)).matches(Color(0.1 * 3, 0.6, 0.9)))
		. override_failure_message("IsApproximately must match a color off by rounding error")
		. is_true()
	)


func test_rejects_a_clearly_different_rect() -> void:
	(
		assert_bool(IsApproximately.new(Rect2(0, 0, 4, 4)).matches(Rect2(0, 0, 4, 4.5)))
		. override_failure_message("IsApproximately must reject a rect half a unit taller")
		. is_false()
	)


func test_rejects_another_value_type() -> void:
	(
		assert_bool(IsApproximately.new(Vector2(1, 1)).matches(Vector2i(1, 1)))
		. override_failure_message("IsApproximately must reject an integer vector for a vector")
		. is_false()
	)


func test_rejects_an_unsupported_expected_type() -> void:
	(
		assert_bool(IsApproximately.new(0.5).matches(0.5))
		. override_failure_message(
			"IsApproximately must reject plain floats; IsCloseTo covers them"
		)
		. is_false()
	)


func test_describes_the_expected_value() -> void:
	(
		assert_str(IsApproximately.new(Vector2(0.5, -1)).description())
		. override_failure_message("IsApproximately must describe the value it expects")
		. is_equal("approximately (0.5, -1.0)")
	)


func test_reports_the_actual_value() -> void:
	(
		assert_str(IsApproximately.new(Vector3.ZERO).mismatch(Vector3(1, 0, 0.2)))
		. override_failure_message("IsApproximately must report the value it got")
		. is_equal("was (1.0, 0.0, 0.2)")
	)


func test_reports_the_type_of_a_wrong_value() -> void:
	(
		assert_str(IsApproximately.new(Vector3.ZERO).mismatch(Vector2.ZERO))
		. override_failure_message("IsApproximately must name the type of a wrong value")
		. is_equal("was a Vector2: (0.0, 0.0)")
	)
