# Changelog

All notable changes to gdcrest are listed here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and versions follow
[Semantic Versioning](https://semver.org/).

## [0.0.1]

### Added

- `Matcher` and `Report` interfaces.
- `Assertion`, which reports each check through gdUnit4 at the test's own line.
- 26 matchers: `IsEqual`, `IsNot`, `IsSame`, `Anything`, `AllOf`, `AnyOf`, `IsCloseTo`,
  `GreaterThan`, `LessThan`, `IsBetween`, `IsNan`, `StartsWith`, `EndsWith`, `ContainsText`,
  `MatchesRegex`, `IsEmpty`, `HasLength`, `HasItem`, `HasItems`, `Contains`,
  `ContainsInAnyOrder`, `EveryItem`, `HasEntry`, `IsInstanceOf`, `HasFeature` and
  `IsApproximately`.
