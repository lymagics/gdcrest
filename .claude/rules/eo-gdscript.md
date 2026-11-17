# Elegant Objects Coding Rules — GDScript (Godot 4.5+)

GDScript port of the Tanka `eo.md` rules. Where GDScript cannot express a rule
directly, the rule is replaced with the closest equivalent. Those places are marked **GDScript**.

---
## 0. Scope: Domain Layer vs Node Layer
- The code is split into two layers.
- **Domain layer**: classes that `extends RefCounted` (or an `@abstract` interface that extends `RefCounted`). All rules below apply in full.
- **Node layer**: scripts that `extends Node` / `Node2D` / `Node3D` / `Control` / etc. The engine requires this inheritance and mutability. These scripts are thin adapters that build domain objects and pass their results to the engine (see section 11).
- Game rules, generation, simulation and calculations never live in the Node layer.
- The Node layer never contains logic that could live in the domain layer.

---
## 1. General
### 1.1 Language
- Always use static typing: every variable, parameter and return type is declared, including `-> void`.
- Enforce it in Project Settings → Debug → GDScript: set `untyped_declaration` to **Error**.
- Use typed collections: `Array[Star]`, `Dictionary[String, Planet]`.
- Never use `Variant` in domain code unless there is a strong reason to.

---
## 2. Naming
### 2.1 Class Names
- Never use class names ending in -er, -or, or -Utils (exceptions: User, Computer).
- Naming a class based on what its objects do is incorrect.
- Classes should be named based on what they are, not what they do.
- Think about what the objects will encapsulate and choose a name that represents that conceptual group.
- Use `class_name` in PascalCase, with one class per file. The file name is the snake_case form of the class name (`seeded_star.gd`).

### 2.2 Method Names
- A builder is a method that constructs or returns something.
- A builder never returns `null`, and its name must always be a noun (optionally with an adjective).

```gdscript
func power(base: int, exponent: int) -> int:
	pass


func speed() -> float:
	pass


func planet(index: int) -> Planet:
	pass


func parsed_cell(x: int, y: int) -> String:
	pass
```

- A manipulator is a method that modifies the real-world entity represented by an object.
- A manipulator always returns `void` (declared explicitly), and its name must always be a verb (optionally with an adverb).

```gdscript
func save(content: String) -> void:
	pass


func put(key: String, value: float) -> void:
	pass


func remove(star: Star) -> void:
	pass


func quickly_print(id: int) -> void:
	pass
```

- If a builder returns a Boolean value, its name should be an adjective.
- The prefixes `is_` and `get_` are redundant and should not be used in your own code. Temporarily adding `is_` can help check that the name sounds correct.

```gdscript
func empty() -> bool:
	pass


func habitable() -> bool:
	pass


func negative() -> bool:
	pass
```

- `equals` should be named `equal_to`. **GDScript**: `==` compares object references, so value equality must always be an explicit `equal_to(other)` method.
- `exists` should be named `present`.
- Engine callbacks (`_ready`, `_process`, `_draw`, …) and engine API calls are exempt from these naming rules.

### 2.3 Variable Names
- Do not use compound names anywhere in the code.
- Every variable must have a name consisting of a single noun.
- Exceptions are allowed only when a single noun would lose its meaning without an adjective, for example: `time_zone`, `side_effect`, `MicroService`, `bus_stop`, `black_hole`.
- **GDScript**: never shadow built-in functions or inherited members (`seed`, `range`, `str`, `name`, `position`, `owner`). Choose another noun, for example `number` instead of `seed`.

---
## 3. Constructors
### 3.1 Constructor Design
- **GDScript**: a class has exactly one constructor, `_init`, and GDScript has no overloading.
- Keep `_init` code-free: it may contain only assignment statements.
- Instead of secondary constructors, create a separate class that implements the same interface and delegates to the primary class lazily, inside its methods.
- Do not use default parameter values to simulate overloads.

```gdscript
# cash.gd
@abstract
class_name Cash
extends RefCounted

@abstract func dollars() -> int
```

```gdscript
# dollar_cash.gd
class_name DollarCash
extends Cash

var _value: int

func _init(value: int) -> void:
	_value = value

func dollars() -> int:
	return _value
```

```gdscript
# text_cash.gd — replaces the "secondary constructor" from str
class_name TextCash
extends Cash

var _text: String

func _init(text: String) -> void:
	_text = text

func dollars() -> int:
	return DollarCash.new(_text.to_int()).dollars()
```

---
## 4. Objects and Encapsulation
### 4.1 Attributes
- All encapsulated objects (attributes) are part of an object's identity.
- An object should encapsulate four or fewer attributes.
- If more attributes are required, they should be grouped into other objects.
- Together, these objects should form a structured tree of objects.
- An object that encapsulates nothing should not exist.
- Never create getters and setters. This includes GDScript property syntax (`var x: int: get = ..., set = ...`).
- **GDScript**: there are no private members. All attributes are prefixed with `_` and are never accessed from outside the class.
- Never add an attribute or method to an object at runtime: no `set_meta()`, no dynamic `set("field", ...)`, no `Dictionary` used as an ad-hoc object.

