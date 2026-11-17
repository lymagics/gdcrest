class_name FakeReport
extends Report

var _journal: Array


func _init(journal: Array) -> void:
	_journal = journal


func accept() -> void:
	_journal.append("accepted")


func reject(text: String, line: int) -> void:
	_journal.append_array([text, line])
