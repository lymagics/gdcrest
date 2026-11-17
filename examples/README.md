# gdcrest examples

Each file shows one way to use gdcrest. The tests check Godot's own API (strings, arrays, JSON,
vectors, ...), so there is no game code to read first; every line here is about the library.

| File | Shows |
|---|---|
| [basics_test.gd](basics_test.gd) | One assertion per test: reason, actual value, matcher |
| [composition_test.gd](composition_test.gd) | `AllOf`, `AnyOf`, `IsNot` and matchers inside matchers |
| [numbers_test.gd](numbers_test.gd) | `IsCloseTo`, `GreaterThan`, `IsBetween`, `IsNan` |
| [text_test.gd](text_test.gd) | `EndsWith`, `ContainsText`, `MatchesRegex` |
| [collections_test.gd](collections_test.gd) | `Contains`, `ContainsInAnyOrder`, `HasItems`, `HasItem`, `IsEmpty`, `HasLength`, `HasEntry` |
| [objects_test.gd](objects_test.gd) | `equal_to()` with `IsEqual`, `IsSame`, `IsInstanceOf`, `HasFeature` |
| [godot_values_test.gd](godot_values_test.gd) | `IsApproximately` for vectors, colors and transforms |
| [custom_matcher_test.gd](custom_matcher_test.gd) | Using a matcher you wrote yourself |
| [support/](support) | `IsEven`, a custom matcher, and `Money`, a small value object for the object examples |

They run with the rest of the suite (`make unit`), so they always match the current API.

## 1. One assertion, one sentence

Every test is a single statement: the reason, the actual value, then the matcher it must satisfy.

```gdscript
func test_capitalizes_a_snake_case_name() -> void:
	Assertion.new(
		"capitalize() must turn a snake_case name into words with capitals",
		"move_speed".capitalize(),
		IsEqual.new("Move Speed"),
	).affirm()
```

The reason is a full sentence saying what must be true. It becomes the first line of the failure
message, so write it for whoever reads that message. An empty reason fails the test.

`IsEqual` checks the type too, so the float `3.0` never equals the int `3`:

```gdscript
Assertion.new(
	"to_float() must give a float, which IsEqual never confuses with the int 3",
	"3".to_float(),
	IsNot.new(IsEqual.new(3)),
).affirm()
```

## 2. Composing matchers

Matchers wrap each other, so a precise claim needs no new code:

```gdscript
Assertion.new(
	"A scene path must start in res://scenes/ and end in .tscn",
	"res://scenes/levels/forest.tscn",
	AllOf.new([StartsWith.new("res://scenes/"), EndsWith.new(".tscn")]),
).affirm()
```

Matchers that take a value usually take a matcher as well:

```gdscript
# Every item must be between 0 and 1, and none may be NAN.
EveryItem.new(AllOf.new([IsBetween.new(0.0, 1.0), IsNot.new(IsNan.new())]))

# The length must be from 4 to 16.
HasLength.new(AllOf.new([GreaterThan.new(3.0), LessThan.new(17.0)]))

# Some item must be above 90.
HasItem.new(GreaterThan.new(90.0))
```

## 3. Collections

Pick the matcher that says exactly what the test claims:

| Claim | Matcher |
|---|---|
| These items, in this order | `Contains.new(["idle", "run", "jump"])` |
| These items, in any order | `ContainsInAnyOrder.new(["language", "muted", "volume"])` |
| At least these items | `HasItems.new([&"ui_accept", &"ui_cancel"])` |
| At least one matching item | `HasItem.new(GreaterThan.new(90.0))` |
| Every item meets a rule | `EveryItem.new(IsEven.new())` |
| Nothing at all | `IsEmpty.new()` |
| A size | `HasLength.new(3)` |
| A dictionary entry | `HasEntry.new("health", 12.0)` |

They accept `Array`, typed arrays and packed arrays, so `split()` results and
`InputMap.get_actions()` work as they are.

## 4. Numbers and Godot values

Computed floats are rarely exact. `IsCloseTo` takes a tolerance:

```gdscript
Assertion.new(
	"sqrt(2) must be 1.41421 to five decimal places",
	sqrt(2.0),
	IsCloseTo.new(1.41421, 0.000005),
).affirm()
```

`IsApproximately` does the same for vectors, colors, transforms and other Godot value types,
using their `is_equal_approx()`:

```gdscript
Assertion.new(
	"Rotating RIGHT by PI around UP must point LEFT, give or take rounding",
	Vector3.RIGHT.rotated(Vector3.UP, PI),
	IsApproximately.new(Vector3.LEFT),
).affirm()
```

## 5. Objects

`IsEqual` asks an object's own `equal_to()` method, so value objects compare by value:

```gdscript
Assertion.new(
	"Adding 2.50 USD to 1.75 USD must give 4.25 USD, a new but equal object",
	Money.new(250, "USD").plus(Money.new(175, "USD")),
	IsEqual.new(Money.new(425, "USD")),
).affirm()
```

`HasFeature` checks what one method returns, and `IsSame` checks identity:

```gdscript
HasFeature.new("currency", IsEqual.new("JPY"))
IsNot.new(IsSame.new(wallet))
```

## 6. Your own matcher

When a claim keeps coming back, give it a name. A matcher is one class with three methods; see
[support/is_even.gd](support/is_even.gd):

```gdscript
class_name IsEven
extends Matcher


func matches(actual: Variant) -> bool:
	return actual is int and int(actual) % 2 == 0


func description() -> String:
	return "an even int"


func mismatch(actual: Variant) -> String:
	return "was %d, an odd int" % actual if actual is int else "was %s" % [actual]
```

`description()` follows `Expected:` and `mismatch()` follows `but:` in the failure message. It
works anywhere a built-in matcher does:

```gdscript
Assertion.new(
	"range() with a step of 2 from 0 must give only even numbers",
	range(0, 20, 2),
	EveryItem.new(IsEven.new()),
).affirm()
```

## 7. What a failure looks like

All the examples pass. These are the messages gdcrest printed when the same assertions were broken
on purpose. gdUnit4 shows each one at the line of the failing `Assertion.new(`, so clicking it
opens the test, not the library.

Items in the wrong order: the index and value of the first wrong item.

```
split() must keep the parts in the order they appear
Expected: exactly ["idle", "run", "jump"], in this order
     but: item 1 was "jump"
```

A composed matcher: the whole expectation, then what was actually there.

```
A scene path must start in res://scenes/ and end in .tscn
Expected: a text starting with "res://scenes/" and a text ending with ".tscn"
     but: was "res://scenes/levels/forest.scn"
```

A value of the wrong type: the message names the type, here because JSON numbers are floats.

```
JSON numbers must come back as floats, so 12 becomes 12.0
Expected: a dictionary with entry "health": 12
     but: "health" was a float: 12.0
```

A matcher inside a collection matcher: which item failed, and why.

```
split_floats() must give only values from zero to one
Expected: a collection where every item is a number from 0.0 to 1.0
     but: item 1 was 1.5, above 1.0
```

A custom matcher, in its own words:

```
roundi(4.5) must round up to an even number
Expected: an even int
     but: was 5, an odd int
```
