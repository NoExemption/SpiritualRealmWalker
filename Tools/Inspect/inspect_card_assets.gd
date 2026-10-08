extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")
func _initialize() -> void:
	ProjectSettings.load_resource_pack(ToolPaths.game_pack())
	for folder in ["res://fonts", "res://themes", "res://images/atlases/ui_atlas.sprites/card"]:
		print("FOLDER ", folder)
		var directory = DirAccess.open(folder)
		if directory:
			print(directory.get_directories())
			print(directory.get_files())
	quit(0)
