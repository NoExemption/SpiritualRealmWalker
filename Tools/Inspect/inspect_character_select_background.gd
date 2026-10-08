extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func _initialize() -> void:
	if not ProjectSettings.load_resource_pack(ToolPaths.game_pack()):
		quit(1)
		return
	for id in ["ironclad", "silent", "regent", "necrobinder", "defect"]:
		var folder = "res://animations/character_select/" + id
		print("CHARACTER ", id)
		for name in DirAccess.get_files_at(folder):
			var path = folder + "/" + name
			print("FILE ", name)
			if name.ends_with(".png") or name.ends_with(".png.import"):
				var image_path = path.trim_suffix(".import")
				var tex = load(image_path) as Texture2D
				print("TEXTURE ", image_path, " SIZE ", tex.get_size() if tex else "FAILED")
			elif name.ends_with(".atlas.remap"):
				print("REMAP ", FileAccess.get_file_as_string(path))
			elif name.ends_with(".atlas") or name.ends_with(".tres"):
				print("DATA ", path, " ", FileAccess.get_file_as_string(path).left(900))
		var bg_path = folder + "/character_select_" + id + "_bg.png.import"
		if FileAccess.file_exists(bg_path):
			print("IMPORT ", bg_path, " ", FileAccess.get_file_as_string(bg_path))
	quit(0)
