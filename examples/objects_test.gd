extends GdUnitTestSuite


func test_compares_value_objects_with_equal_to() -> void:
	Assertion.new(
		"Adding 2.50 USD to 1.75 USD must give 4.25 USD, a new but equal object",
		Money.new(250, "USD").plus(Money.new(175, "USD")),
		IsEqual.new(Money.new(425, "USD")),
	).affirm()


func test_returns_a_new_object_instead_of_changing_itself() -> void:
	var wallet: Money = Money.new(100, "EUR")
	Assertion.new(
		"plus() must return a new Money and leave the original alone",
		wallet.plus(Money.new(1, "EUR")),
		IsNot.new(IsSame.new(wallet)),
	).affirm()


func test_creates_the_class_it_was_asked_for() -> void:
	Assertion.new(
		"plus() must return Money, not some other object",
		Money.new(5, "UAH").plus(Money.new(5, "UAH")),
		IsInstanceOf.new(Money),
	).affirm()


func test_keeps_the_currency_of_the_left_operand() -> void:
	Assertion.new(
		"plus() must keep the currency of the Money it was called on",
		Money.new(999, "JPY").plus(Money.new(1, "JPY")),
		HasFeature.new("currency", IsEqual.new("JPY")),
	).affirm()
