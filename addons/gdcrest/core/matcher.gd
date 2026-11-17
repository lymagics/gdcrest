@abstract class_name Matcher
extends RefCounted

@abstract func matches(actual: Variant) -> bool
@abstract func description() -> String
@abstract func mismatch(actual: Variant) -> String
