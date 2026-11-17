class_name Assertion
extends RefCounted

const Verdict := preload("res://addons/gdcrest/core/verdict.gd")
const GdUnit4Report := preload("res://addons/gdcrest/gdunit4/gdunit4_report.gd")

var _reason: String
var _actual: Variant
var _matcher: Matcher


func _init(reason: String, actual: Variant, matcher: Matcher) -> void:
	_reason = reason
	_actual = actual
	_matcher = matcher


func affirm() -> void:
	Verdict.new(_reason, _actual, _matcher).deliver(GdUnit4Report.new(_actual))
