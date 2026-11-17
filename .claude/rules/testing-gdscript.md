# Testing Rules — GDScript (gdUnit4 + gdcrest)

GDScript port of the Tanka `testing.md` rules. Where Godot or gdUnit4 cannot express a rule
directly, the rule is replaced with the closest equivalent. Those places are marked **GDScript**.

---
## 1. Test Design
### 1.1 Logic-Free Tests
- Unit tests must be logic-free: they must not implement any algorithms.
- Aim for one-statement tests.

### 1.2 Assertions
- Each test must contain exactly one assertion.
- Each test must contain at least one assertion.
- The last statement in every test must be an assertion.
- Do not assert on the absence of failure.
- Never assert on side effects.
- Be creative with assertions.
- Use gdcrest to achieve this: `Assertion.new(reason, actual, matcher).affirm()`.
- **GDScript**: gdcrest's own matchers are tested with plain gdUnit4 assertions
  (`assert_bool`, `assert_str`, ...), never with gdcrest itself, so a broken matcher can't hide
  its own bug.

### 1.3 Test Inputs
- Whenever possible, tests should use irregular, boundary, or strange inputs to provoke hidden
  issues: `NAN`, `INF`, `-0.0`, int64 min and max, `""`, Unicode text, empty and nested
  collections, typed and packed arrays, freed objects.
- Every test must use its own literals, numbers, and input values.
- Do not reuse inputs across tests, as this may falsely suggest shared meaning.
- Always write descriptive failure messages: the gdcrest reason, or
  `override_failure_message()` in a plain gdUnit4 assertion.

### 1.4 Test Isolation
- Test methods must share absolutely no fixtures with other test methods.
- **GDScript**: no `before()`, `before_test()` or suite-level variables.

---
## 2. Naming and Documentation
### 2.1 Test Naming
- Test names must be complete English phrases that would start with "it" if written fully.
  Example: `test_(it)_lists_moons_in_orbital_order` is written `test_lists_moons_in_orbital_order`.
- "it" refers to the object under test, not the test itself.
- **GDScript**: gdUnit4 discovers tests by the `test_` prefix, so every name keeps it.

### 2.2 Documentation
- Tests must not contain documentation comments (`##`).

---
## 3. Scope and Boundaries
### 3.1 What to Test
- Never write tests for private methods (`_` prefix).
- Avoid overtesting.
- Tests must never be the reason for expanding an object's public interface.
- Avoid testing abstract classes directly.

### 3.2 Feature Class Correspondence
- Each feature class must have exactly one corresponding test suite, named
  `<snake_case_class>_test.gd`, in a folder that mirrors the class's folder.
- Feature classes should trust each other and only guard against invalid end-user input.

---
## 4. Resources and Cleanup
### 4.1 System Resources
- Tests must close all system resources when they finish: free every `Node` they create.
- Tests that require resources must begin with cleanup.

### 4.2 File Handling
- If a test works with files, it must create its own temporary directory and store all files
  there.
- Do not mock the file system.
- Place all temporary files inside the top-level `tmp/` directory, which has a `.gdignore`.

---
## 5. Fakes and Logging
### 5.1 Fakes Over Mocks
- Do not use mocks, doubles or spies (`mock()`, `spy()`, `double()`). Use fake classes that
  implement interfaces, kept in `test/fakes/`.

### 5.2 Logging
- Logging should be disabled during tests whenever possible.
- If logging is part of the specification, test it using fake classes that capture messages
  instead of printing them.

---
## 6. Test Patterns
### 6.1 Parametrized Tests
- If multiple inputs share the same scenario, use gdUnit4 parameterized tests
  (`test_parameters := [...]`).

### 6.2 Thread Safety
- If a class uses threads or claims thread safety, there must be tests confirming its thread
  safety.

### 6.3 Flaky Tests
- Rerun a flaky test with gdUnit4's `--retry-count` instead of hiding the flakiness.

### 6.4 Online Tests
- Tests must not need the Internet. Anything that does belongs outside the unit suites.

---
## 7. Test-Driven Development
### 7.1 Bug Fixes
- Before fixing a bug, reproduce it with a failing test case.

### 7.2 New Features
- Before adding a new feature, there must be a failing test first.

---
## 8. Test Execution
### 8.1 Performance
- Every test must finish in under 200 ms.

### 8.2 Randomization
- Property tests use gdUnit4 fuzzers with a fixed `fuzzer_seed`, so a failure reproduces.

---
## 9. Test Categories
### 9.1 Fast Tests (Unit)
- Minimal execution time. Run with `make unit`.

### 9.2 Deep Tests (Integration)
- Realistic end-to-end scenarios, such as a fixture suite run through gdUnit4's command-line
  runner. Run with `make deep`.

---
## 10. Quality Tools
### 10.1 Formatting and Linting
- Use gdtoolkit: `gdformat --check` and `gdlint`.

### 10.2 Script Warnings
- Treat every GDScript warning as an error in the code under test.
