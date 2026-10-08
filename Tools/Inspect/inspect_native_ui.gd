extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")
func _initialize() -> void:
	ProjectSettings.load_resource_pack(ToolPaths.game_pack())
	var scene = FileAccess.get_file_as_string("res://scenes/cards/card.tscn")
	print(scene)
	quit(0)
