extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func _initialize() -> void:
	ProjectSettings.load_resource_pack(ToolPaths.game_pack())
	var scene_text = FileAccess.get_file_as_string("res://scenes/screens/character_select_screen.tscn")
	var in_node = false
	for line in scene_text.split("\n"):
		if line.begins_with("[node "):
			in_node = (line.contains('name="CharacterSelectScreen"') or line.contains('name="AnimatedBg"') or line.contains('name="Bg"'))
		if in_node:
			print(line)
	quit(0)
