extends SceneTree

# Fails when a gdcrest global class shares its name with a Godot built-in class.
# Run with: godot --headless --path . -s res://test/global_names.gd


func _initialize() -> void:
	var clashes: Array = ProjectSettings.get_global_class_list().filter(
		func(entry: Dictionary) -> bool:
			return (
				String(entry["path"]).begins_with("res://addons/gdcrest/")
				and ClassDB.class_exists(entry["class"])
			)
	)
	for entry: Dictionary in clashes:
		push_error("gdcrest class %s clashes with a Godot built-in class" % entry["class"])
	quit(1 if not clashes.is_empty() else 0)
