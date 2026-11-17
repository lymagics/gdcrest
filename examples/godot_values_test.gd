extends GdUnitTestSuite


func test_turns_right_into_left_after_half_a_turn() -> void:
	Assertion.new(
		"Rotating RIGHT by PI around UP must point LEFT, give or take rounding",
		Vector3.RIGHT.rotated(Vector3.UP, PI),
		IsApproximately.new(Vector3.LEFT),
	).affirm()


func test_mixes_red_and_blue_into_purple() -> void:
	Assertion.new(
		"Halfway between red and blue must be purple",
		Color.RED.lerp(Color.BLUE, 0.5),
		IsApproximately.new(Color(0.5, 0.0, 0.5)),
	).affirm()


func test_undoes_a_transform_with_its_inverse() -> void:
	var move: Transform2D = Transform2D(0.3, Vector2(10, -4))
	Assertion.new(
		"A transform followed by its inverse must change nothing",
		move * move.affine_inverse(),
		IsApproximately.new(Transform2D.IDENTITY),
	).affirm()