---
## 5. Interfaces and Methods
### 5.1 Interfaces
- Always use interfaces.
- **GDScript**: an interface is an `@abstract` class in which every method is `@abstract` and there are no attributes.
- Ensure that every public method in a class implements an interface.
- **GDScript**: a class can extend only one interface. If an object needs two roles, split it into two objects, or wrap one in the other.
- Keep interfaces minimal.
- Add convenience behavior through smart wrappers, written as an inner class named `Smart`.

```gdscript
# Instead of:
@abstract
class_name Exchange
extends RefCounted

@abstract func rate(target: String, source: String = "USD") -> float
```

```gdscript
# Use:
@abstract
class_name Exchange
extends RefCounted

@abstract func rate(target: String, source: String) -> float


class Smart:
	var _origin: Exchange

	func _init(origin: Exchange) -> void:
		_origin = origin

	func to_usd(source: String) -> float:
		return _origin.rate(source, "USD")
```

```gdscript
# Usage:
var rate: float = Exchange.Smart.new(Nyse.new()).to_usd("EUR")
```

### 5.2 Methods
- The more methods a class exposes, the harder it becomes to use correctly.
- The number of public methods in a class should be five or fewer.
- Private helper methods are prefixed with `_`.
- Never create static methods (`static func`) or static variables (`static var`).
- Long methods are forbidden.
- Methods with multiple `return` statements are forbidden. Use the conditional expression `a if condition else b` when a branch is needed.

---
## 6. Immutability
### 6.1 Immutable Objects
- All classes should be immutable.
- **GDScript**: there is no `final` or read-only field. An attribute is assigned only in `_init` and never reassigned anywhere else. Enforce this through code review and linting.
- **GDScript**: arrays and dictionaries are shared by reference. When returning an encapsulated collection, return `collection.duplicate()`, or call `make_read_only()` on it in the method that builds it.
- If modification is needed, create a new object instead.

```gdscript
func moved(offset: Vector3) -> Orbit:
	return Orbit.new(_center + offset, _radius)
```

- Godot built-in value types (`Vector3`, `Color`, `Transform3D`, `String`) are copied on assignment and may be used freely as attributes.

---
## 7. Testing
### 7.1 Unit Tests
- Write unit tests instead of doc comments (`##`).
- Use GUT or gdUnit4 to test domain classes. The domain layer must be testable without a scene tree.
- Do not use mocks, doubles or spies (`double()`, `mock()`, `spy()`).
- Instead of mocks, create fake classes that implement interfaces and use them in unit tests.

```gdscript
class FakeStar extends Star:
	var _mass: float

	func _init(mass: float) -> void:
		_mass = mass

	func mass() -> float:
		return _mass

	func luminosity() -> float:
		return 1.0
```

---
## 8. Constants
### 8.1 Avoiding Constants
- Do not use global constants or autoloads that hold constants.
- Instead, create a class that encapsulates the semantic meaning of the constant.

```gdscript
# Wrong
class_name Constants
extends RefCounted

const EOL := "\n"
```

```gdscript
# Correct
class_name EolText
extends RefCounted

var _origin: String

func _init(origin: String) -> void:
	_origin = origin

func _to_string() -> String:
	return _origin + "\n"
```

- Stay away from class-level `const` and `enum` used as shared configuration.
- Repeat the literal with a specific message, or move the shared logic into a private method.

```gdscript
# Bad
const NOT_FOUND := "planet not found"

func orbit() -> Orbit:
	assert(_found(), NOT_FOUND)
	...

# Good
func orbit() -> Orbit:
	assert(_found(), "planet not found, can't compute its orbit")
	...
```

- Pure math constants from the engine (`PI`, `TAU`, `INF`) are allowed.

---
## 9. Errors and Fail-Fast
**GDScript**: there are no exceptions, no `try`/`catch` and no `raise`. The rules in this section replace Python exception handling.

### 9.1 Fail-Fast
- Always follow the fail-fast approach.
- Use `assert(condition, message)` in any suspicious situation. Every assert must have a message.
- **GDScript**: `assert` runs only in debug builds and editor runs. It is removed from release exports. Never put side effects inside an assert expression.
- When something is not found, do one of the following: return a collection (possibly empty); return a Null Object; fail with an assert in debug builds.
- Never return `null` from a builder.

```gdscript
class_name NullPlanet
extends Planet

var _label: String

func _init(label: String) -> void:
	_label = label

func name() -> String:
	return _label

func colonize(ship: Ship) -> void:
	assert(false, "You can't colonize a planet that doesn't exist")
```

- Never accept `null` as an argument. Object types are always nullable in GDScript, so this is a discipline, not a compiler guarantee.
- Instead of `null`, create a Null Object implementation.

```gdscript
@abstract
class_name Mask
extends RefCounted

@abstract func matches(file: SaveFile) -> bool
```

