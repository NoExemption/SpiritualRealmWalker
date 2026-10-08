extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")
func _initialize():
	ProjectSettings.load_resource_pack(ToolPaths.game_pack())
	var folder = DirAccess.open("res://images/atlases/ui_atlas.sprites/card")
	for name in folder.get_files():
		if "frame" in name or "portrait_border" in name:
			print(name)
	quit()