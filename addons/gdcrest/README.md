# gdcrest

Hamcrest-style matchers for GDScript tests (Godot 4.5+). Each test reads as one sentence: a
reason, an actual value and a composable matcher. Results are reported through
[gdUnit4](https://github.com/godot-gdunit-labs/gdUnit4), so they show up in its editor panel,
its command-line runs and its JUnit reports.

```gdscript
extends GdUnitTestSuite


func test_splits_text_in_its_original_order() -> void:
    Assertion.new(
        "split() must keep the parts in the order they appear",
        "idle,run,jump".split(","),
        Contains.new(["idle", "run", "jump"]),
    ).affirm()
```

When it fails, the message says what was expected and what was wrong, and gdUnit4 points at the
test's own line:

```
split() must keep the parts in the order they appear
Expected: exactly ["idle", "run", "jump"], in this order
     but: item 1 was "jump"
```

## Install

1. Install gdUnit4 6.2 or newer in your project.
2. Copy `addons/gdcrest/` into your project's `addons/` folder, or download the zip from the
   [releases](https://github.com/lymagics/gdcrest/releases) page.

There is nothing to enable: the matchers are global classes. gdcrest is test-only code; keep it
out of exported games.

## Usage

`Assertion.new(reason, actual, matcher).affirm()` checks one value. The reason is a full sentence
saying what must be true; an empty reason fails the test. An `Assertion` that is never affirmed
checks nothing.

Matchers wrap each other:

```gdscript
Assertion.new(
    "A scene path must start in res://scenes/ and end in .tscn",
    "res://scenes/levels/forest.tscn",
    AllOf.new([StartsWith.new("res://scenes/"), EndsWith.new(".tscn")]),
).affirm()
```

[examples/](examples) shows every matcher group, a custom matcher and real failure messages,
all on Godot's own API.

Where an argument says "value or matcher", a plain value means `IsEqual.new(value)`. A matcher
never errors on a value of the wrong type or on `null`: it doesn't match, and the message names
the type (`was a String: "3"`).

## Matchers

| Group | Matcher | Matches when | Description | Mismatch |
|---|---|---|---|---|
| Core | `IsEqual.new(expected)` | Same type and `==`; an object with `equal_to()` decides itself | `equal to 3` | `was 4` |
| Core | `IsNot.new(matcher)` | The matcher doesn't match | `not equal to 3` | `was 3` |
| Core | `IsSame.new(object)` | The very same instance | `the same instance as <Wallet#412>` | `was another <Wallet#413>` |
| Core | `Anything.new()` | Always | `anything` | |
| Core | `AllOf.new([matchers])` | Every matcher matches | parts joined with `and` | the first failing part's mismatch |
| Core | `AnyOf.new([matchers])` | At least one matches | parts joined with `or` | `was 7` |
| Numbers | `IsCloseTo.new(expected, delta)` | An int or float within delta | `a number within 0.5 of 3.0` | `was 3.25, 0.25 away` |
| Numbers | `GreaterThan.new(bound)` | An int or float > bound | `a number greater than 1.0` | `was -1` |
| Numbers | `LessThan.new(bound)` | An int or float < bound | `a number less than 10.0` | `was 12` |
| Numbers | `IsBetween.new(low, high)` | low ≤ value ≤ high | `a number from 1.0 to 2.0` | `was 0.75, below 1.0` |
| Numbers | `IsNan.new()` | A float that is NAN | `NAN` | `was 0.0` |
| Text | `StartsWith.new(prefix)` | A String with that prefix | `a text starting with "res://"` | `was "user://save.json"` |
| Text | `EndsWith.new(suffix)` | A String with that suffix | `a text ending with ".tscn"` | `was "forest.scn"` |
| Text | `ContainsText.new(part)` | A String containing part | `a text containing "Space"` | `was "Press Enter"` |
| Text | `MatchesRegex.new(pattern)` | A String the RegEx finds | `a text matching the pattern "^v\d+$"` | `was "beta-2"` |
| Collections | `IsEmpty.new()` | An empty String, Array, Dictionary or packed array | `an empty collection` | `had 3 items` |
| Collections | `HasLength.new(value or matcher)` | Its length matches | `a collection with length 3` | `had length 2` |
| Collections | `HasItem.new(value or matcher)` | At least one item matches | `a collection containing "run"` | `no item was "run"` |
| Collections | `HasItems.new([values or matchers])` | Every listed item is present, in any order | `a collection containing ["idle", 7], in any order` | `"jump" was missing` |
| Collections | `Contains.new([values or matchers])` | Exactly these items, in this order | `exactly ["idle", "run"], in this order` | `item 1 was "jump"` |
| Collections | `ContainsInAnyOrder.new([values or matchers])` | Exactly these items, in any order | `exactly ["idle", "run"], in any order` | `"walk" was not expected` |
| Collections | `EveryItem.new(matcher)` | Every item matches | `a collection where every item is ...` | `item 2 was -1` |
| Collections | `HasEntry.new(key, value)` (values or matchers) | A Dictionary entry matches both | `a dictionary with entry "health": 12.0` | `"health" was 9.0` |
| Objects | `IsInstanceOf.new(type)` | `is_instance_of(actual, type)` | `an instance of Money` | `was a Node` |
| Objects | `HasFeature.new(method, matcher)` | `actual.call(method)` matches | `an object whose currency() is equal to "JPY"` | `currency() was "USD"` |
| Godot | `IsApproximately.new(expected)` | `is_equal_approx()` on vectors, Quaternion, Color, transforms, Basis, Plane, AABB, Rect2 | `approximately (1.0, 0.0, 0.2)` | `was (1.0, 0.0, 0.3)` |

Collection matchers accept `Array`, typed arrays and packed arrays. `HasEntry` accepts typed
dictionaries. `IsEqual` compares floats exactly; use `IsCloseTo` for computed floats.

## Custom matchers

A matcher is one class with three methods. Keep it in your `test/support/` folder:

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

`description()` follows `Expected:`, and `mismatch()` follows `but:`. `mismatch()` is only called
after `matches()` returned `false`.

## Global names

GDScript has no namespaces, so these names become global in your project. If your game already
uses one, rename yours; gdcrest names stay stable within a major version.

`Matcher`, `Report`, `Assertion`, `IsEqual`, `IsNot`, `IsSame`, `Anything`, `AllOf`, `AnyOf`,
`IsCloseTo`, `GreaterThan`, `LessThan`, `IsBetween`, `IsNan`, `StartsWith`, `EndsWith`,
`ContainsText`, `MatchesRegex`, `IsEmpty`, `HasLength`, `HasItem`, `HasItems`, `Contains`,
`ContainsInAnyOrder`, `EveryItem`, `HasEntry`, `IsInstanceOf`, `HasFeature`, `IsApproximately`.

Everything else is loaded with `preload()` and stays private to the addon.

## Compatibility

| Godot | gdUnit4 | Tested in CI |
|---|---|---|
| 4.5.x, 4.6.x | 6.2.x | Oldest pair: Godot 4.5.1 with gdUnit4 6.2.3 |
| 4.7.x | 6.2.x, 7.0.x | Newest pair: Godot 4.7.2 with gdUnit4 6.2.3 |

## Development

The repository is a small Godot project. Godot must be on your `PATH`, or pass
`GODOT=/path/to/godot` to every `make` call. The linters need `pip install gdtoolkit==4.5.0`.

| Command | What it does |
|---|---|
| `make install` | Downloads the pinned gdUnit4 into `addons/gdUnit4/` (git-ignored) |
| `make unit` | Runs `test/` and `examples/` through gdUnit4's command-line runner |
| `make deep` | Runs a fixture with one failing assertion and checks the JUnit XML |
| `make format` | `gdformat --check` |
| `make lint` | `gdlint` |
| `make warnings` | Parses `addons/gdcrest/` with every warning treated as an error |
| `make names` | Fails if a gdcrest global class clashes with Godot or gdUnit4 |

The code follows the Elegant Objects rules in
[.claude/rules/eo-gdscript.md](.claude/rules/eo-gdscript.md), and the tests follow
[.claude/rules/testing-gdscript.md](.claude/rules/testing-gdscript.md).

## License

[MIT](LICENSE)
