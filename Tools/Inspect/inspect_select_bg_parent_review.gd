extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func _init() -> void:
	ProjectSettings.load_resource_pack(ToolPaths.game_pack())
	var scene = FileAccess.get_file_as_string("res://scenes/screens/character_select_screen.tscn")
	var printing = false
	for line in scene.split("\n"):
		if line.begins_with("[ext_resource") and (line.contains("CharacterSelectScreenBg") or line.contains("CharacterSelectScreen.cs")):
			print(line)
		if line.begins_with("[node "):
			printing = line.contains("name=\"CharacterSelectScreen\"") or line.contains("name=\"AnimatedBg\"")
		if printing:
			print(line)
	quit()