```gdscript
class_name AnyFile
extends Mask

func matches(file: SaveFile) -> bool:
	return true
```

### 9.2 Error Handling
- Engine calls that can fail (`FileAccess.open`, `JSON.parse`, `ResourceLoader.load`) are wrapped in one domain class each. That class is the only place where the engine's error codes are checked.
- Since errors can't be chained, add context: put what failed, the input, and the engine error (`error_string(code)`) into one message.

```gdscript
func content() -> String:
	var file: FileAccess = FileAccess.open(_path, FileAccess.READ)
	assert(file != null, "Can't read save file '%s': %s" % [_path, error_string(FileAccess.get_open_error())])
	return file.get_as_text()
```

- Errors that must be handled in release builds are modelled as objects, not as `null` or error codes. Return a Null Object or an empty collection, and report once with `push_error(message)`.
- Recover only once, at the highest level: the root Node that composes the domain objects.

### 9.3 Validation
- Input validation and assertions should be implemented through decorators (wrappers), not inside core logic.

```gdscript
@abstract
class_name Day
extends RefCounted

@abstract func distance_to(end: Day) -> int
@abstract func number() -> int
```

```gdscript
class_name CalendarDay
extends Day

var _number: int

func _init(number: int) -> void:
	_number = number

func distance_to(end: Day) -> int:
	return end.number() - _number

func number() -> int:
	return _number
```

```gdscript
class_name StrictDay
extends Day

var _origin: Day

func _init(origin: Day) -> void:
	_origin = origin

func distance_to(end: Day) -> int:
	assert(end.number() >= _origin.number(), "Start %d must be earlier than end %d" % [_origin.number(), end.number()])
	return _origin.distance_to(end)

func number() -> int:
	return _origin.number()
```

```gdscript
# Usage
var day: Day = StrictDay.new(CalendarDay.new(12))
```

- **GDScript**: there are no function decorators, so aspect-oriented concerns (retries, logging, caching, timing) are implemented as wrapper objects that implement the same interface.

```gdscript
class_name LoggedPage
extends Page

var _origin: Page

func _init(origin: Page) -> void:
	_origin = origin

func content() -> String:
	var text: String = _origin.content()
	print_verbose("Page loaded: %d characters" % text.length())
	return text
```

```gdscript
# Usage
var page: Page = LoggedPage.new(FilePage.new("user://log.txt"))
```

---
## 10. Composition over Inheritance
### 10.1 Class Structure
- A class should be final (all methods implemented) or abstract (an interface: only `@abstract` methods, no attributes).
- `extends` is allowed only for:
  - an `@abstract` interface;
  - `RefCounted` (the domain base);
  - an engine class required by the Node layer (`Node3D`, `Control`, `Resource`, …).
- Never extend a concrete class you wrote yourself. There is no place for implementation inheritance and no `super` calls in domain code.

### 10.2 Composition and Decorators
- Prefer composable decorators to build behavior step by step.

```gdscript
var names: Names = Sorted.new(
	Unique.new(
		Capitalized.new(
			PlanetNames.new(
				StarSystem.new(42),
			),
		),
	),
)
```

- Whenever you need to add new functionality to an existing class, create a new class or decorate an existing one.
- Modifying the original class should always be the last resort.
- Never use dependency injection containers or service locators.
- Use decorators (wrappers) for access control.

```gdscript
var ship: Ship = DockedShip.new(CargoShip.new("Kestrel"), station)
```

- Use object composition instead of MVC or manager nodes.

```gdscript
# Wrong
class_name PlanetManager
extends Node
# Holds state, fetches data and updates UI
```

```gdscript
# Good: the root Node composes once and hands the result to the engine
extends Control

func _ready() -> void:
	$Card.text = PlanetCard.new(
		Habitable.new(SeededPlanet.new(42, 3)),
	).text()
```

### 10.3 Forbidden Patterns
- Never use the Singleton pattern. In Godot, this means never use autoloads (Project Settings → Globals) for domain objects or shared state.
- Never use global mutable state, including `static var`.
- Never use groups or `get_tree().get_first_node_in_group()` as a lookup service from domain code.

---
## 11. Node Layer (Godot Edge)
- A Node script builds domain objects (usually in `_ready`), calls their builders, and writes the results into engine properties.
- Node scripts may be mutable and use engine naming (`_process`, `get_node`, `is_on_floor`). They still follow the static typing and variable naming rules.
- `@export` variables are configuration from the editor. They exist only on Nodes and Resources, and are passed into domain objects' constructors.
- Custom `Resource` files are editor data, not domain objects. Wrap a Resource in a domain class instead of adding behavior to it.
- Signals belong to the Node layer. Domain objects don't emit or connect signals.
- Performance: don't build new domain object graphs every frame in `_process` or `_physics_process`. Compose them once (or when the inputs change) and keep the result in the Node. Per-frame hot loops stay in the Node layer and use engine types (`PackedVector3Array`, `MultiMesh`, servers).
- A Node script should be short. If it needs more than a few lines of logic, that logic belongs in a domain class.
