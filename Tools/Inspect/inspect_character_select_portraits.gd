extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func scan(path: String, depth: int = 0) -> void:
	if depth > 5:
		return
	for name in DirAccess.get_files_at(path):
		var full_path = path.path_join(name)
		if full_path.contains("character_select") and name.ends_with(".png.import"):
			var texture_path = full_path.trim_suffix(".import")
			var texture = load(texture_path) as Texture2D
			if texture:
				print("PORTRAIT_RESOURCE ",texture_path," SIZE ",texture.get_size())
		elif name.ends_with(".tscn") and name.contains("character_select"):
			var lines = FileAccess.get_file_as_string(full_path).split("\n")
			print("SCENE ",full_path)
			for line in lines:
				if line.contains("path=") or line.contains("offset_") or line.contains("custom_minimum_size") or line.contains("stretch_mode"):
					print(line)
	for name in DirAccess.get_directories_at(path):
		scan(path.path_join(name),depth+1)

func _initialize() -> void:
	if not ProjectSettings.load_resource_pack(ToolPaths.game_pack()):
		quit(1)
		return
	scan("res://images")
	scan("res://scenes/screens")
	print("BUTTON_SCENE ",FileAccess.get_file_as_string("res://scenes/screens/char_select/char_select_button.tscn"))
	var portrait = load("res://images/packed/character_select/char_select_ironclad.png") as Texture2D
	if portrait:
		portrait.get_image().save_png(ToolPaths.cache_dir().path_join("character-select-ironclad-reference.png"))
	quit(0)
