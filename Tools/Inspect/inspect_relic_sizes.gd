extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func _initialize() -> void:
	if not ProjectSettings.load_resource_pack(ToolPaths.game_pack()):
		quit(1)
		return
	for folder in ["res://images/relics", "res://images/atlases/relic_atlas.sprites", "res://images/atlases/relic_outline_atlas.sprites"]:
		walk(folder)
	quit(0)

func walk(folder: String) -> void:
	var dir = DirAccess.open(folder)
	if dir == null:
		print("MISSING ", folder)
		return
	print("FOLDER ", folder, " files=", dir.get_files().size())
	if folder == "res://images/relics":
		print("NAMES ", Array(dir.get_files()).slice(0, 12))
	var count = 0
	for file in dir.get_files():
		if not (file.ends_with(".tres") or file.ends_with(".png") or file.ends_with(".png.remap") or file.ends_with(".png.import")):
			continue
		if count >= 4:
			continue
		var path = folder.path_join(file.trim_suffix(".remap").trim_suffix(".import"))
		var texture = load(path) as Texture2D
		if texture == null:
			continue
		print("TEXTURE ", path, " size=", texture.get_size())
		if texture is AtlasTexture:
			print("ATLAS region=", texture.region, " margin=", texture.margin)
		count += 1
	for child in dir.get_directories():
		walk(folder.path_join(child))
