extends GdUnitTestSuite

const GdUnit4Report := preload("res://addons/gdcrest/gdunit4/gdunit4_report.gd")


func test_accepts_as_a_passed_gdunit4_assertion() -> void:
	GdUnit4Report.new(0.75).accept()
